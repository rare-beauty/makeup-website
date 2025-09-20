# FROM node:18
# WORKDIR /app
# COPY . .
# RUN npm install
# EXPOSE 3000
# CMD ["npm", "start"]

# ---- build stage ----
FROM node:18-alpine AS build
WORKDIR /app

# Install ONLY the frontend deps first (leverages Docker cache)
COPY src/frontend/package*.json ./src/frontend/
RUN cd src/frontend && npm ci

# Now copy the whole repo (code)
COPY . .

# Build the frontend app
WORKDIR /app/src/frontend
RUN npm run build   # produces /app/src/frontend/build

# ---- final runtime stage ----
FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /app/src/frontend/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx","-g","daemon off;"]
