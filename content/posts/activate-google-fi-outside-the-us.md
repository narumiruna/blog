---
title: "取得半殘 Google Fi 門號"
date: 2023-11-02T23:59:16+08:00
draft: false
showtoc: true
math: false
tags: ["google fi", "wireless", "esim", "aws", "ec2", "gcp", "azure", "vultr", "vpn", "pritunl"]
---

## 主流程

1. 到 Google Fi 申請 eSIM
2. 到 AWS/Azure/GCP 架設放在美國的 Pritunl Server
    - AWS us-west-2 可用
    - Azure us-3 可用
    - vultr 會被擋
4. 在手機上透過 OpenVPN app 連到自己架設的 Pritunl Server
5. 用美國 Apple ID 到 App Store 下載 Google Fi App
6. 開啟 VPN 啟用 Google Fi eSIM (可以把 VPN Server 關了)
7. 到 設定>行動服務>SIM 那邊開啟 Wi-Fi Calling(Wi-Fi通話) 的功能
8. 重開手機
9. 要打電話或收簡訊的時候把行動網路關掉

![](https://i.imgur.com/0fNgwrl.png)

## 修復半殘

帶手機飛到美國就能修復半殘的 Google Fi

若暫時沒有要飛過去只好找人幫忙

1. 找到準備入境美國的朋友
2. 準備一隻沒有在用的手機
3. 清空資料，只安裝 Google Fi App
4. 把 sim or esim 轉移到這支手機上
5. 關機後把手機交給朋友
6. 請朋友在入境美國後開機，不需要解鎖，並通知你 resume service
7. 請朋友確認手機是否有偵測到行動網路，確認後就可以關機
    - 透過 skype 打給自己的號碼測試也行
8. 拿起平時用的手機，重新安裝 Google Fi App
9. 啟用 eSIM 後即可把門號轉移回原本的手機

## References

- [Pritunl](https://pritunl.com/)
- [Self-hosted Pritunl VPN in AWS EC2](https://aws.plainenglish.io/self-hosted-pritunl-vpn-in-aws-fc9c204c7cbd)

