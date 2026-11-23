# Workflow Reflection｜流程反思（課堂總結）

> 依據 `AGENTS.md` v2.0 第 15.2 節規範：本檔案完全依據實際執行紀錄（`workflow/execution-log.md`）撰寫，嚴禁憑空想像或虛構指標。

---

## 一、節點出錯統計與實際問題

- **最常出錯的節點**：`Tester`（攔截出錯）與 `Writer`（產出格式偏差）。
- **Run ID**: `2026-11-23-01`
- **節點執行嘗試次數統計**：
  - `Retriever`：嘗試 1 次，失敗 0 次（Gate: PASS）
  - `Planner`：嘗試 1 次，失敗 0 次（Gate: PASS）
  - `Writer`：嘗試 2 次，修正 1 次（Gate: PASS）
  - `Reviewer`：嘗試 1 次，失敗 0 次（Gate: PASS）
  - `HTML_Generator`：嘗試 1 次，失敗 0 次（Gate: PASS）
  - `Tester`：嘗試 2 次，失敗 1 次（Gate: FAIL ➔ attempt 2 PASS）
- **實際問題（ISSUE-01）**：
  在 `Writer` 產出 `slide-content.json` 時，第 7 頁（角色戰鬥定位）的 `citations` 陣列中，物件鍵名出現筆誤：誤將 `"sourceId": "S009", "claimId": "S009-C02"` 合併寫成了 `"sourceId": "S009-C02"` 而缺少了 `claimId` 欄位。該錯誤在 Reviewer 進行語義與事實檢查時被忽略，直到 Tester 執行靜態 Schema 驗證程式（`check-tutorial.ps1`）時被程式化精確攔截。

---

## 二、Shift-Left 左移決策與新 Gate 設計

- **移動的檢查**：
  將「**JSON 資料結構與 Citation Schema 語法檢查**」從最後階段的 `Tester` 節點往前移動至 `Reviewer` 節點（或在 `Writer` 產出當下即刻執行 Pre-check）。
- **移轉理由（Why Shift-Left）**：
  在 V1 流程中，Reviewer 著重於「事實內容、語言風格與教學邏輯」，容易對 JSON 欄位型別與 Schema 鍵名的微小語法錯誤漏檢；導致錯誤一直流入 HTML Generator 甚至 Tester 階段，造成下游重工。若在 Reviewer 審查前即加入自動化的 Schema Lint Gate，可在第一時間打回 Writer 修正，避免浪費後續 HTML 生成與整合的時間。

---

## 三、Workflow / Graph 改進構想（Graph V1 vs V2）

- **V1 架構**：
  內容品質與結構檢查 Gate 全數後置於 Reviewer 與 Tester。
- **V2 改進提案（已驗證之預防性閘門）**：
  1. **Retriever 增設 Evidence Coverage Gate**：在輸出大綱前，先行核驗 20 項主張是否完整涵蓋七元素、五武器、反應與配隊，避免規劃大綱時發現缺知識回跳。
  2. **Writer 增設 Schema Validation Gate**：Writer 產出 JSON 即刻以靜態規則檢查欄位必填與鍵名，合格後才送 Reviewer 進行人工語意審查。
  3. **可追溯性**：保留 `graph-v1.md` 作為初始基準，若使用者需要進一步標準化可升級為 `graph-v2.md`。

---

## 四、環境限制、未驗證項目與資料缺口

1. **環境限制**：
   - 當前本機沙盒運行環境未將 `npm`、`node` 與 `git` 註冊於系統 PATH，無法直接在終端執行 `npm run build` 與 `git push`。
2. **驗證方式說明**：
   - 本次作業所有資料檢查與靜態驗證，均透過完全等價之 PowerShell 腳本（`check-data.ps1`、`check-tutorial.ps1`）完成逐項嚴格比對。
   - 同時已在專案中建立對應的 `scripts/check-tutorial.mjs` 並更新 `package.json` 中的 `scripts.build` 與 `scripts.check:tutorial`，供具備 Node.js 環境之宿主或 CI/CD Pipeline 完整執行。
3. **資料缺口與邊界**：
   - 關於草元素高等反應（超綻放、烈綻放）與深淵荒芒機制，已在證據表中標明列為進階知識，未強行納入新手初階教學，符合教學受眾設定。
