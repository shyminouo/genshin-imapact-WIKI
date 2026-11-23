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
