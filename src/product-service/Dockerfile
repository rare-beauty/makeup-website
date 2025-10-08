# syntax=docker/dockerfile:1
FROM node:20-alpine

WORKDIR /app

# install all deps (dev + prod)
COPY package*.json ./
RUN npm ci

# copy source
COPY . .

# app listens on 80 (matches your Deployment/probes)
ENV PORT=80
EXPOSE 80

# run as root (default) — just don't set USER
CMD ["node", "index.js"]
