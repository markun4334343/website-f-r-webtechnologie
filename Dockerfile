FROM eclipse-temurin:17-jdk AS builder
WORKDIR /app
COPY . .

# Fix line endings and permissions (Windows/Linux compatibility)
RUN sed -i.bak 's/\r$//' gradlew && \
    chmod +x gradlew && \
    rm gradlew.bak

# Build with IPv4 preference (no /etc/hosts modification needed)
RUN ./gradlew build -Djava.net.preferIPv4Stack=true

# Runtime stage
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar

# Add host entries at runtime (not build time)
CMD ["sh", "-c", "echo \"127.0.0.1 localhost\" >> /etc/hosts && java -Djava.net.preferIPv4Stack=true -jar app.jar"]
