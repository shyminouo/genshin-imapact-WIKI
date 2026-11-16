# 提瓦特角色觀測站｜Genshin Character Wiki Starter

> 非官方、教學用途的《原神》繁體中文角色圖鑑。以 Karpathy 的 LLM Wiki 概念為基底，用 **Markdown 作為 Wiki 單一資料來源**，再由 **Astro** 產生可部署至 GitHub Pages 的角色網站。

**請先讀 [`AGENTS.md`](./AGENTS.md)**。`agent.md` 只是轉址提醒，真正規則只有 `AGENTS.md`。

## 本專案已包含

- 3 名示範角色：芙寧娜、那維萊特、雷電將軍（均標為資料待擴充的 `draft`）
- 搜尋、元素篩選、地區篩選、角色詳情頁與站內關聯
- 單一 Markdown 角色資料、YAML Frontmatter schema、Wiki 索引與 append-only log
- 原始資料來源登記、角色模板、資料檢查腳本、GitHub Pages Action
- 原創 CSS 元素風格佔位卡片：不含未取得授權的遊戲圖片

## 開始使用

需求：**Node.js 20.19+ 或 22.12+** 以及 npm（建議 Node.js 22 LTS 以上）。

```bash
npm install
npm run check:data
npm run dev
```

在瀏覽器打開終端機顯示的本機網址（一般是 `http://localhost:4321`）。

建置靜態網站：

```bash
npm run build
npm run preview
```

> 本 ZIP 交付環境未提供 npm 網路安裝，因此無法在封裝時實際執行 `npm install` 與 Astro 建置；請在有網路的本機或 GitHub Actions 執行。資料格式另已做離線檢查。

## 給 Agent 的新增角色指令範例

「請先讀 `AGENTS.md`，依 Ingest 流程新增角色 `nahida`。先查核來源，再新增 Markdown、更新相關角色的關係與 `wiki/index.md`、`wiki/log.md`，最後執行資料檢查和建置。不要重寫任何角色頁面的 HTML。」

## 專案結構

```text
genshin-wiki-starter/
├── AGENTS.md             # 唯一權威的 AI 開發規範
├── agent.md              # 小寫檔案：指向 AGENTS.md
├── raw/sources/          # 來源登記、原始資料（保留不修改）
├── wiki/
│   ├── characters/       # 單一事實來源：角色 Markdown
│   ├── regions/          # 補充世界觀條目
│   ├── templates/        # 新增角色模板
│   ├── index.md          # Agent 導覽目錄
│   └── log.md            # 變更紀錄（append only）
├── src/
│   ├── content.config.ts # 資料欄位驗證
│   ├── components/       # 共用角色卡、頁首
│   ├── layouts/          # 共用頁面外框
│   ├── lib/              # 色彩、網址處理
│   ├── pages/            # 首頁／動態角色頁／關於
│   └── styles/           # 全站設計系統
├── scripts/check-data.mjs
├── .github/workflows/deploy.yml
└── astro.config.mjs
```

## GitHub Pages 部署

1. 在 GitHub 建立新 Repository，例如 `genshin-wiki-starter`。
2. 上傳**專案內所有檔案**（包含隱藏的 `.github/workflows/deploy.yml`），不要把最外層資料夾又包一層。
3. **重要：** 若 Repository 不是 `genshin-wiki-starter`，請在 GitHub Repository 的 **Settings → Secrets and variables → Actions → Variables** 設定 `BASE_PATH` 為 `/<你的repo名稱>`。
4. 同一位置可設定 `SITE_URL` 為 `https://<GitHub使用者名稱>.github.io`（未設定時以示意網址建置；不影響主要頁面連結，但建議正式部署前設定）。
5. 到 **Settings → Pages → Build and deployment** 將 Source 設為 **GitHub Actions**。
6. 將程式推送到 `main`；Actions 會以 Astro 建置並部署。
7. 瀏覽 `https://<GitHub使用者名稱>.github.io/<你的repo名稱>/`。
8. 本機 `npm install` 會產生 `package-lock.json`；建議把它提交 GitHub，固定相依版本。

若你的 repo 名稱是 `<username>.github.io`，請將 `BASE_PATH` 設為 `/`；如果改用自訂網域，請同步調整 `SITE_URL`。

## 內容與版權

《原神》及角色、商標等屬於其權利人。本專案為非官方教學作品，不代表 HoYoverse 官方立場。範例資料僅提供少量自行撰寫摘要及外部來源連結，角色封面是原創 CSS 元素風格圖樣；若未來加入官方立繪，請先查核素材使用規範及署名要求。

## 參考文件

- [Astro Content Collections](https://docs.astro.build/zh-tw/guides/content-collections/)
- [Astro GitHub Pages 部署](https://docs.astro.build/zh-tw/guides/deploy/github/)
- [官方《原神》網站](https://genshin.hoyoverse.com/)
