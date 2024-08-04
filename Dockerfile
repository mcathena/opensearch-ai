# 使用 Node.js 官方镜像作为基础镜像
FROM node:18-alpine AS base

# 设置工作目录
WORKDIR /app

# 安装依赖
FROM base AS deps
COPY package.json package-lock.json* ./
RUN npm ci

# 构建应用
FROM base AS builder
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# 生产环境
FROM base AS runner
ENV NODE_ENV production
ENV SEARCH_API_KEY ${SEARCH_API_KEY}
ENV MEM0_API_KEY ${MEM0_API_KEY}
ENV BACKEND_SECURITY_KEY ${BACKEND_SECURITY_KEY}
ENV GOOGLE_CLIENT_ID ${GOOGLE_CLIENT_ID}
ENV GOOGLE_CLIENT_SECRET ${GOOGLE_CLIENT_SECRET}
ENV OPENAI_API_KEY ${OPENAI_API_KEY}

# 复制必要文件
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

# 暴露端口并启动应用
EXPOSE 3000
CMD ["node", "server.js"]
