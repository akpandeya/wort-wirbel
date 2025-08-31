FROM ghcr.io/cirruslabs/flutter:stable

# Build argument for version information
ARG VERSION=development
ENV APP_VERSION=$VERSION

WORKDIR /app

COPY pubspec.yaml ./

RUN flutter pub get

COPY . .

# Build web app with version information
RUN flutter build web --release --dart-define=APP_VERSION=$APP_VERSION

FROM nginx:alpine

# Copy version information to the final image
ARG VERSION=development
ENV APP_VERSION=$VERSION

COPY --from=0 /app/build/web /usr/share/nginx/html

COPY nginx.conf /etc/nginx/nginx.conf

# Add version information as a label
LABEL version=$VERSION
LABEL description="Wort-Wirbel German flashcard app"

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
