---
title: "Draft: Langchain 的 Conversational Retrieval Chain 做了什麼?"
date: 2023-07-17T21:43:09+08:00
draft: false
showtoc: true
math: false
---

## 基本用法

```python
from dotenv import find_dotenv, load_dotenv
from langchain.chains import ConversationalRetrievalChain
from langchain.chat_models import ChatOpenAI
from langchain.embeddings import OpenAIEmbeddings
from langchain.memory import ConversationBufferMemory
from langchain.schema import Document
from langchain.vectorstores import FAISS

load_dotenv(find_dotenv())

docs = [Document(page_content='There are five apples, three oranges, and two bananas.')]
vectorstore = FAISS.from_documents(docs, OpenAIEmbeddings())

llm = ChatOpenAI()
memory = ConversationBufferMemory(memory_key='chat_history')
chain = ConversationalRetrievalChain.from_llm(llm=llm,
                                              retriever=vectorstore.as_retriever(),
                                              memory=memory,
                                              verbose=True)

output = chain.run('How many types of fruit are there?')
print(output)

>> There are three types of fruit: apples, oranges, and bananas.
```

`ConversationalRetrievalChain` 是用來建立一個對話式檢索系統，讓使用者可以透過自然語言的問句來檢索相關的對話。

這裡先來理解一下程式碼中的基本用法：

`import` 部分：引入所需的程式庫，包括 `dotenv` 用於載入環境變數，`ConversationalRetrievalChain` 用於建立對話式檢索鏈，以及其他相關的模組和類別。

環境變數載入：使用 `load_dotenv` 函數從 `.env` 檔案載入環境變數。

建立文檔：建立一個包含文本內容的 `Document` 物件，這裡的例子是一個包含水果數量描述的文本。

向量化存儲：使用 `OpenAIEmbeddings` 將文檔向量化，然後使用 `FAISS` 建立向量存儲。

建立對話式檢索鏈：初始化一個 `ChatOpenAI` 的模型，並使用`ConversationalRetrievalChain.from_llm` 方法來構建對話式檢索鏈，這個 `chain` 包含了向量檢索和對話兩部分。

檢索：使用構建好的對話式檢索鏈對問句 "How many types of fruit are there?" 進行檢索。

輸出結果：打印檢索結果，這裡是回答了問句的內容。

## Prompts

```python
# flake8: noqa
from langchain.prompts.prompt import PromptTemplate

_template = """Given the following conversation and a follow up question, rephrase the follow up question to be a standalone question, in its original language.

Chat History:
{chat_history}
Follow Up Input: {question}
Standalone question:"""
CONDENSE_QUESTION_PROMPT = PromptTemplate.from_template(_template)

prompt_template = """Use the following pieces of context to answer the question at the end. If you don't know the answer, just say that you don't know, don't try to make up an answer.

{context}

Question: {question}
Helpful Answer:"""
QA_PROMPT = PromptTemplate(
    template=prompt_template, input_variables=["context", "question"]
)

```

這部分程式碼定義了兩個 prompt (提示) 的模板，用於生成輸入給對話式檢索鏈的問句。這些 prompt 模板是為了幫助模型理解如何生成正確的回答。

`CONDENSE_QUESTION_PROMPT`: 這個模板是用於將後續的問句轉換成獨立的問題形式。它提供了一個對話的歷史記錄 (chat_history) 以及一個後續問句 (question)，然後要求生成一個獨立的問句。

`QA_PROMPT`: 這個模板用於提示回答問題。它提供了一些上下文 (context)，然後包含了一個問題 (question)，要求模型回答這個問題。

`ConversationalRetrievalChain` 是一個透過檢索與記憶的機制來進行對話式回答的 `Class`，而 Prompt 部分則是用於提示和輸入問句的模板。這可以是一個強大的工具，用於構建自然語言處理應用，特別是在對話式回答和檢索方面。
