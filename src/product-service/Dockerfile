FROM node:20-alpine

WORKDIR /app

# install deps first (better caching)
COPY package*.json ./
RUN npm ci --omit=dev

# copy app code
COPY . .

# make the port configurable; default 8080
ENV NODE_ENV=production
ENV PORT=8080
EXPOSE 8080

# run as non-root (alpine node image has a 'node' user)
USER node

CMD ["npm", "start"]
