# 使用 Spec-kit 與 Copilot Coding Agent

| [← 上一課：練習 5：審查 GitHub Copilot 編碼代理的工作][previous-lesson] |
|:----:|

本章說明如何使用 GitHub 的 Spec-kit（也稱為 `specify`）產生需求規格、工作清單（tasks），並搭配 Copilot Coding Agent 將產出轉為 GitHub Issues、Wiki 與專案項目。範例針對本儲存庫（Tailspin Toys）進行演示，重點在：安裝、產生、驗證與將產物整合到既有開發流程

重要：Spec-kit 的實作與指令可能會隨 upstream 更新而改變。請以官方 repo 的 README 為主，參考網址： https://github.com/github/spec-kit

注意：以下步驟假設您已在 Codespace 或本機，且有 git 與對應權限推送至 repository。若您要在 Codespace 中使用 Copilot Chat / Agent，請確保已登入並開啟相應權限

## 1 前置需求

- 已安裝 uvx（或其他可用來初始化/同步 Spec-kit 範本的工具）
- 已設定好 GitHub 權杖、並在 Codespace 或本機登入 GitHub
- 建議先在獨立分支上測試自動產出的變更

## 2 安裝 Spec-kit（範例）

由於 Spec-kit 預設會產生一個新的專案範本，如果要在原本的專案使用，建議將 spec-kit 的模板與 prompts 同步到本專案中，然後根據本專案情境調整。

以下為一種常見工作流程（以 uvx init 為例）:

1. 在 codespace 切到上層工作目錄：

   ```bash
   cd ..
   ```

2. 使用 uvx 由 GitHub 來源初始化一個臨時 specify 專案（根據官方 README 調整命令）:

   ```bash
   uvx --from git+https://github.com/github/spec-kit.git specify init my-spec-kit
   ```

3. 將產生的檔案同步回目前 repo：

   ```bash
   rsync -av --exclude='.git' ./my-spec-kit/ ./agents-in-sdlc/
   ```

   產出檔案範例（檔案/目錄名稱視版本可能略有差異）：
   - `.specify/`（規格與模板設定）
   - `.github/prompts/plan.prompt.md`
   - `.github/prompts/specify.prompt.md`
   - `.github/prompts/tasks.prompt.md`

提示：若您不使用 uvx，也可以直接從官方 repo 複製必要的資料夾和模板；務必檢查 `.specify` 與 `.github/prompts` 的內容，並根據專案需要修改 prompt 範本。

## 3 產生 Spec（需求）

1. 使用 Spec-kit/`specify` 產生需求草案。

   - 範例輸入（在工具互動時）例子：
    ```bash
    /specify 為遊戲加入可由 UI 編輯的 label（標籤）功能
    ```
2. 檢視 `.specify/` 內產生的 spec 檔案，確認需求敘述、驗收準則與範例介面

建議檢查項目：
- `.specify/` 中是否有描述驗收測試步驟（Acceptance Criteria / E2E 路徑）
- 是否列出要修改或新增的檔案路徑範例（有助於 agent 生成更精準的變更）
- 是否包含使用情境（user stories）與 API contract 範本

## 4 產生 Plan（開發計畫）

1. 使用 `.github/prompts/plan.prompt.md` 或透過 Copilot Coding Agent，根據 Spec 產生分階段的開發計畫（Milestones / Steps）。
2. Plan 應包含：
    ```bash
    /plan 僅使用 repo 現有技術
    ```

提示：若 Plan 太粗略，請要求將每個 Milestone 拆解為更小的 Tasks 並明確列出要修改的檔案

## 5 產生 Tasks（工作項目）

1. 使用 `.github/prompts/tasks.prompt.md` 或 Spec-kit 的 tasks 生成功能，將 Plan 轉為可執行的 Tasks：
2. 範例
    ```bash
    /tasks
    ```
驗證：請確認每個 Task 的驗收標準應明確

## 6 將產物發佈到 Wiki（或文件庫）

1. 使用 Copilot Coding Agent 可以自動將 `.specify/` 與 `.github/prompts/` 內的重要文件整理並推送到 GitHub Wiki
2. 或者手動：把生成的 Markdown 檔案移到 `docs/` 或 `docs/specs/`，並建立索引頁面
3. 範例
    ```bash
    # 使用 Coding Agent
    請幫忙將附件的這些文件, 產生 GitHub Wiki 文件
    ```

## 7 將 Tasks 轉為 Issues 與 Project Items

1. Copilot Coding Agent 支援從 Tasks 檔生成 Issues，並可將其指派到 GitHub Project / Iteration。
2. 範例
    ```bash
    # 使用 Coding Agent
    請幫忙將附件的這些 Tasks, 產生到 GitHub Issues裡面, 每一個Tasks都需要產生 issues, 標題 請把 task編號與Title, 都要詳細註明
    ```

## 8 指派 Coding 與 Review

1. 在 Codespace 的 GitHub 界面中, Assign issue 由 Copilot Coding Agent 處理

## 9 透過 Code Review Agent 再次 Review 確認

- 如有疑問或想取得最新用法，請參考官方 repo： https://github.com/github/spec-kit

## 資源
- Spec-kit / Specify repo: https://github.com/github/spec-kit

---

| [← 上一課：練習 5：審查 GitHub Copilot 編碼代理的工作][previous-lesson] |
|:----:|

[previous-lesson]: ./5-reviewing-coding-agent.zh-TW.md

