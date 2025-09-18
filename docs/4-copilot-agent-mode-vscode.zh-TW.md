# 練習 4 - 使用 Copilot 代理模式添加新功能

| [← 上一課：自定義指令][previous-lesson] | [下一課：審查編碼代理 →][next-lesson] |
|:--|--:|

即使是對應用程式最簡單的更新，通常也需要更新多個檔案並執行運行測試等操作。作為開發者，您的流程通常涉及追蹤所有必要的檔案、進行更改、運行測試、除錯、找出漏掉了哪個檔案、進行另一次更新...清單還會繼續下去。

這就是 Copilot 代理模式發揮作用的地方。

Copilot 代理模式被設計為在您的 IDE 中更自主地行動。它以類似開發者的方式行為，首先探索現有的專案結構，執行必要的更新，運行測試等任務，並自動修復任何發現的錯誤。讓我們探索如何使用代理模式為我們的網站引入新功能。

> [!NOTE]
> 雖然名稱相似，但代理模式和編碼代理是為兩種不同類型的體驗而構建的。代理模式在您的 IDE 中執行其任務，允許快速反饋週期和互動。編碼代理被設計為配對程式設計師，像團隊成員一樣非同步工作，透過議題和拉取請求與您互動。

在本練習中，您將學習如何：

- GitHub Copilot 代理模式可以在後端和前端程式碼庫中實作新功能。
- Copilot 代理模式可以探索您的專案，識別相關檔案，並進行協調更改。
- 在合併到程式碼庫之前審查由 Copilot 代理模式生成的更改和測試。

## 情境

隨著遊戲清單的增長，您希望允許使用者按類別過濾。這將需要更新 API 和 UI，並更新 API 的測試。在 Copilot 代理模式的幫助下，您將與您的 AI 配對程式設計師合作添加新功能！

## 運行 Tailspin Toys 網站

在我們進行任何更改之前，讓我們探索 Tailspin Toys 網站以了解其當前功能。

該網站是一個以開發者為主題的桌遊眾籌平台。它允許使用者列出遊戲並顯示有關它們的詳細資訊。該網站有兩個主要組件：前端（用 Svelte 編寫）和後端（用 Python 編寫）。

### 啟動網站

為了讓運行網站更容易，我們提供了一個腳本，將啟動前端和後端伺服器。您可以在您的 GitHub Codespace 中運行此腳本，按照以下說明啟動網站：

1. 返回您的 codespace。我們將繼續在您當前的分支中工作。
2. 通過選擇 <kbd>Ctl</kbd> + <kbd>\`</kbd> 在您的 codespace 中打開新的終端視窗。
3. 運行以下腳本來啟動網站：

   ```bash
   scripts/start-app.sh
   ```

   腳本運行後，您應該看到指示前端和後端伺服器都在運行的輸出，類似於以下內容：

   ```bash
   Server (Flask) running at: http://localhost:5100
   Client (Astro) server running at: http://localhost:4321
   ```

> [!NOTE]
> 如果打開對話框提示您為 http://localhost:5100 打開瀏覽器視窗，請通過選擇 **x** 關閉它。

4. 通過在終端中使用 <kbd>Ctrl</kbd>-**點擊**（或在 Mac 上使用 <kbd>Cmd</kbd>-**點擊**）客戶端地址 `http://localhost:4321` 來打開網站。

> [!NOTE]
> 使用 codespace 時，從 Codespace 終端選擇 localhost URL 的連結將自動將您重定向到 `https://<your-codespace-name>-4321.app.github.dev/`。這是一個到您的 codespace 的私人通道，現在正在託管您的 Web 伺服器！

### 探索網站

網站運行後，您可以探索其功能。網站的主要功能包括：

- **首頁**：顯示桌遊清單及其標題、圖像和描述。
- **遊戲詳細資訊頁面**：當您選擇遊戲時，您將被帶到一個詳細資訊頁面，其中包含有關遊戲的更多資訊，包括其標題、描述、發佈商和類別。

## 使用 Copilot 探索待辦事項

網站的初始實作是功能性的，但我們想通過添加新功能來增強它。讓我們首先審查待辦事項。要求 GitHub Copilot 顯示我們在上一個練習中建立的待辦事項清單。

1. 返回您的 codespace。
2. 打開 **Copilot Chat**。
3. 通過選擇 **New Chat** 按鈕建立新的聊天會話，這將刪除任何先前的上下文。
4. 確保從模式清單中選擇了 **Agent**。
5. 從可用模型清單中選擇 **Claude Sonnet 4**。

> [!IMPORTANT]
> 本實驗的作者並不表示對某個模型的偏好。在建立此實驗時，我們使用了 Claude Sonnet 4，因此將其包含在指令中。希望您收到的程式碼建議相對一致，以確保良好的體驗。但是，因為 LLM 是機率性的，您可能會注意到收到的建議與實驗中指示的不同。這是完全正常和預期的。

1. 通過向 Copilot 發送以下提示來詢問 Copilot 關於議題待辦事項：

   ```plaintext
   Please show me the backlog of items from my GitHub repository. Help me prioritize them based on those which will be most useful to the user.
   ```

2. 注意 GitHub Copilot（很可能）將 `list_issues` 或 `search_issues` 識別為要運行的 MCP 命令以存取正確的資訊。

> [!NOTE]
> 由於 LLM 的機率性質，Copilot 可能使用不同的 MCP 命令，但應該仍然能夠完成任務。

7. 選擇 **Continue** 運行命令以列出所有議題。
8. 審查生成的議題清單。

注意 Copilot 甚至根據它認為對使用者最有用的項目為我們優先排序了項目。

## 實作過濾功能

要實作過濾功能，需要對應用程式進行不少於三個單獨的更新：

- 向 API 添加新端點
- 為新端點建立一組新測試
- 更新 UI 以引入功能

此外，測試需要運行（並通過）才能將所有內容合併到我們的程式碼庫中。Copilot 代理模式可以為我們執行這些任務！讓我們添加功能。

1. 您可以在當前與 Copilot 的對話中繼續，或通過選擇 **New Chat** 開始新對話。
2. 選擇 **Add Context**、**Instructions** 和 **flask-endpoint .github/instructions** 作為指令檔案。

   ![顯示選擇指令檔案範例的螢幕截圖](images/copilot-add-instructions-file.png)

> [!NOTE]
> 儘管 Copilot 代理模式可能已經自己發現了此檔案，但如果您知道重要的資訊片段，如 **.instructions.md** 檔案，那麼絕對應該將其添加到 Copilot 的上下文中。這有助於讓 Copilot（和您）獲得成功。

3. 確保仍選擇了 **Agent** 模式。
4. 確保仍為模型選擇了 **Claude Sonnet 4**。
5. 使用以下提示提示 Copilot 根據我們之前建立的議題實作功能：

   ```plaintext
   請更新網站以包括基於待辦事項中相關 GitHub 議題要求的按發佈商和類別過濾功能。伺服器已經在運行，所以您不需要啟動它。
   ```

6. 觀看 Copilot 首先探索專案，找到與所需功能相關的檔案。您應該看到它找到 API 和 UI 定義以及測試。然後它開始修改檔案並運行測試。

   ![顯示 Copilot 探索專案檔案的螢幕截圖](images/copilot-agent-mode-explores.png)

> [!NOTE]
> 您將注意到 Copilot 會執行多項任務，如探索專案、修改檔案和運行測試。根據任務的複雜性和程式碼庫，這可能需要幾分鐘。在該過程中，您可能會注意到程式碼編輯器中出現 **Keep** 和 **Undo** 按鈕。當 Copilot 完成時，您將對所有更改有一個 **Keep** 或 **Undo**，所以您不需要在工作進行中選擇它們。

6. 根據 Copilot 的提示，選擇 **Continue** 運行測試。

   ![顯示 Copilot Chat 窗格中詢問使用者確認是否樂意運行測試的對話框螢幕截圖](images/copilot-agent-mode-run-tests.png)

7. 您可能會看到過程中一些測試失敗，這是正常的！Copilot 可能會在程式碼生成和測試之間來回工作，直到完成任務且未檢測到任何錯誤。

   ![顯示與 Copilot 代理模式完整聊天會話的螢幕截圖](images/copilot-agent-mode-proposed-changes.png)

8. 探索生成的程式碼是否有任何潛在問題。

> [!IMPORTANT]
> 請記住，審查 Copilot 或任何 AI 工具生成的程式碼始終很重要。

9.  返回到運行網站的瀏覽器。探索新功能！
10. 一旦您確認一切正常並審查了程式碼，在 Copilot Chat 視窗中選擇 **Keep**。

## 發佈分支

在本地建立更改後，我們準備建立拉取請求（PR）以允許我們的團隊審查我們建議的更改並完成我們的 DevOps 流程。該流程的第一步是發佈分支。讓我們先處理這個。

1. 導覽到 Codespace 中的 **Source Control** 面板並審查 Copilot 所做的更改。
2. 通過選擇 **+** 圖示暫存更改。
3. 使用 **Sparkle** 按鈕生成提交訊息。

   ![顯示所做更改的源代碼控制面板螢幕截圖](images/source-control-changes-agent-mode.png)

4. 選擇 **Publish** 將分支推送到您的存儲庫。

## 建立拉取請求

有幾種建立拉取請求的方法，包括透過 github.com 和 GitHub 命令列介面（CLI）。但由於我們已經在使用 GitHub Copilot，讓我們讓它為我們建立 PR！我們可以讓它找到相關議題並建立與找到議題關聯的 PR。

1. 導覽到 Copilot Chat 面板並選擇 **New Chat** 開始新會話。
2. 要求 Copilot 為您建立 PR：

   ```plaintext
   在存儲庫中找到與按類別和發佈商過濾相關的議題。為當前的 add-filters 分支建立新的拉取請求，並將其與正確的議題關聯。
   ```

3. 根據需要，選擇 **Continue** 以允許 Copilot 執行收集資訊和執行操作所需的任務。
4. 注意 Copilot 如何搜尋議題，找到正確的議題，並建立 PR。
5. 選擇 Copilot 生成的連結來審查您的拉取請求，但請**還不要合併它**。

## 總結與下一步

恭喜！在本練習中，我們探索了如何使用 GitHub Copilot 代理模式為 Tailspin Toys 網站添加新功能。我們學會了如何：

- GitHub Copilot 代理模式可以在後端和前端程式碼庫中實作新功能。
- Copilot 代理模式可以探索您的專案，識別相關檔案，並進行協調更改。
- 在合併到程式碼庫之前審查由 Copilot 代理模式生成的更改和測試。

現在讓我們[返回我們的編碼代理][next-lesson]，看看它在我們分配給它的議題上做得如何。

### 獎勵探索練習 - 實作分頁

隨著遊戲清單的增長，將需要啟用分頁。使用您在本練習中學到的技能，提示 Copilot 更新網站以實作分頁。程式碼的一些考慮因素包括：

- 遵循現有的最佳實務，包括使用現有的（或建立新的）提示檔案。
- 考慮您希望如何實作分頁，是否要允許使用者選擇頁面大小或將其硬編碼。
- 在建立提示時，確保為 Copilot 提供必要的指導，以按您的意願建立實作。
- 您可能需要與 GitHub Copilot 進行迭代，要求更改並提供上下文。這是與 Copilot 工作時的正常流程！

## 資源

- [編碼代理 101][coding-agent-101]
- [Copilot 詢問、編輯和代理模式：它們的作用以及何時使用它們][choose-mode]
- [VS Code 中的代理模式][vs-code-agent-mode]

---

| [← 上一課：自定義指令][previous-lesson] | [下一課：審查編碼代理 →][next-lesson] |
|:--|--:|

[previous-lesson]: ./3-custom-instructions.zh-TW.md
[next-lesson]: ./5-reviewing-coding-agent.zh-TW.md
[coding-agent-101]: https://github.blog/ai-and-ml/github-copilot/agent-mode-101-all-about-github-copilots-powerful-mode/
[choose-mode]: https://github.blog/ai-and-ml/github-copilot/copilot-ask-edit-and-agent-modes-what-they-do-and-when-to-use-them/
[vs-code-agent-mode]: https://code.visualstudio.com/docs/copilot/chat/chat-agent-mode
