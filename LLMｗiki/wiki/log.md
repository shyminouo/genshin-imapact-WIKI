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


## [2026-11-23] site | 對齊 AGENTS.md v2.0 架構與第二次作業規範
- 建立 `wiki/templates/source.template.md`（來源摘要模板）與 `wiki/templates/concept.template.md`（概念頁模板）。
- 建立 `workflow/graph-v1.md`（工作流程定義與 Mermaid 流程圖）、`workflow/execution-log.md`（追加式執行紀錄）與 `workflow/reflection.md`（反思文件結構）。
- 於 `raw/sources/registry.md` 追加既有來源 ID 對照清單（S001～S005）。
- 更新 `agent.md` 與 `wiki/index.md` 知識索引以支援概念、來源摘要與工作流程結構。


## [2026-11-23] ingest | 完成五篇教學核心來源與概念頁匯入
- 完成 5 份獨立且可追溯之來源 Raw 擷取紀錄：`S006-elements-guide.md`、`S007-elemental-reactions-guide.md`、`S008-weapons-guide.md`、`S009-character-roles-guide.md`、`S010-team-building-guide.md`。
- 完成 5 份來源摘要與可核實主張抽取：`s006`～`s010`。
- 建立並整合 5 大概念頁：`elements.md`、`elemental-reactions.md`、`weapons.md`、`character-roles.md`、`team-building.md`，均附主張 ID 與雙向關聯。
- 追加更新 `raw/sources/registry.md` 來源登記表。
- 更新 `wiki/index.md` 目錄結構。


## [2026-11-23] ingest | 新增三名蒙德角色（琴、迪盧克、溫迪）
- 依據 AGENTS.md Ingest 流程新增三名蒙德五星核心角色：`jean.md`、`diluc.md`、`venti.md`。
- 嚴格依照 `wiki/templates/character.template.md` 規範撰寫，每位角色具備完整必填欄位、無劇透精準摘要（40～100字）、角色概覽、人物背景、關聯說明與待查證段落。
- 建立三者間完整且已驗證的雙向人物關係（琴 ↔ 迪盧克、琴 ↔ 溫迪、迪盧克 ↔ 溫迪）。
- 建立 `wiki/regions/mondstadt.md` 蒙德主題索引文件。
- 追加官方來源登記至 `raw/sources/registry.md`（S011～S016）並新增 Raw 擷取紀錄檔案。
- 更新 `wiki/index.md` 索引目錄，涵蓋新角色與蒙德地區。
- 透過離線驗證工具檢查 YAML frontmatter、必要欄位、slug、元素、武器、日期、來源 URL 及雙向關聯完整性，全數通過。
