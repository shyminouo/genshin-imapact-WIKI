import fs from 'node:fs';
import path from 'node:path';

const errors = [];
const runPath = path.resolve('workflow/runs/2026-11-23-01');
const jsonFile = path.join(runPath, 'slide-content.json');

if (!fs.existsSync(jsonFile)) {
  console.error('✗ 找不到 slide-content.json');
  process.exit(1);
}

let data;
try {
  data = JSON.parse(fs.readFileSync(jsonFile, 'utf8'));
} catch (e) {
  errors.push(`slide-content.json 不是合法的 JSON: ${e.message}`);
}

if (data) {
  if (!Array.isArray(data.slides) || data.slides.length < 10 || data.slides.length > 12) {
    errors.push(`投影片總頁數應在 10～12 頁之間，目前為: ${data.slides?.length}`);
  }

  const seenIds = new Set();
  const registryText = fs.readFileSync(path.resolve('raw/sources/registry.md'), 'utf8');

  data.slides?.forEach((slide, idx) => {
    const slideIdx = idx + 1;
    if (!slide.id) errors.push(`第 ${slideIdx} 頁缺少 id`);
    if (seenIds.has(slide.id)) errors.push(`第 ${slideIdx} 頁 id 重複: ${slide.id}`);
    seenIds.add(slide.id);

    if (!slide.title) errors.push(`第 ${slideIdx} 頁 (${slide.id}) 缺少 title`);
    if (!slide.objective) errors.push(`第 ${slideIdx} 頁 (${slide.id}) 缺少 objective`);

    if (slide.id !== 'slide-01-cover' && (!Array.isArray(slide.citations) || slide.citations.length === 0)) {
      errors.push(`非導航頁 ${slide.id} 的 citations 不可為空`);
    }

    if (Array.isArray(slide.citations)) {
      slide.citations.forEach(c => {
        if (!c.wikiPath || !c.sourceId || !c.claimId) {
          errors.push(`第 ${slideIdx} 頁 citation 格式不全`);
          return;
        }
        const targetWiki = path.resolve(c.wikiPath);
        if (!fs.existsSync(targetWiki)) {
          errors.push(`第 ${slideIdx} 頁引用的 wikiPath 不存在: ${c.wikiPath}`);
        }
        if (!registryText.includes(c.sourceId)) {
          errors.push(`第 ${slideIdx} 頁引用的 sourceId 未在 registry.md 中登記: ${c.sourceId}`);
        }
      });
    }

    slide.blocks?.forEach(b => {
      if (b.type === 'character-showcase') {
        b.examples?.forEach(ex => {
          const charFile = path.resolve(`wiki/characters/${ex.slug}.md`);
          if (!fs.existsSync(charFile)) {
            errors.push(`角色範例 ${ex.slug} 不存在於 wiki/characters/`);
          }
        });
      }
      if (b.type === 'interactive-quiz') {
        b.questions?.forEach(q => {
          if (!Array.isArray(q.options) || q.options.length < 2) {
            errors.push(`測驗題 ${q.id} 選項不足 2 個`);
          }
          if (typeof q.answerIndex !== 'number' || q.answerIndex < 0 || q.answerIndex >= q.options.length) {
            errors.push(`測驗題 ${q.id} answerIndex 超出選項範圍`);
          }
          if (!q.explanation) {
            errors.push(`測驗題 ${q.id} 缺少 explanation`);
          }
        });
      }
    });
  });
}

const astroFile = path.resolve('src/pages/tutorial/index.astro');
const cssFile = path.resolve('src/styles/tutorial.css');
if (!fs.existsSync(astroFile)) errors.push('找不到 src/pages/tutorial/index.astro');
if (!fs.existsSync(cssFile)) errors.push('找不到 src/styles/tutorial.css');

if (errors.length) {
  console.error(`✗ 教學簡報資料檢查失敗，共 ${errors.length} 項：`);
  errors.forEach(e => console.error(`  - ${e}`));
  process.exit(1);
} else {
  console.log(`✓ 教學簡報資料檢查通過：12 頁投影片；JSON 語法、唯一 ID、引用存在性、測驗結構、角色對照及 Astro 頁面檔案全數正確。`);
}
