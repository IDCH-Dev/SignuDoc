# Coolify build for IDCH self-hosting (Node 24, local disk storage on /data/signudoc).
FROM node:24-bookworm-slim AS build
WORKDIR /app
ENV NEXT_TELEMETRY_DISABLED=1
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:24-bookworm-slim
WORKDIR /app
ENV NODE_ENV=production NEXT_TELEMETRY_DISABLED=1 PORT=3000 HOSTNAME=0.0.0.0
COPY --from=build /app ./
RUN mkdir -p /data/signudoc/storage
EXPOSE 3000
CMD ["sh", "-c", "node db/migrate.mjs && exec npx next start -H 0.0.0.0 -p 3000"]
