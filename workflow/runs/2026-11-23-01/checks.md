# Test & Verification Report — 簡報功能與資料驗收報告

- **Run ID**: `2026-11-23-01`
- **執行節點**: Tester
- **測試日期**: 2026-11-23
- **測試對象**: `slide-content.json`、`src/pages/tutorial/index.astro`、`src/styles/tutorial.css`、`src/components/Header.astro`、Wiki 角色與概念資料

---

## 一、驗收規範三大類別查驗結果

### 1. 知識與教學驗收（Pedagogy & Knowledge Coverage）
- **查驗項目**：
  - [x] 有效核心來源至少五份（S006～S010），並結合既有角色官方來源（S001～S005, S011～S016）。
  - [x] 投影片全部重要主張均具備明確之 `wikiPath`、`sourceId` 與 `claimId`，無憑空捏造。
  - [x] 內容循序漸進：基礎名詞 ➔ 七元素 ➔ 反應概念 ➔ 增幅劇變 ➔ 武器普攻 ➔ 角色定位 ➔ 實戰角色 ➔ 四人隊伍 ➔ 避坑 ➔ 測驗 ➔ 總結。
  - [x] 實戰小測驗共 3 題，答案索引正確，解釋清楚且引用底層 Wiki 依據。
- **評定**：`PASS`

### 2. 結構與靜態語法驗收（Structure & Schema Validation）
- **執行命令**：
  - `powershell -ExecutionPolicy Bypass -File scripts/check-data.ps1`
  - `powershell -ExecutionPolicy Bypass -File scripts/check-tutorial.ps1`
- **命令輸出紀錄**：
  - `check-data.ps1`：`✓ Wiki 資料檢查通過：6 名角色；slug、欄位、來源及雙向關聯正確。`
  - `check-tutorial.ps1`：`✓ 教學簡報資料檢查通過：12 頁投影片；JSON 語法、唯一 ID、引用存在性、測驗結構、角色對照及 Astro 頁面檔案全數正確。`
- **具體核對項**：
  - [x] `slide-content.json` 包含 12 頁投影片（符合 10～12 頁規範）。
  - [x] 每頁具備唯一 `id`、`title`、`objective`、`blocks` 與 `citations`。
  - [x] 測驗題 `answerIndex` 在有效範圍內，且對應題目正確解答。
  - [x] Slide 8 引用之 6 名角色 slug（`neuvillette`, `furina`, `diluc`, `jean`, `venti`, `raiden-shogun`）在 `wiki/characters/` 均有實體 Markdown。
- **評定**：`PASS`

### 3. 頁面與互動驗收（UI & Interactivity）
- **查驗項目**：
  - [x] `Header.astro` 加入 `tutorial/` 導覽入口，未覆蓋既有首頁。
  - [x] `src/pages/tutorial/index.astro` 採用統一 `BaseLayout`，深藍淡金視覺系統。
  - [x] 前後翻頁具備邊界禁用（第 1 頁上一頁 disabled，第 12 頁下一頁 disabled）。
  - [x] 支援下拉選單直接跳頁（1~12 頁）。
  - [x] 支援鍵盤方向鍵（`ArrowLeft`, `ArrowRight`, `PageUp`, `PageDown`）快速切換，且排除 input/select 避免焦點衝突。
  - [x] 測驗即時互動：點擊選項即時判定對錯、變換綠/紅色、顯示解析與引用出處。
  - [x] 站內路徑全部使用 `sitePath()`，符合 Astro Base Path 與 GitHub Pages 規範。
- **評定**：`PASS`

---

## 二、環境限制與未驗證項目（誠實回報）

- **沙盒環境限制**：當前沙盒環境 PATH 中無 `npm`、`node` 與 `git` 可執行檔，因此：
  - 本次自動化資料驗證與結構檢查均透過等價之 PowerShell 驗證腳本執行通過。
  - 實際靜態編譯生成 `dist/` 與發布指令（`npm run build`、`git push`）留待外部標準 Node.js 環境執行。
- **外部驗證指令**：
  ```bash
  npm run check:data
  npm run check:tutorial
  npm run build
  ```
