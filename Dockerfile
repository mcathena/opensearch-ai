# 构建阶段
FROM node:20-alpine AS builder
WORKDIR /app

# 安装依赖
RUN apk add --no-cache git curl libc6-compat
COPY package*.json ./
RUN npm ci

# 复制源代码并构建
COPY . .
RUN npm run build

# 生产阶段
FROM node:20-alpine AS runner
WORKDIR /app

# 安装生产环境需要的包
RUN apk add --no-cache libc6-compat

# 设置环境变量
ARG SEARCH_API_KEY
ARG MEM0_API_KEY
ARG BACKEND_SECURITY_KEY
ARG GOOGLE_CLIENT_ID
ARG GOOGLE_CLIENT_SECRET
ARG OPENAI_API_KEY

ENV NODE_ENV production
ENV SEARCH_API_KEY=${SEARCH_API_KEY}
ENV MEM0_API_KEY=${MEM0_API_KEY}
ENV BACKEND_SECURITY_KEY=${BACKEND_SECURITY_KEY}
ENV GOOGLE_CLIENT_ID=${GOOGLE_CLIENT_ID}
ENV GOOGLE_CLIENT_SECRET=${GOOGLE_CLIENT_SECRET}
ENV OPENAI_API_KEY=${OPENAI_API_KEY}

# 复制构建产物和必要文件
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

# 暴露端口
EXPOSE 3000

# 启动应用
CMD ["npm", "start"]
