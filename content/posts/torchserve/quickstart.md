---
title: "TorchServe QuickStart 筆記"
date: 2023-08-28T23:49:48+08:00
draft: false
showtoc: true
math: false
tags: ["pytorch", "torchserve", "mlops"]
---

# TorchServe QuickStart 筆記

## Environment

OS: MacOS
Python Version: 3.9

首先用 pyenv virtualenv 建立 TorchServe 的環境:
```shell
pyenv virtualenv 3.9.16 torchserve
pyenv shell torchserve
```

把 TorchServe 的 repository 抓下來:
```shell
git clone https://github.com/pytorch/serve.git
cd serve
```

## Install Dependencies

安裝 dependencies
```shell
python ./ts_scripts/install_dependencies.py
```

可以看到這個 script 中主要是安裝 Python 以外的 dependencies
[serve/ts_scripts/install_dependencies.py](https://github.com/pytorch/serve/blob/683608b2306696a05ec09dff9666340ea7b9ce54/ts_scripts/install_dependencies.py#L146) 
```python
class Darwin(Common):
    def __init__(self):
        super().__init__()

    def install_java(self):
        if os.system("javac -version") != 0 or args.force:
            out = get_brew_version()
            if out == "N/A":
                sys.exit("**Error: Homebrew not installed...")
            os.system("brew install openjdk@17")

    def install_nodejs(self):
        os.system("brew unlink node")
        os.system("brew install node@14")
        os.system("brew link --overwrite node@14")

    def install_node_packages(self):
        os.system(f"{self.sudo_cmd} ./ts_scripts/mac_npm_deps")

    def install_wget(self):
        if os.system("wget --version") != 0 or args.force:
            os.system("brew install wget")

    def install_numactl(self):
        if os.system("numactl --show") != 0 or args.force:
            os.system("brew install numactl")
```

透過 pip 安裝 TorchServe
```shell
pip install torchserve torch-model-archiver torch-workflow-archiver
```


## Archive the Model

建立 `model_store` 資料夾，用來存放 `.mar` 檔案
```shell
mkdir model_store
```

下載 DenseNet 模型：
```shell
wget https://download.pytorch.org/models/densenet161-8d451a50.pth
```

打包模型：
```shell
torch-model-archiver \
    --model-name densenet161 \
    --version 1.0 \
    --model-file ./examples/image_classifier/densenet_161/model.py \
    --serialized-file densenet161-8d451a50.pth \
    --export-path model_store \
    --extra-files ./examples/image_classifier/index_to_name.json \
    --handler image_classifier
```
這個步驟會在 `model_store` 中產生一個叫做 `densenet161.mar` 的檔案。


## Serve the Model

打包好模型後就可以開始 serve 這個模型了：

```shell=
torchserve \
    --start \
    --ncs \
    --model-store model_store \
    --models densenet161.mar \
    --foreground
```

這邊用 `--foreground` 是希望可以直接用 Ctrl+c 關掉這個服務，若不使用則需要開另一個 terminal 輸入 `torchserve --stop`。

## Using REST APIs

下載範例圖片：
```shell
curl -O https://raw.githubusercontent.com/pytorch/serve/master/docs/images/kitten_small.jpg
```

透過 `curl` 來打這個 API
```shell
curl http://127.0.0.1:8080/predictions/densenet161 -T kitten_small.jpg
```

結果
```json
{
  "tabby": 0.47816672921180725,
  "lynx": 0.2001345157623291,
  "tiger_cat": 0.1682289093732834,
  "tiger": 0.06191280856728554,
  "Egyptian_cat": 0.05113609507679939
}
```

Health check API
```shell
curl http://127.0.0.1:8080/ping
```

```json
{
  "status": "Healthy"
}
```

List models API
```shell
curl http://127.0.0.1:8081/models
```

```json
{
  "models": [
    {
      "modelName": "densenet161",
      "modelUrl": "densenet161.mar"
    }
  ]
}
```

```
curl http://127.0.0.1:8081/models/densenet161
```

```json
[
  {
    "modelName": "densenet161",
    "modelVersion": "1.0",
    "modelUrl": "densenet161.mar",
    "runtime": "python",
    "minWorkers": 8,
    "maxWorkers": 8,
    "batchSize": 1,
    "maxBatchDelay": 100,
    "loadedAtStartup": true,
    "workers": [
      {
        "id": "9000",
        "startTime": "2023-08-28T23:35:26.082Z",
        "status": "READY",
        "memoryUsage": 12812288,
        "pid": 88220,
        "gpu": false,
        "gpuUsage": "N/A"
      },
      {
        "id": "9001",
        "startTime": "2023-08-28T23:35:26.083Z",
        "status": "READY",
        "memoryUsage": 12812288,
        "pid": 88215,
        "gpu": false,
        "gpuUsage": "N/A"
      },
      {
        "id": "9002",
        "startTime": "2023-08-28T23:35:26.083Z",
        "status": "READY",
        "memoryUsage": 12812288,
        "pid": 88219,
        "gpu": false,
        "gpuUsage": "N/A"
      },
      {
        "id": "9003",
        "startTime": "2023-08-28T23:35:26.083Z",
        "status": "READY",
        "memoryUsage": 12812288,
        "pid": 88216,
        "gpu": false,
        "gpuUsage": "N/A"
      },
      {
        "id": "9004",
        "startTime": "2023-08-28T23:35:26.083Z",
        "status": "READY",
        "memoryUsage": 12812288,
        "pid": 88218,
        "gpu": false,
        "gpuUsage": "N/A"
      },
      {
        "id": "9005",
        "startTime": "2023-08-28T23:35:26.083Z",
        "status": "READY",
        "memoryUsage": 12812288,
        "pid": 88214,
        "gpu": false,
        "gpuUsage": "N/A"
      },
      {
        "id": "9006",
        "startTime": "2023-08-28T23:35:26.083Z",
        "status": "READY",
        "memoryUsage": 12812288,
        "pid": 88213,
        "gpu": false,
        "gpuUsage": "N/A"
      },
      {
        "id": "9007",
        "startTime": "2023-08-28T23:35:26.083Z",
        "status": "READY",
        "memoryUsage": 15368192,
        "pid": 88217,
        "gpu": false,
        "gpuUsage": "N/A"
      }
    ]
  }
]
```

## References

- [TorchServe Quick Start](https://pytorch.org/serve/getting_started.html)
