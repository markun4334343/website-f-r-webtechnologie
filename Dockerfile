# 1. Copy only the necessary files first
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

# 2. Fix permissions and line endings (CRITICAL)
RUN chmod +x gradlew && \
    dos2unix gradlew && \
    ./gradlew --version  # Verify it works

# 3. Copy source and build
COPY src src
RUN ./gradlew build -x test --stacktrace

# Runtime stage
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar
CMD ["java", "-jar", "app.jar"]
