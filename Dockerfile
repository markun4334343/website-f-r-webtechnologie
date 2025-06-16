FROM eclipse-temurin:17-jdk
WORKDIR /app
COPY . .
RUN chmod +x gradlew && ./gradlew build
CMD ["java", "-jar", "build/libs/webtech-0.0.1-SNAPSHOT.jar"]