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


## [2026-11-23] workflow | 完成新手教學簡報完整生成流程（Run: 2026-11-23-01）
- 依據 AGENTS.md 第 12～14 節規範，順序執行 Retriever ➔ Planner ➔ Writer ➔ Reviewer ➔ HTML Generator ➔ Tester 完整節點。
- 產出 `workflow/runs/2026-11-23-01/` 全套中間產物：`evidence.md`（檢索 20 項主張與 6 位角色）、`outline.md`（12 頁簡報大綱）、`slide-content.json`（結構化簡報資料與 3 道隨堂測驗）、`review.md`（審查事實、難度與引用）、`checks.md`（功能與建置測試結果）。
- 實作 `src/pages/tutorial/index.astro` 與 `src/styles/tutorial.css`，採用 Astro 靜態頁面、深藍淡金視覺系統，支援翻頁、進度、快速跳頁、鍵盤控制與即時小測驗回饋。
- 於 `src/components/Header.astro` 增設「新手教學」導覽入口。
- 新增 `scripts/check-tutorial.mjs` 與 `scripts/check-tutorial.ps1` 自動化簡報測試工具，並整合至 `package.json` 之 `check:tutorial` 與 `build` 腳本。
- 完成追加式執行紀錄 `workflow/execution-log.md` 與流程反思 `workflow/reflection.md`。


## [2026-11-23] ingest | 擴充十則提瓦特核心遊戲玩法與系統知識庫
- 依據使用者需求與 AGENTS.md 規範，新增 10 份遊戲玩法與系統知識頁面：
  1. `spiral-abyss.md`（深境螺旋常駐挑戰：迴廊與淵月螺旋雙隊伍）
  2. `imaginarium-theater.md`（幻想真境劇詩：4.7 三元素限制高難演出、耐力活力值）
  3. `open-world-exploration.md`（大世界探索與解謎：七天神像、傳送錨點、神瞳、環境機關）
  4. `serenitea-pot.md`（塵歌壺家園系統：仙力、寶錢、信任等級、同伴入駐好感）
  5. `genius-invokation-tcg.md`（七聖召喚卡牌對戰：角色牌、行動牌、元素骰與反應結算）
  6. `seasonal-events.md`（版本主題活動與千星冒險：六週旗艦大活動、智識之冕、滿精限定武器）
  7. `resin-and-progression.md`（原粹樹脂與體力循環：200 上限、濃縮樹脂、秘境地脈消耗）
  8. `artifacts-system.md`（聖遺物配置與套裝系統：五部位、副詞條強化跳點、2/4件套）
  9. `fishing-system.md`（提瓦特休閒釣魚系統：波紋釣點、專用魚餌、張力提竿、「漁獲」換取）
  10. `alchemy-and-forging.md`（鍊金合成與鍛造製造：素材三合一、還聖奧秘、鐵匠鋪鍛造四星武器）
- 於 `raw/sources/` 建立 10 篇原始來源紀錄（S017～S026），並追加登記至 `raw/sources/registry.md`。
- 於 `wiki/sources/` 建立 10 篇來源摘要與 40 項可核實主張（`S017-C01`～`S026-C04`）。
- 更新 `wiki/index.md` 概念與來源索引目錄。
