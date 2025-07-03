# Build stage
FROM eclipse-temurin:17-jdk AS builder
WORKDIR /app

# First copy only the gradle files
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

# Install dos2unix and fix permissions
RUN apt-get update && \
    apt-get install -y dos2unix && \
    chmod +x gradlew && \
    dos2unix gradlew && \
    ./gradlew --version

# Then copy source and build
COPY src src
RUN ./gradlew build -x test

# Runtime stage
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar

# Explicit port configuration for Render
EXPOSE 8080
CMD ["java", "-jar", "-Dserver.port=8080", "-Dserver.address=0.0.0.0", "app.jar"]
