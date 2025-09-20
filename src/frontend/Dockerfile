# FROM node:18
# WORKDIR /app
# COPY . .
# RUN npm install
# EXPOSE 3000
# CMD ["npm", "start"]

# ---- build stage ----
FROM node:18-alpine AS build

# Work directly in the frontend folder
WORKDIR /app/src/frontend

# 1) Install deps (cache-friendly)
COPY src/frontend/package*.json ./
RUN npm ci

# 2) Copy the app code and build
COPY src/frontend/ .
RUN npm run build

# ---- runtime stage ----
FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /app/src/frontend/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx","-g","daemon off;"]
