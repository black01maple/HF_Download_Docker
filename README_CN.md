构建一个用来下载huggingface上模型的docker镜像。使用hf mirror镜像源（国内可用）。

# Quick Start

1. 构建镜像
```bash
docker build -t hf_download:latest .
```

2. 启动容器
```bash
docker run --rm -v /你的下载目录:/opt/saved_model_parameters -e model_name=模型名称 -e token=你的huggingface账号token hf_download:latest
```
- 模型名称 获取方式
  进入huggingface官网，找到你需要下载的模型，点击模型名称右侧的复制按钮（如下图）

- huggingface账号token 获取方式
