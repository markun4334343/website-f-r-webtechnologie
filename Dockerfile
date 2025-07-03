# Stage 1: Build
FROM eclipse-temurin:17-jdk AS builder
WORKDIR /app

# Copy build files first (better caching)
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

# Fix permissions and line endings (critical for Render)
RUN chmod +x gradlew && \
    sed -i 's/\r$//' gradlew && \
    ./gradlew --version

# Build with production settings
COPY src src
RUN ./gradlew build -x test -Pprod

# Stage 2: Runtime
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar

# Render-specific requirements
EXPOSE ${PORT:-8080}
HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://localhost:${PORT:-8080}/actuator/health || exit 1
CMD ["java", "-Dserver.port=${PORT:-8080}", "-jar", "app.jar"]
