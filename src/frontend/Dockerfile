# FROM node:18
# WORKDIR /app
# COPY . .
# RUN npm install
# EXPOSE 3000
# CMD ["npm", "start"]

# ---- build stage ----
FROM node:18-alpine AS build
WORKDIR /app

# 1) Install deps from repo root (package.json lives at the root)
COPY package*.json ./
RUN npm ci

# 2) Copy the whole repo and build the FRONTEND app
COPY . .
WORKDIR /app/src/frontend
RUN npm run build    # outputs /app/src/frontend/build

# ---- final runtime stage ----
FROM nginx:alpine
# optional: remove default nginx page
RUN rm -rf /usr/share/nginx/html/*
# copy the React build into nginx html dir
COPY --from=build /app/src/frontend/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
