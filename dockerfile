# Stage 1: Install dependencies
FROM node:20-alpine AS dependencies

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev


# Stage 2: Production image
FROM node:20-alpine

WORKDIR /app

# Copy production dependencies
COPY --from=dependencies /app/node_modules ./node_modules

# Copy application source
COPY . .

# Backend listens on port 8000
EXPOSE 8000

# Start the backend
CMD ["npm", "start"]
