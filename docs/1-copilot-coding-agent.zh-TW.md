# 練習 1 - GitHub Copilot 編碼代理

| [← 先決條件][previous-lesson] | [下一課：MCP 伺服器 →][next-lesson] |
|:--|--:|

很可能很少有組織（如果有的話）不會為技術債務而困擾。這可能是未解決的安全問題、需要更新的舊有程式碼，或因為沒有時間實施而在待辦事項中積壓的功能請求。GitHub Copilot 的編碼代理旨在執行諸如更新程式碼和添加功能等任務，都是以自主的方式進行。代理完成其工作後，它會生成一個草稿 PR，準備供人類開發者審查。這允許卸載繁瑣的任務並加速開發過程，讓開發者能夠專注於更大局的事項。

您將透過 Copilot 編碼代理探索以下內容：

- 自定義生成程式碼的環境。
- 確保操作安全執行。
- 明確界定議題的重要性。
- 將議題分配給 Copilot。

## 情境

Tailspin Toys 已經有一些他們希望解決的技術債務。最初聘請來建立網站第一版的承包商將文件留在不理想的狀態 - 我們的意思是它完全缺乏文件。作為第一步，他們希望看到所有函數都加上文件字串或等效的文件。

此外，設計團隊已準備好開始建立管理遊戲的用戶體驗。他們還不需要完整的實施，但他們至少需要一些可用於測試的端點。具體來說，他們需要遊戲 API 的端點，允許他們建立、更新和刪除遊戲。這目前是一個阻礙因素，但我們有其他優先級更高的問題。

這些都是很快就會被降低優先級的任務例子，非常適合分配給 Copilot 編碼代理。Copilot 編碼代理然後可以非同步地處理它們，讓開發者專注於其他任務，然後回來審查 Copilot 的工作並確保一切符合預期。

## 介紹 GitHub Copilot 編碼代理

[GitHub Copilot 編碼代理][coding-agent-overview] 可以在後台執行任務，很像人類開發者的方式。而且，就像與人類開發者合作一樣，這是透過[將 GitHub 議題分配給 Copilot][assign-issue]來完成的。分配後，Copilot 將建立一個草稿拉取請求來追蹤其進度，設定環境，並開始處理任務。您可以在它仍在執行或完成後深入查看 Copilot 的會話。一旦它準備好讓您審查提議的解決方案，它會在拉取請求中標記您！

## 明確界定指令的重要性

雖然經常會感覺如此，但 GitHub Copilot 並沒有魔法。沒有神奇的解決方案，您可以僅用幾句話就彈指一揮，讓 AI 為您執行整個任務。事實上，即使看似簡單的操作，當我們深入了解時，也往往有相當多的複雜性。

因此，我們希望[對如何將任務分配給 Copilot 編碼代理保持謹慎][coding-agent-best-practices]。將 Copilot 作為 AI 配對程式設計師來工作通常是最佳方法。無論任務大小，都要遵循沒有 Copilot 時相同的策略 - 分階段工作、學習、實驗，並相應地調整。

一如既往，軟體開發的基本原則不會因為生成式 AI 的加入而改變。

## 為 Copilot 編碼代理設定開發環境

建立程式碼，無論涉及誰，通常都需要特定的環境和一些設定腳本來執行，以確保一切都處於良好狀態。當分配任務給 Copilot 時也是如此，它以類似軟體工程師的方式執行任務。

編碼代理在執行工作時使用 [GitHub Actions][github-actions] 作為其環境。您可以透過建立[特殊的設定工作流程][setup-workflow]來自定義此環境，在 **.github/workflows/copilot-setup-steps.yml** 檔案中配置，在它開始工作之前執行。這使它能夠存取所需的開發工具和相依性。我們在實驗之前預先配置了這個，以幫助實驗流程並提供這個學習機會。它確保 Copilot 能夠存取 Python、Node.JS 以及客戶端和伺服器所需的相依性：

```yaml
name: "Copilot Setup Steps"

# 允許您從存儲庫的"Actions"標籤測試設定步驟
on: workflow_dispatch

jobs:
  copilot-setup-steps:
    runs-on: ubuntu-latest
    # 將權限設定為您的步驟所需的最低權限。Copilot 將獲得自己的令牌進行操作。
    permissions:
      # 如果您想在設定步驟中克隆存儲庫，例如安裝相依性，您需要 `contents: read` 權限。
      # 如果您不在設定步驟中克隆存儲庫，Copilot 將在步驟完成後自動為您執行此操作。
      contents: read
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      # 後端設定 - Python
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: "3.13"
          cache: "pip"

      - name: Install Python dependencies
        run: ./scripts/setup-env.sh

      # 前端設定 - Node.js
      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: "22"
          cache: "npm"
          cache-dependency-path: "./client/package.json"

      - name: Install JavaScript dependencies
        working-directory: ./client
        run: npm ci
```

它看起來像任何其他 GitHub 工作流程檔案，但有幾個關鍵點：

- 它包含一個名為 **copilot-setup-steps** 的單一作業。這個作業在 Copilot 開始處理拉取請求之前在 GitHub Actions 中執行。
- 我們還添加了 **workflow_dispatch** 觸發器，允許您從存儲庫的 Actions 標籤手動執行工作流程。這對於測試工作流程是否成功執行很有用，而不用等待 Copilot 執行它。

## 改善程式碼文件

雖然每個開發者和組織都理解文件的重要性，但大多數專案要麼有過時的資訊，要麼完全缺乏文件。這是經常未被解決的技術債務類型，會降低生產力並使維護程式碼庫或將新開發者帶入團隊變得更加困難。幸運的是，Copilot 在建立文件方面表現出色，這是分配給 Copilot 編碼代理的完美議題。它將在後台工作以生成必要的文件。在未來的練習中，我們將回來審查它的工作。

1. 在新的瀏覽器標籤中導覽到 github.com 上的您的存儲庫。
2. 選擇 **Issues** 標籤。
3. 選擇 **New issue** 打開新議題對話框。
4. 選擇 **Blank issue** 建立新議題。
5. 將 **Title** 設定為 `Code lacks documentation`。
6. 將 **Description** 設定為：
   
    ```plaintext
    Our organization has a requirement that all functions have docstrings or the language equivalent. Unfortunately, recent updates haven't followed this standard. We need to update the existing code to ensure docstrings (or the equivalent) are included with every function or method.
    ```

7. 選擇 **Create** 建立議題。
8. 在右側，選擇 **Assignees** 打開存儲庫貢獻者的搜尋框。
9. 選擇 **Copilot** 將議題分配給 Copilot。

  ![分配 Copilot 到議題](images/ex4-issue-assign.png)

10. 點擊頁面其他地方關閉分配視窗。不久之後，您應該會在議題的第一個評論上看到一組 👀，表示 Copilot 正在工作！

  ![Copilot 使用眼睛表情符號表示它正在處理議題](images/ex4-issue-eyes.png)

11. 選擇 **Pull Requests** 標籤。
12. 打開新生成的拉取請求 (PR)，標題類似於 **[WIP]: Code lacks documentation**。
13. 幾分鐘後，您應該會看到 Copilot 已建立了一個待辦事項清單。

> [!NOTE]
> Copilot 的待辦事項清單可能需要幾分鐘才會出現在 PR 中。Copilot 正在建立其環境（執行前面強調的工作流程）、分析專案，並確定解決問題的最佳方法。

14.  審查清單和它將完成的任務。
15.   向下滾動拉取請求時間軸，您應該會看到 Copilot 已開始處理議題的更新。
16.   選擇 **View session** 按鈕。

  ![Copilot 會話檢視](images/ex4-view-session.png)

> [!IMPORTANT]
> 您可能需要刷新視窗才能看到更新的指示器。

17. 注意您可以滾動瀏覽即時會話，以及 Copilot 如何解決問題。這包括探索程式碼和理解狀態，Copilot 如何暫停思考並決定適當的計畫，還有建立程式碼。

這可能需要幾分鐘。Copilot 編碼代理的主要目標之一是允許它非同步執行任務，讓我們能夠專注於其他任務。我們將透過同時將另一個任務分配給 Copilot 編碼代理，然後將注意力轉向編寫一些程式碼來為我們的應用程式添加功能，來利用這個非常功能。

## 建立新端點來修改遊戲

如前所述，GitHub Copilot 編碼代理的一大優勢是能夠分工，您可以專注於一組任務，而它專注於另一組。雖然為設計團隊建立修改遊戲的端點可能不一定需要很長時間，但這仍然是可以用於其他任務的時間。讓我們將它分配給 Copilot 編碼代理！

1. 返回到 github.com 上的您的存儲庫。
2. 選擇 **Issues** 標籤。
3. 選擇 **New issue** 打開新議題對話框。
4. 選擇 **Blank issue** 使用空白範本。
5. 將 **Title** 設定為：`Add endpoints to create and edit games`
6. 將 **Description** 設定為：

    ```markdown
    We're going to be creating functionality in the future to allow for the submission (and editing) of games. For now we just want the endpoints so we can explore how we want to create the UX and do some acceptance testing. Our requirements are:

   - Add new endpoints to the Games API to support creating, updating and deleting games
   - There should be appropriate error handling for all new endpoints
   - There should be unit tests created for all new endpoints
   - Before creating the PR, ensure all tests pass
   ```

7. 注意為 Copilot 提供的指導程度，以協助確保每個人都能成功。
8. 向下滾動到對話框底部找到 **Assignee** 按鈕。
9. 選擇 **Assignee** 打開選擇受分配者的對話框。
10. 從清單中選擇 **Copilot**。

    ![建立議題並分配 Copilot 編碼代理](images/create-issue-assign-copilot.png)

11. 選擇 **Create** 儲存議題。
12. 新建立的議題現在應該打開。

不久之後，您應該會在議題的第一個評論上看到一組 👀，表示 Copilot 正在工作！

![Copilot 使用眼睛表情符號表示它正在處理議題](images/ex4-issue-eyes.png)

Copilot 現在正在勤奮地處理您的第二個請求！Copilot 編碼代理的工作方式類似於軟體工程師，所以我們不需要積極監控它，而是在完成後進行審查。讓我們將注意力轉向編寫程式碼和添加其他功能。

## 總結與下一步

本課探索了 [GitHub Copilot 編碼代理][copilot-agents]，您的 AI 配對程式設計師。使用編碼代理，您可以將議題分配給 Copilot 非同步執行。您可以使用 Copilot 來處理技術債務、建立新功能，或協助將程式碼從一個框架遷移到另一個框架。

您探索了以下概念：

- 自定義生成程式碼的環境。
- 確保操作安全執行。
- 明確界定議題的重要性。
- 將議題分配給 Copilot。

隨著編碼代理在後台勤奮工作，我們現在可以將注意力轉向我們的下一課，[使用 MCP 伺服器與外部服務互動][next-lesson]。[Copilot 編碼代理也可以使用 MCP 伺服器][coding-agent-mcp]，但我們將切換回我們的 Codespace，並嘗試將 MCP 與 Copilot 代理模式一起使用。

## 延伸應用
由於有 Coding Agent, 我們可以更容易的使用 Vibe Coding, 想要快速有個想法, 可以使用以下方式

透過 copilot chat的delagate coding agent, 直接在產生 UI 設計的 idea.
Ex:
```
幫我產生另一個更美化版本的圖片, 參考 #tailspin-toys-screenshot.png
```

Ex:
```
幫我產生另一個小型程式在另一個資料夾, 想要有類似
```


## 資源

- [關於 Copilot 編碼代理][copilot-agents]
- [將 GitHub 議題分配給 Copilot][assign-issue]
- [Copilot 編碼代理設定工作流程最佳實務][coding-agent-best-practices]

---

| [← 先決條件][previous-lesson] | [下一課：MCP 伺服器 →][next-lesson] |
|:--|--:|

[coding-agent-overview]: https://docs.github.com/copilot/using-github-copilot/coding-agent/about-assigning-tasks-to-copilot#overview-of-copilot-coding-agent
[coding-agent-mcp]: https://docs.github.com/copilot/how-tos/agents/copilot-coding-agent/extending-copilot-coding-agent-with-mcp
[assign-issue]: https://docs.github.com/copilot/using-github-copilot/coding-agent/using-copilot-to-work-on-an-issue
[setup-workflow]: https://docs.github.com/copilot/using-github-copilot/coding-agent/best-practices-for-using-copilot-to-work-on-tasks#pre-installing-dependencies-in-github-copilots-environment
[copilot-agents]: https://docs.github.com/copilot/using-github-copilot/coding-agent/about-assigning-tasks-to-copilot
[coding-agent-best-practices]: https://docs.github.com/copilot/using-github-copilot/coding-agent/best-practices-for-using-copilot-to-work-on-tasks
[github-actions]: https://docs.github.com/actions
[next-lesson]: ./2-mcp.zh-TW.md
[previous-lesson]: ./0-prereqs.zh-TW.md
