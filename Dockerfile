FROM maven:3.9.3-amazoncorretto-17 as build

RUN mkdir microservices

WORKDIR /microservices

COPY pom.xml .

RUN mvn dependency:go-offline

COPY src src

RUN mvn package

FROM amazoncorretto:17

VOLUME /hello-service

COPY --from=build /microservices/target/*.jar hello-service.jar

ENTRYPOINT ["java","-jar","hello-service.jar"]

# Stage 1: Build the Java Spring Boot service JAR file
# maven:3.9.4-amazoncorretto-17 AS builder
#RUN apk update && apk add maven
#COPY . /
#RUN mvn clean package

# Stage 2: Copy the JAR file to the child container and run the service
#FROM amazoncorretto:17
#COPY builder:/target/*.jar /hello-service.jar
#CMD ["java", "-jar", "/hello-service.jar"]