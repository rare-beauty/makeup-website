# FROM node:18
# WORKDIR /app
# COPY . .
# RUN npm install
# EXPOSE 3000
# CMD ["npm", "start"]

# ---- build stage ----
FROM node:18-alpine AS build
WORKDIR /app

# 1) deps for THIS service (context is src/frontend)
COPY package*.json ./
RUN npm ci

# 2) copy app code and build
COPY . .
RUN npm run build    # creates /app/build

# ---- runtime ----
FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx","-g","daemon off;"]
