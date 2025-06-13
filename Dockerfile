# Use the official Ubuntu base image
FROM ubuntu:22.04

# Set environment variables to non-interactive to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# 设置阿里云镜像源
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse" > /etc/apt/sources.list \
    && echo "deb-src http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list

# 安装python等基础环境
#RUN apt-get update && \
#    apt-get install -y \
#        software-properties-common && \
#    add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update && \
    apt-get install -y \
        python3.10 \
        python3.10-venv \
        python3.10-distutils \
        python3-pip \
        && rm -rf /var/lib/apt/lists/*

# 将Python 3.10设为默认环境
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1

# 修改 pip 源为清华源
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip3 install --upgrade pip
# 安装huggingface-cli
RUN pip install -U "huggingface_hub[hf_xet]" -i https://pypi.tuna.tsinghua.edu.cn/simple

# 创建文件夹/opt/saved_model_parameters
RUN mkdir -p /opt/saved_model_parameters

# 复制下载脚本
WORKDIR /opt
COPY download_script.py ./download_script.py
RUN chmod +x ./download_script.py

# Set the entry point to activate the virtual environment and run the command line tool
ENTRYPOINT ["/bin/bash", "-c", "cd /opt && python3 download_script.py"]
