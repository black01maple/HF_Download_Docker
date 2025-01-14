# Use the official Ubuntu base image
FROM ubuntu:22.04

# Set environment variables to non-interactive to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# 安装python等基础环境
RUN apt-get update && \
    apt-get install -y \
        software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y \
        python3.10 \
        python3.10-venv \
        python3.10-distutils \
        python3-pip \
        wget \
        git \
        libgl1 \
        libglib2.0-0 \
        && rm -rf /var/lib/apt/lists/*


# 将Python 3.10设为默认环境
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1

# 安装huggingface-cli
RUN pip3 install --upgrade pip && \
    pip install -U huggingface_hub

# 创建文件夹/opt/saved_model_parameters
RUN mkdir -p /opt/saved_model_parameters

# 复制下载指令
COPY hf_download.sh /opt/hf_download.sh
RUN chmod +x /opt/hf_download.sh

# Set the entry point to activate the virtual environment and run the command line tool
ENTRYPOINT ["/bin/bash", "-c", "sh /opt/hf_download.sh"]
