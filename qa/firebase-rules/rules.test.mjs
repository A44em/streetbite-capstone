// Security-rule tests for firestore.rules (Emulator Suite).
// Payloads mirror lib/core/services/firestore_service.dart.
import { after, before, beforeEach, describe, test } from 'node:test';
import { readFileSync } from 'node:fs';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  Bytes, addDoc, collection, deleteDoc, doc, getDoc, serverTimestamp, setDoc, updateDoc,
} from 'firebase/firestore';

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
const avatar = (n, extra = {}) => ({
  image: Bytes.fromUint8Array(new Uint8Array(n)), contentType: 'image/jpeg', updatedAt: serverTimestamp(), ...extra,
});

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-streetbite',
    firestore: { rules: readFileSync('../../firestore.rules', 'utf8'), host: '127.0.0.1', port: 8080 },
  });
});
after(async () => env?.cleanup());
beforeEach(async () => { await env.clearFirestore(); });

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

describe('avatar (profile photo in Firestore)', () => {
  const path = 'users/alice/avatar/current';
  test('owner can upload, replace, read and delete own avatar (saveAvatar)', async () => {
    await assertSucceeds(setDoc(doc(db(ALICE), path), avatar(60 * 1024)));
    await assertSucceeds(setDoc(doc(db(ALICE), path), avatar(1024)));
    await assertSucceeds(getDoc(doc(db(ALICE), path)));
    await assertSucceeds(deleteDoc(doc(db(ALICE), path)));
  });
  test('accepts exactly 500 KB, rejects larger or empty images', async () => {
    await assertSucceeds(setDoc(doc(db(ALICE), path), avatar(500 * 1024)));
    await assertFails(setDoc(doc(db(ALICE), path), avatar(500 * 1024 + 1)));
    await assertFails(setDoc(doc(db(ALICE), path), avatar(0)));
  });
  test('rejects non-image content type, non-bytes data and extra fields', async () => {
    await assertFails(setDoc(doc(db(ALICE), path), avatar(10, { contentType: 'text/html' })));
    await assertFails(setDoc(doc(db(ALICE), path), { ...avatar(10), image: 'data:image/jpeg;base64,AAAA' }));
    await assertFails(setDoc(doc(db(ALICE), path), avatar(10, { owner: 'bob' })));
  });
  test('only the single current avatar document is allowed', async () => {
    await assertFails(setDoc(doc(db(ALICE), 'users/alice/avatar/other'), avatar(10)));
  });
  test('other user and unauthenticated cannot read, write or delete', async () => {
    await env.withSecurityRulesDisabled((c) => setDoc(doc(c.firestore(), path), avatar(10)));
    await assertFails(getDoc(doc(db(BOB), path)));
    await assertFails(setDoc(doc(db(BOB), path), avatar(10)));
    await assertFails(deleteDoc(doc(db(BOB), path)));
    await assertFails(getDoc(doc(db(null), path)));
  });
});
