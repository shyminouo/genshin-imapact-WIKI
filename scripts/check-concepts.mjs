import fs from 'node:fs';
import path from 'node:path';
import { parseDocument } from 'yaml';

const dir = path.resolve('wiki/concepts');
const files = fs.readdirSync(dir).filter(name => name.endsWith('.md'));
const errors = [];
const registryText = fs.readFileSync(path.resolve('raw/sources/registry.md'), 'utf8');

const charSlugs = new Set(
  fs.readdirSync(path.resolve('wiki/characters'))
    .filter(f => f.endsWith('.md'))
    .map(f => f.replace('.md', ''))
);

const allConceptSlugs = new Set(files.map(f => f.replace('.md', '')));

for (const file of files) {
  const text = fs.readFileSync(path.join(dir, file), 'utf8');
  const match = text.match(/^---\s*\r?\n([\s\S]*?)\r?\n---(?:\r?\n|$)/);
  if (!match) { errors.push(`${file}: 缺少 YAML frontmatter`); continue; }
  const doc = parseDocument(match[1], { uniqueKeys: true });
  for (const issue of doc.errors) errors.push(`${file}: YAML ${issue.message}`);
  if (doc.errors.length) continue;
  const d = doc.toJS();

  const required = ['title', 'slug', 'summary', 'updatedAt', 'status', 'sourceIds', 'relatedConcepts', 'relatedCharacters'];
  for (const k of required) {
    if (d[k] === undefined || d[k] === null || d[k] === '') errors.push(`${file}: 欄位 ${k} 未填`);
  }
  if (file !== `${d.slug}.md`) errors.push(`${file}: 檔名與 slug 不一致 (${d.slug})`);
  if (!/^\d{4}-\d{2}-\d{2}$/.test(d.updatedAt || '')) errors.push(`${file}: updatedAt 日期格式錯誤`);
  if (!['draft', 'verified'].includes(d.status)) errors.push(`${file}: status 必須為 draft 或 verified`);

  if (Array.isArray(d.sourceIds)) {
    for (const sid of d.sourceIds) {
      if (!registryText.includes(sid)) errors.push(`${file}: sourceId ${sid} 未在 registry.md 中登記`);
    }
  }

  if (Array.isArray(d.relatedConcepts)) {
    for (const cslug of d.relatedConcepts) {
      if (!allConceptSlugs.has(cslug)) errors.push(`${file}: relatedConcept '${cslug}' 不存在`);
    }
  }

  if (Array.isArray(d.relatedCharacters)) {
    for (const chslug of d.relatedCharacters) {
      if (!charSlugs.has(chslug)) errors.push(`${file}: relatedCharacter '${chslug}' 不存在於 wiki/characters/`);
    }
  }

  const reqSections = ['## 基本定義', '## 機制與例子', '## 常見誤解', '## 相關知識', '## 來源與限制', '## 待查證'];
  for (const sec of reqSections) {
    if (!text.includes(sec)) errors.push(`${file}: 缺少必要章節 '${sec}'`);
  }
}

if (errors.length) {
  console.error(`✗ 概念頁檢查失敗，共 ${errors.length} 項：`);
  for (const error of errors) console.error(`  - ${error}`);
  process.exitCode = 1;
} else {
  console.log(`✓ 概念頁檢查通過：${files.length} 篇概念；Frontmatter、來源、關聯概念、角色與必要章節全數正確。`);
}
