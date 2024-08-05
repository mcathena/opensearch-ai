
# 选择一个带有 Node.js 的基础镜像
FROM node:20-buster

# 创建并设置工作目录
WORKDIR /app

# 更新系统并安装 curl 和 git
RUN apt-get update && apt-get install -y curl git && rm -rf /var/lib/apt/lists/*

# 复制 package.json 和 package-lock.json (如果存在)
COPY package*.json ./

# 安装项目依赖
RUN npm install

# 复制剩余的项目文件到工作目录
COPY . .

# 构建应用
RUN npm run build

# 设置环境变量
ENV NODE_ENV=production

# 暴露端口 3000
EXPOSE 3000

# 设置启动命令
CMD ["npm", "start"]
