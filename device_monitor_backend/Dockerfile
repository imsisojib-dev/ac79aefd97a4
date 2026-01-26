


FROM maven:3.8-openjdk-17 AS build
COPY src /home/app/src
COPY pom.xml /home/app
WORKDIR /home/app
RUN mvn clean package -DskipTests=true


# ---- Updated Base Image (stable, not buster) ----
FROM eclipse-temurin:21-jre

RUN apt-get update && apt-get install -y \
    libfreetype6 fontconfig \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /home/app
COPY .env .env
COPY --from=build /home/app/target/*.jar /usr/local/lib/app.jar

EXPOSE 8088
ENTRYPOINT ["java", "-Djava.awt.headless=true", "-jar", "/usr/local/lib/app.jar"]
