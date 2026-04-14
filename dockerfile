# Use nginx
FROM nginx:alpine

# Clean default files
RUN rm -rf /usr/share/nginx/html/*

# Copy prebuilt dist files
COPY dist/ /usr/share/nginx/html/

# Copy nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Run on 3000 (your requirement)
EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]
