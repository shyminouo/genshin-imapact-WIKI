import fs from 'node:fs';
import path from 'node:path';
import { parseDocument } from 'yaml';

const dir = path.resolve('wiki/characters');
const files = fs.readdirSync(dir).filter(name => name.endsWith('.md'));
const errors = [];
const entities = new Map();
const validElements = new Set(['火','水','雷','冰','風','岩','草']);
const validWeapons = new Set(['單手劍','雙手劍','長柄武器','法器','弓']);
const dateValid = value => typeof value === 'string' && /^\d{4}-\d{2}-\d{2}$/.test(value) && !Number.isNaN(Date.parse(value));

for (const file of files) {
  const text = fs.readFileSync(path.join(dir, file), 'utf8');
  const match = text.match(/^---\s*\r?\n([\s\S]*?)\r?\n---(?:\r?\n|$)/);
  if (!match) { errors.push(`${file}: 缺少 YAML frontmatter`); continue; }
  const doc = parseDocument(match[1], { uniqueKeys: true });
  for (const issue of doc.errors) errors.push(`${file}: YAML ${issue.message}`);
  if (doc.errors.length) continue;
  const d = doc.toJS();
  const required = ['name','slug','rarity','element','weapon','region','tagline','summary','updatedAt','status','spoilers','relations','sources'];
  for (const key of required) if (d[key] === undefined || d[key] === null || d[key] === '') errors.push(`${file}: 欄位 ${key} 未填`);
  if (!/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(d.slug || '')) errors.push(`${file}: slug 格式錯誤`);
  if (file !== `${d.slug}.md`) errors.push(`${file}: 檔名必須與 slug 一致`);
  if (entities.has(d.slug)) errors.push(`${file}: slug 重複`);
  entities.set(d.slug, d);
  if (![4,5].includes(d.rarity)) errors.push(`${file}: rarity 必須是 4 或 5`);
  if (!validElements.has(d.element)) errors.push(`${file}: element 無效`);
  if (!validWeapons.has(d.weapon)) errors.push(`${file}: weapon 無效`);
  if (!['draft','verified'].includes(d.status)) errors.push(`${file}: status 必須 draft/verified`);
  if (typeof d.spoilers !== 'boolean') errors.push(`${file}: spoilers 必須布林值`);
  if (!dateValid(d.updatedAt)) errors.push(`${file}: updatedAt 日期格式錯誤`);
  if (!Array.isArray(d.relations)) errors.push(`${file}: relations 必須陣列`);
  if (!Array.isArray(d.sources) || d.sources.length < 1) errors.push(`${file}: 至少一個來源`);
  for (const s of Array.isArray(d.sources) ? d.sources : []) {
    if (!s.title || typeof s.title !== 'string') errors.push(`${file}: source.title 不可空白`);
    try { const url = new URL(s.url); if (!['http:', 'https:'].includes(url.protocol)) throw Error('protocol'); }
    catch { errors.push(`${file}: 無效來源網址 ${s.url}`); }
    if (!dateValid(s.checkedAt)) errors.push(`${file}: source.checkedAt 日期格式錯誤`);
  }
}
for (const [slug, d] of entities) {
  const relations = Array.isArray(d.relations) ? d.relations : [];
  const seen = new Set();
  for (const r of relations) {
    if (!r?.slug || !r.label) { errors.push(`${slug}: relation 缺少 slug 或 label`); continue; }
    if (r.slug === slug) errors.push(`${slug}: 不能連結自己`);
    if (seen.has(r.slug)) errors.push(`${slug}: 關聯重複 ${r.slug}`);
    seen.add(r.slug);
    if (!entities.has(r.slug)) errors.push(`${slug}: 連結不存在角色 ${r.slug}`);
    else if (!(entities.get(r.slug)?.relations || []).some(other => other.slug === slug)) errors.push(`${slug}: ${r.slug} 缺少回連（本專案關聯要求雙向）`);
  }
}
if (errors.length) {
  console.error(`✗ Wiki 檢查失敗，共 ${errors.length} 項：`);
  for (const error of errors) console.error(`  - ${error}`);
  process.exitCode = 1;
} else {
  console.log(`✓ Wiki 資料檢查通過：${files.length} 名角色；slug、欄位、來源及雙向關聯正確。`);
}
