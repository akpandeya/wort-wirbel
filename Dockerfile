# Use official Flutter image with stable channel
FROM ghcr.io/cirruslabs/flutter:stable

# Set working directory
WORKDIR /app

# Copy pubspec files first for better layer caching
COPY pubspec.yaml pubspec.lock ./

# Get dependencies (this layer will be cached if pubspec files don't change)
RUN flutter pub get

# Copy the rest of the application
COPY . .

# Build the web application
RUN flutter build web --release

# Use nginx to serve the static files
FROM nginx:alpine

# Copy the built web files to nginx html directory
COPY --from=0 /app/build/web /usr/share/nginx/html

# Copy custom nginx configuration for Flutter web SPA routing
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
