# Wiki Log｜追加式維護紀錄

> 新紀錄**加在檔案末端**，禁止移除舊紀錄。建議格式：`## [YYYY-MM-DD] ingest|query|lint|site | 簡稱`。

## [2026-11-16] ingest | 初始角色資料
- 加入 `furina.md`、`neuvillette.md`、`raiden-shogun.md`，均為示範草稿。
- 設定芙寧娜與那維萊特之間的雙向關聯。
- 建立國度 Wiki、來源登記與索引。

## [2026-11-16] site | Astro 角色圖鑑骨架
- 新增首頁的角色卡片、搜尋與元素／地區篩選，動態角色詳情頁，以及關於頁。
- 使用 CSS 元素圖樣，未使用任何官方角色圖片。
- 加入 GitHub Pages workflow 與資料檢查程式。

## [2026-11-16] lint | 初版離線資料檢查
- 以離線工具檢查 YAML frontmatter、必要欄位、來源網址、slug 與角色關聯。
- Astro 專案實際 `npm install`／`npm run build` 尚待有網路的環境確認；不可宣稱建置已通過。
