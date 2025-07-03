# Build stage
FROM eclipse-temurin:17-jdk AS builder
WORKDIR /app

# 1. Copy only build files first (better caching)
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

# 2. Fix line endings and permissions (Windows/Linux compatibility)
RUN sed -i.bak 's/\r$//' gradlew && \
    chmod +x gradlew && \
    rm gradlew.bak

# 3. Resolve dependencies (helps catch issues early)
RUN ./gradlew dependencies

# 4. Copy source code and build (skip tests temporarily)
COPY src src
RUN ./gradlew build -x test -Djava.net.preferIPv4Stack=true --stacktrace

# Runtime stage
FROM eclipse-temurin:17-jre
WORKDIR /app

# 1. Copy built JAR (use wildcard to avoid version conflicts)
COPY --from=builder /app/build/libs/*.jar app.jar

# 2. Runtime configuration
CMD ["sh", "-c", "echo \"127.0.0.1 localhost\" >> /etc/hosts && java -Djava.net.preferIPv4Stack=true -jar app.jar"]
