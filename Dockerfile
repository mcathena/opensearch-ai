FROM node:20-buster


# 创建并设置工作目录
WORKDIR /app

# 更新软件包信息并安装依赖
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libc6-compat

# 清理缓存以减小镜像大小
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# 复制项目文件到容器中
COPY . .

# 安装 Node.js 依赖
RUN npm install

ARG SEARCH_API_KEY
ARG MEM0_API_KEY
ARG BACKEND_SECURITY_KEY
ARG GOOGLE_CLIENT_ID
ARG GOOGLE_CLIENT_SECRET
ARG OPENAI_API_KEY

ENV SEARCH_API_KEY=${SEARCH_API_KEY}
ENV MEM0_API_KEY=${MEM0_API_KEY}
ENV BACKEND_SECURITY_KEY=${BACKEND_SECURITY_KEY}
ENV GOOGLE_CLIENT_ID=${GOOGLE_CLIENT_ID}
ENV GOOGLE_CLIENT_SECRET=${GOOGLE_CLIENT_SECRET}
ENV OPENAI_API_KEY=${OPENAI_API_KEY}



# 暴露端口
EXPOSE 3000

# 启动应用
CMD ["npm", "run", "dev"]
