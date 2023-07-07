FROM node:20 AS base
WORKDIR /app
COPY package*.json ./

FROM base AS dependencies
RUN npm ci
COPY . .
RUN npm run build

FROM node:20-alpine AS release
WORKDIR /app
COPY --from=dependencies /app/dist/* ./

EXPOSE 3000

CMD ["node", "index.js"]
