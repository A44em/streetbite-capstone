// Security-rule tests for firestore.rules and storage.rules.
// Payloads mirror lib/core/services/firestore_service.dart and profile_screen.dart.
import { after, before, beforeEach, describe, test } from 'node:test';
import { readFileSync } from 'node:fs';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  addDoc, collection, deleteDoc, doc, getDoc, serverTimestamp, setDoc, updateDoc,
} from 'firebase/firestore';
import { getBytes, ref, uploadBytes } from 'firebase/storage';

const ALICE = { uid: 'alice', email: 'alice@example.com' };
const BOB = { uid: 'bob', email: 'bob@example.com' };
let env;

const profile = (u) => ({ id: u.uid, name: 'Alice', email: u.email, updatedAt: serverTimestamp() });
const meal = { id: '53322', name: 'Flan', image: 'x', category: 'Dessert', area: 'Uruguayan', instructions: 'y', price: 120 };
const order = {
  items: [{ id: '53322', name: 'Flan', price: 120, image: 'x' }],
  total: 120, paymentMethod: 'cash', status: 'placed', createdAt: serverTimestamp(),
};
const db = (u) => (u ? env.authenticatedContext(u.uid, { email: u.email }) : env.unauthenticatedContext()).firestore();
const st = (u) => (u ? env.authenticatedContext(u.uid, { email: u.email }) : env.unauthenticatedContext()).storage();
const jpeg = (n) => new Uint8Array(n);

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-streetbite',
    firestore: { rules: readFileSync('../../firestore.rules', 'utf8'), host: '127.0.0.1', port: 8080 },
    storage: { rules: readFileSync('../../storage.rules', 'utf8'), host: '127.0.0.1', port: 9199 },
  });
});
after(async () => env?.cleanup());
beforeEach(async () => { await env.clearFirestore(); await env.clearStorage(); });

describe('users/{uid} profile', () => {
  test('owner can create own profile (app saveProfile, merge)', async () => {
    await assertSucceeds(setDoc(doc(db(ALICE), 'users/alice'), profile(ALICE), { merge: true }));
  });
  test('owner can read and update own profile (savePhotoUrl, merge)', async () => {
    await setDoc(doc(db(ALICE), 'users/alice'), profile(ALICE));
    await assertSucceeds(getDoc(doc(db(ALICE), 'users/alice')));
    await assertSucceeds(setDoc(doc(db(ALICE), 'users/alice'), { photoUrl: 'https://x' }, { merge: true }));
  });
  test('create rejected when email differs from token email', async () => {
    await assertFails(setDoc(doc(db(ALICE), 'users/alice'), { ...profile(ALICE), email: 'Alice@Example.com' }));
  });
  test('create rejected when id differs from uid', async () => {
    await assertFails(setDoc(doc(db(ALICE), 'users/alice'), { ...profile(ALICE), id: 'bob' }));
  });
  test('owner cannot change id on update', async () => {
    await setDoc(doc(db(ALICE), 'users/alice'), profile(ALICE));
    await assertFails(updateDoc(doc(db(ALICE), 'users/alice'), { id: 'bob' }));
  });
  test('owner cannot delete profile', async () => {
    await setDoc(doc(db(ALICE), 'users/alice'), profile(ALICE));
    await assertFails(deleteDoc(doc(db(ALICE), 'users/alice')));
  });
  test('other user cannot read, create, or update', async () => {
    await env.withSecurityRulesDisabled((c) => setDoc(doc(c.firestore(), 'users/alice'), profile(ALICE)));
    await assertFails(getDoc(doc(db(BOB), 'users/alice')));
    await assertFails(setDoc(doc(db(BOB), 'users/alice'), { photoUrl: 'evil' }, { merge: true }));
    await assertFails(setDoc(doc(db(BOB), 'users/carol'), { ...profile(BOB), id: 'carol' }));
  });
  test('unauthenticated access denied', async () => {
    await assertFails(getDoc(doc(db(null), 'users/alice')));
    await assertFails(setDoc(doc(db(null), 'users/alice'), profile(ALICE)));
  });
});

describe('favourites', () => {
  test('owner can add, read, and remove a favourite (toggleFavourite)', async () => {
    const f = doc(db(ALICE), 'users/alice/favourites/53322');
    await assertSucceeds(setDoc(f, meal));
    await assertSucceeds(getDoc(f));
    await assertSucceeds(deleteDoc(f));
  });
  test('favourite doc id must equal payload id', async () => {
    await assertFails(setDoc(doc(db(ALICE), 'users/alice/favourites/999'), meal));
  });
  test('other user cannot read or write favourites', async () => {
    await env.withSecurityRulesDisabled((c) => setDoc(doc(c.firestore(), 'users/alice/favourites/53322'), meal));
    await assertFails(getDoc(doc(db(BOB), 'users/alice/favourites/53322')));
    await assertFails(setDoc(doc(db(BOB), 'users/alice/favourites/53322'), meal));
    await assertFails(deleteDoc(doc(db(BOB), 'users/alice/favourites/53322')));
  });
});

describe('orders', () => {
  test('owner can place and read orders (placeOrder)', async () => {
    const r = await assertSucceeds(addDoc(collection(db(ALICE), 'users/alice/orders'), order));
    await assertSucceeds(getDoc(r));
  });
  test('empty or zero-total orders rejected', async () => {
    await assertFails(addDoc(collection(db(ALICE), 'users/alice/orders'), { ...order, items: [] }));
    await assertFails(addDoc(collection(db(ALICE), 'users/alice/orders'), { ...order, total: 0 }));
  });
  test('orders are immutable', async () => {
    await env.withSecurityRulesDisabled((c) => setDoc(doc(c.firestore(), 'users/alice/orders/o1'), order));
    await assertFails(updateDoc(doc(db(ALICE), 'users/alice/orders/o1'), { total: 1 }));
    await assertFails(deleteDoc(doc(db(ALICE), 'users/alice/orders/o1')));
  });
  test('other user cannot read or create orders', async () => {
    await env.withSecurityRulesDisabled((c) => setDoc(doc(c.firestore(), 'users/alice/orders/o1'), order));
    await assertFails(getDoc(doc(db(BOB), 'users/alice/orders/o1')));
    await assertFails(addDoc(collection(db(BOB), 'users/alice/orders'), order));
  });
});

describe('storage profiles/{uid}', () => {
  const meta = { contentType: 'image/jpeg' };
  test('owner can upload and read own avatar (<5 MB JPEG)', async () => {
    await assertSucceeds(uploadBytes(ref(st(ALICE), 'profiles/alice/avatar.jpg'), jpeg(1024), meta));
    await assertSucceeds(getBytes(ref(st(ALICE), 'profiles/alice/avatar.jpg')));
  });
  test('non-image and oversized uploads rejected', async () => {
    await assertFails(uploadBytes(ref(st(ALICE), 'profiles/alice/a.txt'), jpeg(10), { contentType: 'text/plain' }));
    await assertFails(uploadBytes(ref(st(ALICE), 'profiles/alice/big.jpg'), jpeg(5 * 1024 * 1024 + 1), meta));
  });
  test('other user and unauthenticated cannot read or write', async () => {
    await env.withSecurityRulesDisabled((c) => uploadBytes(ref(c.storage(), 'profiles/alice/avatar.jpg'), jpeg(10), meta));
    await assertFails(getBytes(ref(st(BOB), 'profiles/alice/avatar.jpg')));
    await assertFails(uploadBytes(ref(st(BOB), 'profiles/alice/avatar.jpg'), jpeg(10), meta));
    await assertFails(getBytes(ref(st(null), 'profiles/alice/avatar.jpg')));
  });
  test('paths outside profiles/ are denied', async () => {
    await assertFails(uploadBytes(ref(st(ALICE), 'public/x.jpg'), jpeg(10), meta));
  });
});
