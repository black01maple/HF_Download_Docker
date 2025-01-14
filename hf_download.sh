#!/bin/bash

# 检查是否找到宿主机挂载点
if [ -z "$mount_info" ]; then
    echo "没有挂载宿主机模型下载目录，下载终止"
    echo "请通过 docker run -v 我的下载目录:/opt/saved_model_parameters 来挂载路径"
    exit 1
else
    # 提取宿主机路径
    host_path=$(echo $mount_info | awk '{print $5}')
    # 输出宿主机路径
    echo "宿主机模型下载目录: $host_path"
fi

# 检查环境变量model_name是否存在
if [ -z "$model_name" ]; then
    echo "模型名称model_name未设置(环境变量)，下载终止"
    echo "请通过 docker run -e model_name=\"你需要下载的模型名称\" 来传入变量"
    exit 1
fi

# 检查环境变量token是否存在
if [ -z "$token" ]; then
    echo "下载服务的token未设置(环境变量)，下载终止"
    echo "请通过 docker run -e token=\"huggingface的token\" 来传入变量"
    exit 1
fi

model_name=$model_name
model_dir="/opt/saved_model_parameters"
last_part=${model_name#*/}
new_model_dir="$model_dir/$last_part"
hf_token=$token
export HF_ENDPOINT=https://hf-mirror.com
echo "正在下载至 ${new_model_dir} ......"
while ! huggingface-cli download --resume-download $model_name --local-dir $new_model_dir --token $hf_token; do
    echo "下载中断，正在尝试继续下载......"
    sleep 1
done