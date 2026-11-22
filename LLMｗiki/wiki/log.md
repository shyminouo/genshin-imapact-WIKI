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


## [2026-11-23] ingest | 擴充雷電將軍角色資料
- 依據 HoYoverse 官方 2.1 版本更新公告與角色介紹擴充 `raiden-shogun.md` 資料。
- 完善角色概覽、人物背景（無劇透概述）、精煉摘要（summary）與待查證項目。
- 追加官方來源登記至 `raw/sources/registry.md`。
- 更新 `wiki/index.md` 索引描述。

## [2026-11-23] lint | 離線資料驗證
- 透過驗證腳本執行欄位、型別、YAML 格式、日期格式、URL 與關聯之完整性檢查，全數符合規範。
