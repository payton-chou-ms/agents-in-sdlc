

# 後續工作與延伸整合（Future Work）

| [← 上一課：使用 Spec-kit 與 Copilot Coding Agent][previous-lesson] |
|:----:|

本章整理尚未涵蓋、但很適合在本專案延伸導入的實務主題：CI/CD 工作流程、文件與靜態網站發佈、專案與釋出管理，以及安全性強化。內容以 GitHub 生態系可落地的做法為主，提供建議的流程與驗收重點，方便逐步導入。

## 1 目標與範圍

- 串接 CI/CD（建置/測試/部署）並區分 Dev/Test/Prod
- 建立自動化安全防護（CodeQL、Dependabot、靜態掃描）
- 發佈文件與站點（GitHub Pages）
- 視覺化追蹤與治理（Projects、Releases、Insights）

> 參考案例與更多說明：
> https://github.com/sec-taipei-hub-org/TechExcel-Accelerate-developer-productivity-with-GitHub-Copilot-and-Dev-Box1/

## 2 CI/CD 工作流程建議（Workflows）

### 2.1 基礎設施即程式碼（IaC）— Azure Bicep（可選）
- 管理 Dev/Test/Prod 三套環境的基礎設施差異
- 建議以 Environments + Secrets 管理敏感參數
- 在 PR 合併前以 Preview 驗證變更（如 Bicep What-If）

### 2.2 持續整合（CI）— .NET/前端/後端
- 觸發：push、pull_request
- 任務：安裝依賴、型別與語法檢查、單元測試、（選擇性）測試覆蓋率上傳
- 快取：NuGet/npm/uv 緩存以加速

### 2.3 持續交付（CD）— 分環境部署
- Dev：CI 通過後自動部署，快速回饋
- Test/Prod：需要人工批准（Approvals），並使用保護的 Environments
- 推薦：使用可回滾策略與版本標記（Release Tag）

## 3 安全性與品質

### 3.1 CodeQL（自動程式碼掃描）
- 排程或 PR 時掃描，產出 Alerts 與建議修正
- 與 PR 檢查整合，阻擋高風險變更

### 3.2 Dependabot Updates（相依更新）
- 針對 Python、Node.js、GitHub Actions 等維護安全更新
- 設定自動化 PR 與標籤、指定審核者

### 3.3 ESLint / 型別與風格檢查（前端）
- 在 CI 中加入 `eslint` 與 `tsc --noEmit`
- 可加上針對常見弱點的規則集（如 security plugin）

## 4 文件與網站發佈（Pages）

- 使用 GitHub Pages 自動部署 `docs/` 或 build 輸出
- 在 CI 中建立靜態資產後，於 CD 階段上傳並發佈
- 建議建立索引頁面與導覽，整合本系列文件

## 5 專案與釋出管理

### 5.1 Projects（看板/規劃）
- 以 Milestone 與 Iteration 規劃，關聯 Issues/PRs
- 使用自動化規則（如 PR 合併後自動移動到 Done）

### 5.2 Releases（版本管理）
- 以 Tag + Release Note 紀錄重要變更
- 可整合自動產生變更日誌（從 PR 標籤或類別）

## 8 資源

- GitHub Actions（CI/CD）
- GitHub Environments & Approvals
- CodeQL、Dependabot、ESLint
- GitHub Pages、Projects、Releases、Insights

---

| [← 上一課：使用 Spec-kit 與 Copilot Coding Agent][previous-lesson] |
|:----:|

[previous-lesson]: ./6-using-spec-kit-with-coding-agent.zh-TW.md
