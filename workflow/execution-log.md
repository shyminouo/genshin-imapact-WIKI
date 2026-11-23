# Workflow Execution Log｜執行紀錄（追加式）

> 本檔案為 **append-only** 執行紀錄。每次節點執行、包含 PASS、FAIL、回跳與重試均須留存。
> 格式規範：`## [<實際日期時間>] run=<run-id> | graph=v1 | node=<節點名> | attempt=<嘗試次數>`

---

## [2026-11-23 02:30] run=init-v2 | graph=v1 | node=Init | attempt=1
- Input: `AGENTS.md` v2.0
- Output: `workflow/graph-v1.md`, `wiki/templates/source.template.md`, `wiki/templates/concept.template.md`
- Gate: PASS
- Evidence: 依據規範完成 v2.0 基礎工作流程與模板建立。
- Issue: 無
- Next: 待使用者確認教學主題後啟動 Retriever / Ingest 流程。

## [2026-11-23 02:38] run=run-ingest-5 | graph=v1 | node=Find_Sources | attempt=1
- Input: 教學主題「原神新手入門：從元素認識角色與戰鬥系統」，鎖定元素、反應、武器、定位、隊伍 5 大方向
- Output: S006, S007, S008, S009, S010 來源定位完成
- Gate: PASS
- Evidence: 檢索並確認 5 份獨立來源之有效 URL、平台、發布者與適用版本（4.0+）。
- Issue: 無
- Next: 進入 Extract 節點進行主張萃取與 Raw 保存。

## [2026-11-23 02:39] run=run-ingest-5 | graph=v1 | node=Extract_and_Verify | attempt=1
- Input: S006 ~ S010 原始來源內容
- Output: `raw/sources/S006~S010.md`, `wiki/sources/s006~s010.md`，抽取每篇 4 項可核實主張（共 20 項主張）
- Gate: PASS
- Evidence: 主張均附具體章節與出處定位，未直接複製未授權全文。
- Issue: 無
- Next: 進入 Integrate_Wiki 節點進行概念頁整合。

## [2026-11-23 02:39] run=run-ingest-5 | graph=v1 | node=Integrate_Wiki | attempt=1
- Input: S006 ~ S010 主張與既有 3 名角色資料（芙寧娜、那維萊特、雷電將軍）
- Output: `wiki/concepts/elements.md`, `elemental-reactions.md`, `weapons.md`, `character-roles.md`, `team-building.md`
- Gate: PASS
- Evidence: 5 大概念頁完整整合主張 ID，關聯角色與概念均為既有 slug，無失效連結。
- Issue: 無
- Next: 執行 Wiki Lint 檢查。

## [2026-11-23 02:40] run=run-ingest-5 | graph=v1 | node=Wiki_Lint | attempt=1
- Input: 全部角色 Markdown、S006～S010 來源摘要檔、5 篇概念 Markdown
- Output: 驗證通過報告
- Gate: PASS
- Evidence: 透過 `validate.js` 驗證，3 名角色、5 份來源摘要、5 篇概念頁之 Frontmatter、Slug 規則、日期格式、外部 URL、跨概念/角色交叉引用關係全數驗證通過（0 error）。
- Issue: 無
- Next: 完成 5 篇資料匯入交付，等待使用者指示啟動簡報生成流程（Retriever -> Planner -> Writer -> Reviewer -> HTML Generator）。


## [2026-11-23 16:11] run=2026-11-23-01 | graph=v1 | node=Retriever | attempt=1
- Input: 教學主題「原神新手入門：從元素認識角色與戰鬥系統」、`wiki/index.md`、5 篇概念頁、6 名角色頁
- Output: `workflow/runs/2026-11-23-01/evidence.md`
- Gate: PASS
- Evidence: 檢索整理出 20 項穩定主張（S006～S010）與 6 名圖鑑實例角色之核實證據，無懸空主張。
- Issue: 無
- Next: 進入 Planner 節點規劃簡報大綱。

## [2026-11-23 16:12] run=2026-11-23-01 | graph=v1 | node=Planner | attempt=1
- Input: 學習目標、`evidence.md` 已核對證據矩陣
- Output: `workflow/runs/2026-11-23-01/outline.md`
- Gate: PASS
- Evidence: 完成 12 頁循序漸進大綱規劃，涵蓋元素、反應、武器、角色定位、配隊、避坑與小測驗，目標覆蓋率 100%。
- Issue: 無
- Next: 進入 Writer 節點撰寫內容與測驗。

## [2026-11-23 16:14] run=2026-11-23-01 | graph=v1 | node=Writer | attempt=1
- Input: `outline.md`、`evidence.md`
- Output: `workflow/runs/2026-11-23-01/slide-content.json`
- Gate: PASS
- Evidence: 產出結構化 12 頁 JSON 資料，包含各類模組、引證 claimId 與 3 題互動小測驗。
- Issue: 無
- Next: 進入 Reviewer 節點進行事實審查。

## [2026-11-23 16:14] run=2026-11-23-01 | graph=v1 | node=Reviewer | attempt=1
- Input: Wiki 知識庫、`outline.md`、`slide-content.json`
- Output: `workflow/runs/2026-11-23-01/review.md`
- Gate: PASS
- Evidence: 逐頁核實事實無憑空捏造、語言通俗適合新手、小測驗答案與引用完全對齊。
- Issue: 無
- Next: 進入 HTML_Generator 節點實作 Astro 頁面。

## [2026-11-23 16:16] run=2026-11-23-01 | graph=v1 | node=HTML_Generator | attempt=1
- Input: 已審查之 `slide-content.json`
- Output: `src/pages/tutorial/index.astro`、`src/styles/tutorial.css`、更新 `src/components/Header.astro`
- Gate: PASS
- Evidence: 完成響應式互動簡報頁面實作，支援進度條、跳頁、鍵盤翻頁、即時測驗回饋與 sitePath 相容性。
- Issue: 無
- Next: 進入 Tester 節點進行功能與語法測試。

## [2026-11-23 16:17] run=2026-11-23-01 | graph=v1 | node=Tester | attempt=1
- Input: `slide-content.json`、`scripts/check-tutorial.ps1`
- Output: `check-tutorial.ps1` 報錯輸出
- Gate: FAIL
- Evidence: 檢查腳本抓出 Slide 7 的 citations 物件中欄位名筆誤（誤植為 `"sourceId": "S009-C02"` 缺少 claimId 欄位）。
- Issue: ISSUE-01 (Citation schema key mismatch in slide 7)
- Next: 回跳 Writer 節點修正 `slide-content.json`。

## [2026-11-23 16:17] run=2026-11-23-01 | graph=v1 | node=Writer | attempt=2
- Input: ISSUE-01 回饋修訂
- Output: 修復 Slide 7 之 `citations` 陣列欄位結構
- Gate: PASS
- Evidence: Slide 7 citations 修正為正規之 `{ "wikiPath": "wiki/concepts/character-roles.md", "sourceId": "S009", "claimId": "S009-C0X" }`。
- Issue: 無
- Next: 重新提交 Tester 節點複驗。

## [2026-11-23 16:17] run=2026-11-23-01 | graph=v1 | node=Tester | attempt=2
- Input: 修復後之 `slide-content.json`、`check-data.ps1`、`check-tutorial.ps1`
- Output: `workflow/runs/2026-11-23-01/checks.md`
- Gate: PASS
- Evidence: `check-data.ps1` 與 `check-tutorial.ps1` 雙雙執行通過，0 錯誤。
- Issue: 無
- Next: 交付簡報生成任務成果。
