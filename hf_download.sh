#!/bin/bash

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