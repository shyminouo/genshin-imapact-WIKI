# AGENTS.md — 原神角色圖鑑 Agent 開發規範

> 本檔案是本專案的**唯一權威 Agent 規則**。其他指引如有衝突，以此檔案為準。
> 適用於 ChatGPT、Codex、Claude Code 等能讀取專案檔案的 Agent。
> 在開始任何修改前，**必須先讀完本檔案**，並檢查目標資料夾的現況。

## 0. 目標及驗收

這是一個繁體中文、非官方的《原神》角色介紹 Wiki，重視世界觀、角色設定、國家與人物關聯；不是最新傷害排行或配裝網站。

**主要目標**：把 Karpathy 的 LLM Wiki 模式改造成可持續擴充、可由同一份 Markdown 自動生成網頁的角色圖鑑。

每次 Agent 加入或修改角色時，必須符合：
1. 同一角色的事實只維護在 `wiki/characters/<slug>.md` 一處，不能手動複製一份到 HTML/JSON。
2. 使用既有 Astro 版型，角色列表與詳情頁自動生成；不得為每名角色另寫 HTML。
3. 每項新事實能追溯到具體來源；不確定的內容寫「待查證」，絕不編造。
4. 不產生失效的站內連結；角色關係如設為雙向，雙方均需更新。
5. 執行檢查，記錄本次變動；保證 GitHub Pages 部署所需路徑一致。

## 1. 四個層次＋一份治理文件

| 層次 | 位置 | 說明 | AI 權限 |
| --- | --- | --- | --- |
| 原始來源（Raw） | `raw/sources/` | 授權範圍內的資料、人工整理的來源清單與來源紀錄；留存出處 | **原始內容不可覆寫、刪除或改寫**；可新增檔案、可新增來源紀錄 |
| 知識層（Wiki） | `wiki/characters/`, `wiki/regions/` | 角色資料、世界觀、關聯；以 Markdown 為單一事實來源 | AI 可以在遵守本規範下新增/更新 |
| 呈現層（Site） | `src/`, `public/` | Astro 網頁、模板、搜尋篩選、樣式、圖片 | AI 可修改，但必須沿用共用元件與設計系統 |
| 發佈層（Deploy） | `.github/workflows/`, `astro.config.mjs` | GitHub Pages 靜態部署 | 不得破壞路徑設定及既有部署流程 |
| 治理文件 | `AGENTS.md` | 標準、限制、流程、品質標準 | **需明示理由才修改**，並更新紀錄 |

`wiki/index.md` 是供 Agent 定位的人工可讀目錄；實際網站列表由 Astro 讀取 Markdown 自動生成，**不依靠人工更新 index 才能顯示**。
`wiki/log.md` 是 append-only 操作紀錄。每次新增角色、修正來源、調整模板或檢查 Wiki 都須追加新條目。

## 2. 技術與網站視覺規範

- **Astro 5+ 靜態網站**、Markdown content collection、基本 TypeScript、原生 CSS / 少量瀏覽器 JS；無資料庫、無使用者登入、無執行時 AI API。
- 語系：繁體中文（`zh-Hant`），使用台灣常見的《原神》角色譯名。
- 版面：深海軍藍背景、淡金裝飾、元素色光暈、圓角角色卡、充足留白；重視可讀性及手機版。
- 共用視覺樣式修改於 `src/styles/global.css`；共用卡片修改於 `src/components/CharacterCard.astro`。
- **不得**為單一新角色加入專屬頁面 CSS、複製貼上版型或插入 inline 大量樣式。
- 可及性：互動元件有 label、圖片須有 alt、鍵盤可操作、文字對比足夠、保留 focus 樣式。
- **禁止使用來源不明的角色立繪**。預設使用專案原創、CSS 生成的元素風格佔位圖；取得素材使用授權及署名資料後，才能使用本地角色圖片。

## 3. 唯一角色資料格式

每名角色使用 `wiki/characters/<slug>.md`，**slug 必須是小寫英文字母、數字、連字號**，例如 `furina.md`。

角色 Frontmatter：

```yaml
---
name: "芙寧娜"
slug: "furina"
rarity: 5                 # 4 或 5
element: "水"            # 火/水/雷/冰/風/岩/草
weapon: "單手劍"        # 單手劍/雙手劍/長柄武器/法器/弓
region: "楓丹"
affiliation: ""         # 未確認可留空
tagline: "舞台與故事的交會"
summary: "簡短的無劇透摘要"
updatedAt: "2026-11-16"
status: "draft"          # draft / verified
spoilers: false          # 正文如含重大劇情，設 true
relations:
  - slug: "neuvillette"
    label: "楓丹劇情關聯"
sources:
  - title: "原神官方版本介紹"
    url: "https://genshin.hoyoverse.com/en/news/detail/113561"
    checkedAt: "2026-11-16"
---
```

Frontmatter 後使用 Markdown，建議章節順序：`## 角色概覽`、`## 人物背景`、`## 關聯說明`、`## 待查證`。
- `summary` 盡量 40～100 字，為 Agent 自行撰寫的摘要，不能大量複製原文。
- `status=verified` 僅限 **現有主要敘述已逐項核對來源**；否則用 `draft`。
- `updatedAt` 是 Wiki 編修日，不是遊戲角色更新日；`checkedAt` 是實際查閱來源的日期，不能憑空填寫。
- 請不要把玩家猜測、內鬼爆料、強度評級包裝為官方設定。
- 角色間的 `relations.slug` 必須指向既有角色檔；若是雙向關係，兩份檔案都要寫。
- **關係連結以 `relations` Frontmatter 為準**，網站會自動產生連結。正文不要使用 `./other-character.md` 相對 Markdown 連結，因為部署後會變成錯誤的 `.md` 網頁網址；若需在正文提及角色可用純文字。
- 角色名字與檔名無法直接翻譯推斷時，先確立穩定 slug，避免改名造成壞連結。

## 4. 編輯時的資料來源原則

來源優先順序：
1. 官方遊戲公告／角色介紹／遊戲內角色資料（保留明確網址或參考位置）
2. 有可查考依據的可靠社群整理（需區分整理者和官方原始出處）
3. 玩家心得或推測（必須標示為觀點，不寫入已確認事實）

- `raw/sources/registry.md` 記錄來源用途、URL、查閱日期、可否保存內文及版權備註。
- 網頁不可抓取受限內容或大段逐字轉載；只放自主撰寫摘要與連回來源的連結。
- 當新來源與舊資料衝突：比對日期/版本/可信度，標示差異，在確定前不要默默覆蓋。
- 有劇透的正文要 `spoilers: true`；首頁摘要與卡片不寫重大劇透。
- 各種技能數值及版本可變資訊先不納入第一版，除非額外定義 `gameVersion` 及查證流程。

## 5. Agent 工作流程

### A. Ingest — 新增一名角色

1. 讀 `AGENTS.md`、`wiki/index.md`、相關角色檔、`raw/sources/registry.md` 及角色模板。
2. 檢查 `wiki/characters/<slug>.md` 是否存在；存在時**更新**而不是建立第二份。
3. 核對至少一項官方或可信來源；把來源資料登記到 `raw/sources/registry.md`（不改寫既有來源內容）。
4. 依 `wiki/templates/character.template.md` 產生/更新角色 Markdown，資料不足的欄位保留空值或放 `## 待查證`。
5. 檢查關係並更新相關角色資料；避免不存在的引用。
6. 更新 `wiki/index.md` 和 `wiki/log.md`；首頁無須編輯，Astro 會自動讀取角色 Markdown。
7. 執行 `npm run check:data`、`npm run build`，修正錯誤；如果環境無法執行，誠實回報未驗證項目。
8. 回報：新增/修改檔案、來源、尚待確認事項、檢查結果。

### B. Query — 查詢、比較與新主題

1. 先讀 `wiki/index.md`，再讀相關角色及世界觀文件。
2. 引用對應 `sources`，不要把 Wiki 裡無來源的敘述當作百分百已確認。
3. 如查詢產生值得保留的比較，經確認後才新增 `wiki/regions/` 等整理頁；不能直接把聊天內容視為官方事實。
4. 增加新分類欄位須同時修改 Content Schema、模板、檢查程式與說明文件。

### C. Lint — 健康檢查

- Schema 必填欄位與值域、重複/不合法 slug、來源 URL、對應角色關係、日期格式。
- 孤兒角色、漏掉雙向連結的關係、失效內部連結、沒有可追溯來源的事實。
- `draft` 是否誤被當成已核對、文章重大劇透是否有標示。
- Web build、手機版、鍵盤操作、搜尋/篩選、GitHub Pages 的 `base` 是否正確。
- 對每次 Lint 的結果在 `wiki/log.md` 附簡短紀錄；沒檢查的項目不能報「通過」。

## 6. 檔案命名與變更守則

- `wiki/characters/`: 每角色一個英文 kebab-case `.md`。
- `wiki/regions/`: 每國家一個英文 kebab-case `.md`（Wiki 補充文件，第一版網站不主動顯示）。
- `src/components/`: `PascalCase.astro`；`src/pages/`: URL 友善名稱；`src/lib/`: 短小共用函式。
- 圖片只放 `public/images/`，須附來源/授權記錄；不允許不明來源熱連結。
- 保留原始來源，避免隨意全量覆寫、刪除或大型重構；先做最小可驗證改動。
- `.github/workflows/deploy.yml`、`astro.config.mjs` 一起決定網站部署：更名 repository 時須同步檢查 `SITE_URL`、`BASE_PATH`。
- 不要把 `node_modules/`、`dist/`、`.astro/` 提交到 GitHub。

## 7. 本次課堂作業的成功展示

1. 展示此 `AGENTS.md` 及 `wiki/templates/character.template.md`。
2. 展示已有 3 位角色、可瀏覽角色詳情與搜尋/篩選的網站。
3. 對 Agent 只說「請依照 AGENTS.md 新增一名角色」；不重複交代版型。
4. 驗證新增角色自動進入首頁、有固定版型、來源和相關角色連結，並展示 log。
5. 將完整 repo 推上 GitHub，使用 GitHub Pages 提供公開連結。

## 8. 本專案目前的邊界

- 範例資料是**小規模演示**，不是完整、持續更新的遊戲角色資料庫。
- 未提供正式角色立繪、技能數值、抽卡機率與配裝推薦。
- 若使用者僅要求修改文字，不要自行擴充大量新功能。
- 請先保證維護流程可靠，再增加搜尋、視覺化關聯、角色比較等進階功能。
