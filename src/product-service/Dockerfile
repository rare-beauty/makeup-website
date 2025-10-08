FROM node:20-alpine

# allow binding to ports <1024 without root
RUN apk add --no-cache libcap \
  && setcap 'cap_net_bind_service=+ep' /usr/local/bin/node

WORKDIR /app

# install deps (better layer caching)
COPY package*.json ./
RUN npm ci --omit=dev

# copy app
COPY . .

ENV NODE_ENV=production
ENV PORT=80
EXPOSE 80

# stay non-root
USER node

CMD ["npm", "start"]
