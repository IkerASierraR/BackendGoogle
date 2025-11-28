# ================================
# Stage 1: Build with Maven
# ================================
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# ================================
# Stage 2: Runtime Image
# ================================
FROM eclipse-temurin:17-jdk
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

# Render provides the PORT environment variable
ENV PORT=8080

# Tell Spring Boot to use Render's PORT dynamically
ENV JAVA_OPTS="-Dserver.port=${PORT}"

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar app.jar"]
