# syntax=docker/dockerfile:1
FROM node:20-alpine

WORKDIR /app

# Install ALL deps (incl. dev) to satisfy your requirement
COPY package*.json ./
RUN npm ci

# Copy source
COPY . .

# App listens on 80 (matches your current Deployment/probes)
ENV PORT=80
EXPOSE 80

# Run as non-root
USER node

# Start
CMD ["node", "index.js"]
