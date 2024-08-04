# 构建应用
FROM base AS builder
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# 生产环境
FROM base AS runner
ENV NODE_ENV production

# 设置环境变量
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

# 复制必要文件
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

# 暴露端口并启动应用
EXPOSE 3000
CMD ["node", "server.js"]
