FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# 避免安裝互動提示
ENV DEBIAN_FRONTEND=noninteractive

# 安裝核心 EDA 工具
# 1. iverilog: 仿真器
# 2. verilator: 用於強大的 Linting (語法檢查)
# 3. make: 自動化構建
# 4. git: 版本控制
RUN apt-get update && apt-get install -y \
    iverilog \
    verilator \
    make \
    git \
    vim \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*
