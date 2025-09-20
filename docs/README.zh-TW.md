# 軟體開發生命週期 (SDLC) 中的代理

GitHub Copilot 最近新增的功能為開發者在整個軟體開發生命週期 (SDLC) 中提供了強大的工具。這包括在 GitHub 上處理議題和拉取請求、與外部服務互動，當然還有程式碼建立。本實驗探索這些功能，提供真實世界的使用案例和如何充分利用這些工具的技巧。

## 實驗概述

> [!IMPORTANT]
> 因為 GitHub Copilot 和生成式 AI 一般來說是機率性的而不是確定性的，確切的程式碼、變更的檔案等可能會有所不同。因此，您可能會注意到實驗中的螢幕截圖和程式碼片段與您的體驗之間存在細微差異。這是可以預期的，只是使用這類工具的本質。
>
> 如果某些東西看起來損壞或無法正常運行，請詢問導師！

這些實驗將帶您了解 GitHub Copilot 代理功能的最常見工作流程。

0. [設定環境](./0-prereqs.zh-TW.md)。
1. [將議題分配給 GitHub Copilot 編碼代理](./1-copilot-coding-agent.zh-TW.md)以允許 Copilot 非同步處理任務。
2. [透過模型上下文協定 (MCP) 配置並與外部服務互動](./2-mcp.zh-TW.md)。
3. [透過使用自定義指令、提示檔案和聊天參與者為 Copilot 提供上下文](./3-custom-instructions.zh-TW.md)。
4. [在 Copilot 代理模式的幫助下完成全站更新](./4-copilot-agent-mode-vscode.zh-TW.md)。
5. [審查 Copilot 編碼代理的工作](./5-reviewing-coding-agent.zh-TW.md)以確保一切看起來都很好！
6. [使用 Spec-kit 與 Copilot Coding Agent](./6-using-spec-kit-with-coding-agent.zh-TW.md) 整合需求規格與開發流程。
7. [後續工作與延伸整合（Future Work）](./7-future-work.zh-TW.md) 探索 CI/CD、Pages、安全與專案治理。

## 情境

實驗設想您是 Tailspin Toys 的新開發者，這是一家虛構的公司，為以 DevOps 為主題的桌上遊戲提供眾籌 - 一個龐大的市場！您的任務是建立議題來記錄應用程式和 DevOps 流程所需的更新，然後實作按類別和發佈商過濾遊戲的功能。您將迭代工作，探索網站和 Copilot 的功能，來完成任務。

## 開始使用

好的，讓我們[從設定開始][prereqs]！

[prereqs]: ./0-prereqs.zh-TW.md
