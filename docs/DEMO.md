# 課堂展示腳本：如何證明 AGENTS.md 真的能讓 AI 依同一套方式擴充網站？

## Demo 1：觀察初始網站

- 展示首頁角色卡片、元素和國度篩選。
- 點進芙寧娜，查看模板化角色詳情與那維萊特連結。
- 展示 `wiki/characters/furina.md` 為唯一事實來源；網頁本身沒有一份重複手工資料。

## Demo 2：只給 Agent 簡短需求

> 請先閱讀 `AGENTS.md`，新增一名已公開、可以查證來源的角色。請依照 Ingest 流程更新來源清單、角色 Markdown、相關 Wiki、index 與 log，檢查後回報所有變動。保持現有網站設計。

檢查：是否**沒有新增獨立角色 HTML**、卡片是否自動出現、來源是否具體、角色關聯是否完整。

## Demo 3：展示同一份規範的價值

- 修改前後比較 Git diff。
- 展示 `wiki/log.md` 的新增紀錄。
- `npm run check:data`、`npm run build`，最後以 GitHub Pages 的公開連結展示。

> 注意：初始範例為 draft，不代表所有角色設定已全面核對。未經驗證的項目應坦白標記。
