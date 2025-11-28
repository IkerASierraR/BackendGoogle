# ================================
# Etapa 1: Build con Maven
# ================================
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copiar pom.xml y descargar dependencias
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiar el código fuente y compilar
COPY src ./src
RUN mvn clean package -DskipTests

# ================================
# Etapa 2: Imagen final (runtime)
# ================================
FROM eclipse-temurin:17-jdk
WORKDIR /app

# Copiar el JAR compilado
COPY --from=build /app/target/*.jar app.jar

# Render normalmente usa un puerto dinámico (PORT)
# pero este EXPOSE no afecta, solo documenta el puerto interno usado por Spring Boot
EXPOSE 8080

# Ejecutar el backend
ENTRYPOINT ["java", "-jar", "app.jar"]
