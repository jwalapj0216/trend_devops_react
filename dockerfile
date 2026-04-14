# Stage 1: Build (IMPORTANT for Jenkins)
FROM node:18 AS build

WORKDIR /app
COPY . .

RUN npm install
RUN npm run build   # creates dist/

# Stage 2: Nginx
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

# Copy built files from build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Copy nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
