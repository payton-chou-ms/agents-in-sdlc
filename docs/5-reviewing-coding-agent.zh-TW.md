# 練習 5：審查 GitHub Copilot 編碼代理的工作

| [← 使用 Copilot 代理模式添加新功能][previous-lesson] | [下一課：使用 Spec-kit 與 Copilot Coding Agent →][next-lesson] |
|:--|--:|

當我們第一次開始這個實驗時，我們分配了幾個議題給 GitHub Copilot 編碼代理。我們要求它為我們的程式碼添加文件，並生成一些端點供其他團隊進行迭代。讓我們探索它建議的程式碼變更，並在必要時向 Copilot 提供反饋以改善其工作。

## 情境

如多次強調的，軟體設計和 DevOps 的基本原理不會因為生成式 AI 的加入而改變。我們總是希望審查生成的程式碼，並完成我們的正常 DevOps 流程。考慮到這一點，讓我們審查 GitHub Copilot 對建立文件和新端點的建議，然後再為我們團隊的其他成員開啟審查。

## 安全性和 GitHub Copilot 編碼代理

因為 Copilot 編碼代理非同步執行其任務且無需監督，已實施某些安全限制以確保一切保持安全。這些包括：

- Copilot 只對您的存儲庫具有讀取存取權限，並且**只有**對它將用於其程式碼的分支具有寫入存取權限。
- 編碼代理在 GitHub Actions 內運行，它將建立一個單獨的、臨時的環境來工作。
- 任何 GitHub Actions 工作流程在運行之前都需要人工批准。
- [預設情況下對外部資源的存取受到限制][agent-firewall]，包括 MCP 伺服器。

## 審查生成的文件

讓我們首先探索 GitHub Copilot 編碼代理生成的第一個拉取請求 (PR) - 為我們的程式碼添加文件。我們將通過使用 GitHub.com 中的標準 PR 介面來執行此任務。

> [!NOTE]
> 當您探索 PR 時，您可能會注意到關於 GitHub Copilot 被防火牆阻擋的警告。這是**預期的**，因為 Copilot 預設情況下對外部資源（包括對外部 MCP 伺服器的呼叫）的存取受到限制。如果您願意，可以[為 Copilot 編碼代理自定義或停用防火牆][agent-firewall]。

1. 返回到 github.com 上的您的存儲庫。
2. 選擇 **Pull Requests** 打開拉取請求清單。
3. 打開標題類似於 **Add missing documentation** 或更健壯的議題。

> [!NOTE]
> 如果 Copilot 仍在處理任務，議題將包含 **[WIP]** 標誌。如果是這樣，請等待 Copilot 完成工作。這可能需要幾分鐘，所以請隨意休息一下，或反思您到目前為止學到的一切。

4. 一旦拉取請求準備就緒，選擇 **Files changed** 標籤並審查更改。

    ![檔案變更標籤](images/pr-files-changed.png)

5. 探索新更新的程式碼，其中包括新建立的文件字串和其他文件。確切的更改會有所不同。
6. 一旦您審查了更新並且一切看起來都很好，導覽回 **Conversation** 標籤並向下滾動。
7. 您應該會看到一些工作流程正在等待批准的指示器。
8. 點擊 **Approve and run workflows** 按鈕以允許工作流程運行。

    ![批准並運行工作流程](images/ex4-approve-and-run.png)

9. 您應該會看到工作流程在拉取請求的檢查區段中排隊。一切順利的話，您應該會看到後端和前端的工作流程都通過了。這可能需要幾分鐘才能完成。

## 向 GitHub Copilot 請求更改

在拉取請求上與 Copilot 合作不僅僅是單方面的。您也可以在拉取請求中的評論中標記 Copilot - 就像您對團隊其他成員所做的那樣 - 或在程式碼的內聯評論中。Copilot 將看到這些評論，並觸發另一個會話來解決它們。由於非確定性結果，我們無法提供要求的指示性文字。一些要求 Copilot 更新的想法包括：

- 在每個程式碼檔案的頂部添加註釋標頭，簡要描述它們的功能。
- 為 TypeScript 和 Svelte 檔案添加文件字串。
- 在伺服器和客戶端資料夾中分別建立 README，描述各自的程式碼庫。

1. 添加評論請求對生成的文件進行更改，標記 **@copilot** 就像您對任何用戶所做的那樣。使用上面的想法之一，或關於您希望在程式碼庫中看到的文件的其他建議給 Copilot。
2. 選擇 **View Session** 觀看 Copilot 執行其工作。注意 Copilot 如何開始新會話來進行更新。
3. 您可以選擇 **Back to pull request** 返回拉取請求。

    ![返回拉取請求](images/ex4-back-to-pr.png)

4. 一旦 Copilot 完成更改，您應該會在拉取請求中看到一個新提交。
5. 選擇 **Files changed** 標籤以審查更改。

隨意繼續迭代直到您滿意。一旦滿意，您可以將 PR 從草稿轉換為準備就緒，並將其合併到主分支。

![將 PR 轉換為準備審查](images/ex4-ready-for-review.png)

## 審查新端點

讓我們回到 Copilot 生成的 PR，用於解決我們關於為遊戲 API 添加建立、更新和刪除遊戲端點的議題。

1. 返回到 GitHub.com 中的您的存儲庫。
2. 選擇 **Pull Requests** 標籤。
3. 選擇標題類似於 **Add CRUD endpoints for games API** 或更健壯的 PR。
4. 選擇 **Files changed** 標籤以審查它生成的程式碼。
5. 一旦您審查了更新並且一切看起來都很好，導覽回 **Conversation** 標籤並向下滾動。
6. 您應該會看到一些工作流程正在等待批准的指示器。
7. 點擊 **Approve and run workflows** 按鈕以允許工作流程運行。

    ![批准並運行工作流程](images/ex4-approve-and-run.png)

8. 您應該會看到工作流程在拉取請求的檢查區段中排隊。一切順利的話，您應該會看到後端和前端的工作流程都通過了。這可能需要幾分鐘才能完成。
9. **選修：** 您甚至可以在您的 Codespace 中切換到此分支以對新端點進行手動測試。導覽到您的 Codespace，打開終端，並運行以下命令（將 **<branch-name>** 替換為 Copilot 建立的分支名稱，例如 **copilot/fix-8**。）：

    ```bash
    git fetch origin
    git checkout <branch-name>
    ```
   
Copilot 已建立了新端點！就像之前一樣，您可以與 Copilot 編碼代理迭代工作來請求更新。例如，您可能想要請求 Copilot 集中化錯誤處理以減少重複，或確保添加註釋和文件字串（記住 - 這是在我們對自定義指令進行更新**之前**分配的！）就像之前一樣，您可以通過在 **Conversation** 標籤上添加新評論來提出這些請求，Copilot 將看到並啟動新會話。

## 選修練習 - 通過更多議題探索代理的功能

擁有一個能夠探索我們程式碼庫並非同步進行更改的配對程式設計師是強大的，允許我們快速達到跨任務的第一次迭代，讓我們能夠審查和指導，或接手並在編輯器中繼續編碼。

您在實驗中取得了很大進展，我們接近結束。但是，我們鼓勵您在 GitHub 存儲庫中建立一些額外的議題，並使用 Copilot 來解決這些問題。一些想法包括：

- 在遊戲詳細資訊頁面上建立支持者興趣表格
- 在遊戲清單端點上實作分頁
- 為 Flask API 添加輸入驗證和錯誤處理
- 其他東西？您還可能考慮什麼？

## 總結

恭喜！您完成了實驗！您使用了 GitHub Copilot 提供的幾個功能，從 IDE 到存儲庫。特別是您：

- **學習了如何使用 GitHub Copilot 和模型上下文協定 (MCP) 來簡化軟體開發**。您設定了 GitHub MCP 伺服器以使 Copilot 能夠與您的存儲庫互動，使用 Copilot 代理模式建立了詳細的待辦事項。
- **探索了自定義指令和提示檔案如何指導 Copilot 遵循您專案的編碼標準。** 您建立了自定義指令檔案為 Copilot 提供上下文，確保它生成符合您專案指南的程式碼，並使用提示檔案為重複性任務和既定實務提供指導。
- **使用 Copilot 代理模式實作新功能，協調後端和前端程式碼的更改，並自動化重複性任務。** 您使用 GitHub Copilot 為遊戲清單頁面實作了新的類別和發佈商過濾器，在客戶端、後端和相應測試中進行更改。
- **體驗了 Copilot 作為配對程式設計師，被分配議題並在拉取請求上協作工作。** 您將 Copilot 分配給待辦事項中的議題，允許它建立拉取請求，建立計畫，實作更改，並在您提供反饋時進一步迭代。

這僅僅是開始，我們迫不及待想看到您如何使用 Copilot 幫助您完成自己的專案。我們希望您喜歡這個實驗，期待在下一個實驗中見到您！編碼愉快！

## 資源

- [GitHub Copilot][github-copilot]
- [關於 Copilot 代理][copilot-agents]
- [將 GitHub 議題分配給 Copilot][assign-issue]
- [Copilot 編碼代理設定工作流程最佳實務][coding-agent-best-practices]
- [配置 Copilot 編碼代理防火牆][agent-firewall]

---

| [← 使用 Copilot 代理模式添加新功能][previous-lesson] | [下一課：使用 Spec-kit 與 Copilot Coding Agent →][next-lesson] |
|:--|--:|

[github-copilot]: https://github.com/features/copilot
[coding-agent-overview]: https://docs.github.com/en/copilot/using-github-copilot/coding-agent/about-assigning-tasks-to-copilot#overview-of-copilot-coding-agent
[assign-issue]: https://docs.github.com/en/copilot/using-github-copilot/coding-agent/using-copilot-to-work-on-an-issue
[setup-workflow]: https://docs.github.com/en/copilot/using-github-copilot/coding-agent/best-practices-for-using-copilot-to-work-on-tasks#pre-installing-dependencies-in-github-copilots-environment
[copilot-agents]: https://docs.github.com/en/copilot/using-github-copilot/coding-agent/about-assigning-tasks-to-copilot
[coding-agent-best-practices]: https://docs.github.com/en/copilot/using-github-copilot/coding-agent/best-practices-for-using-copilot-to-work-on-tasks
[agent-firewall]: https://docs.github.com/en/copilot/customizing-copilot/customizing-or-disabling-the-firewall-for-copilot-coding-agent

[previous-lesson]: ./4-copilot-agent-mode-vscode.zh-TW.md
[next-lesson]: ./6-using-spec-kit-with-coding-agent.zh-TW.md
