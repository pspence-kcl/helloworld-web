# --- Stage 1: build the static Astro site ---
FROM node:22-alpine AS build
WORKDIR /app

# Install deps first so this layer caches unless package files change
COPY package.json package-lock.json ./
RUN npm ci

# Build the static output into /app/dist
COPY . .
RUN npm run build

# --- Stage 2: serve the built files with stock nginx ---
FROM nginx:alpine
# Astro's static build lands in dist/; nginx serves /usr/share/nginx/html by default
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
# nginx:alpine already runs `nginx -g 'daemon off;'` as its CMD
