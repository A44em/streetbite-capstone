// TC_SECURITY_001 against the LIVE project: user A attempts to access user B's data.
// Reads credentials from local env files and the API key from google-services.json;
// prints only HTTP statuses (no tokens, passwords, or keys).
import { readFileSync } from 'node:fs';
import { homedir } from 'node:os';

const env = (file) => Object.fromEntries(readFileSync(file, 'utf8').split('\n')
  .map((l) => l.replace(/^export /, '').split('=')).filter((p) => p.length === 2));
const a = env(`${homedir()}/.config/streetbite-qa/credentials.env`);
const b = env(`${homedir()}/.config/streetbite-qa/credentials-signup.env`);
const gs = JSON.parse(readFileSync(new URL('../../android/app/google-services.json', import.meta.url)));
const key = gs.client[0].api_key[0].current_key;
const project = gs.project_info.project_id;
const base = `https://firestore.googleapis.com/v1/projects/${project}/databases/(default)/documents`;

async function signIn(email, password) {
  const r = await fetch(`https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${key}`, {
    method: 'POST', headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password, returnSecureToken: true }),
  });
  const j = await r.json();
  if (!r.ok) throw new Error(`sign-in failed: ${r.status}`);
  return { uid: j.localId, token: j.idToken };
}
// token === null sends a genuinely unauthenticated request (API key only).
const call = async (method, path, token, body) => {
  const sep = path.includes('?') ? '&' : '?';
  const url = token ? `${base}/${path}` : `${base}/${path}${sep}key=${key}`;
  const headers = { 'Content-Type': 'application/json' };
  if (token) headers.Authorization = `Bearer ${token}`;
  return (await fetch(url, { method, headers, body: body && JSON.stringify(body) })).status;
};

const A = await signIn(a.STREETBITE_TEST_EMAIL, a.STREETBITE_TEST_PASSWORD);
const B = await signIn(b.SIGNUP_EMAIL, b.SIGNUP_PASSWORD);
const rows = [];
const check = async (label, expectOk, p) => {
  const status = await p;
  const ok = expectOk ? status === 200 : status === 403;
  rows.push({ label, status, expected: expectOk ? 200 : 403, result: ok ? 'PASS' : 'FAIL' });
};
await check('B reads own profile (control)', true, call('GET', `users/${B.uid}`, B.token));
await check('B lists own favourites (control)', true, call('GET', `users/${B.uid}/favourites`, B.token));
await check('B lists own orders (control)', true, call('GET', `users/${B.uid}/orders`, B.token));
await check('A reads B profile', false, call('GET', `users/${B.uid}`, A.token));
await check('A lists B favourites', false, call('GET', `users/${B.uid}/favourites`, A.token));
await check('A lists B orders', false, call('GET', `users/${B.uid}/orders`, A.token));
await check('A overwrites B profile name', false,
  call('PATCH', `users/${B.uid}?updateMask.fieldPaths=name`, A.token, { fields: { name: { stringValue: 'hacked' } } }));
await check('A writes favourite into B', false,
  call('PATCH', `users/${B.uid}/favourites/1`, A.token, { fields: { id: { stringValue: '1' } } }));
await check('A creates order for B', false, call('POST', `users/${B.uid}/orders`, A.token, {
  fields: { total: { doubleValue: 1 }, items: { arrayValue: { values: [{ stringValue: 'x' }] } } },
}));
await check('Unauthenticated reads B profile', false, call('GET', `users/${B.uid}`, null));
await check('Unauthenticated lists B orders', false, call('GET', `users/${B.uid}/orders`, null));
console.table(rows.map(({ label, status, expected, result }) => ({ label, status, expected, result })));
const failed = rows.filter((r) => r.result !== 'PASS').length;
console.log(`${rows.length - failed}/${rows.length} checks passed`);
process.exit(failed ? 1 : 0);
