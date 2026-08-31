# =========================
# Stage 1: Build React app
# =========================
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies first for Docker layer caching
COPY package*.json ./

RUN npm ci

# Copy application source
COPY . .

# Production API configuration
ARG VITE_ENV=production
ARG VITE_BACKEND_API_URL=http://abhi.app.local/api/v1

ENV VITE_ENV=${VITE_ENV}
ENV VITE_BACKEND_API_URL=${VITE_BACKEND_API_URL}

# Build Vite application
RUN npm run build


# =========================
# Stage 2: Nginx
# =========================
FROM nginx:alpine

# Remove default nginx configuration
RUN rm /etc/nginx/conf.d/default.conf

# Our React SPA nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy React production files
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

