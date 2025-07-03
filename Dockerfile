# Build stage
FROM eclipse-temurin:17-jdk AS builder
WORKDIR /app

# 1. Copy only gradle files first (better caching)
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

# 2. Fix permissions and line endings (critical for Windows)
RUN apt-get update && \
    apt-get install -y dos2unix && \
    dos2unix gradlew && \
    chmod +x gradlew

# 3. Resolve dependencies first
RUN ./gradlew dependencies --refresh-dependencies

# 4. Copy source and build (with debug)
COPY src src
RUN ./gradlew build --no-daemon --stacktrace -x test

# Runtime stage
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar
CMD ["java", "-jar", "app.jar"]
