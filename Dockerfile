FROM eclipse-temurin:17-jdk AS builder
WORKDIR /app
COPY . .

# Fix common issues
RUN sed -i 's/\r$//' gradlew && \
    chmod +x gradlew && \
    echo "127.0.0.1 localhost" >> /etc/hosts

# Build with IPv4 preference
RUN ./gradlew build -Djava.net.preferIPv4Stack=true

# Runtime
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar

# Explicit network settings
CMD ["java", "-Djava.net.preferIPv4Stack=true", "-jar", "app.jar"]
