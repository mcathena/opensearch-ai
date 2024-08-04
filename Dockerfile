# 使用官方 Node.js 镜像作为基础镜像
FROM node:18 AS builder

# 创建并设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json 文件
COPY package*.json ./

# 安装应用依赖
RUN npm install

# 复制应用代码
COPY . .

# 构建 Next.js 应用
RUN npm run build

# 使用较小的 Node.js 镜像来运行应用
FROM node:18-alpine

# 创建并设置工作目录
WORKDIR /app

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


# 复制从 builder 阶段生成的文件
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./
COPY --from=builder /app/public ./public

# 安装生产环境依赖
RUN npm install --only=production

# 暴露端口
EXPOSE 3000

# 启动应用
CMD ["npm", "start"]


