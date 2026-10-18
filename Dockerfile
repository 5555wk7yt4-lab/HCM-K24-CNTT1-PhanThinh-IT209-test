FROM gradle:8.14-jdk21-alpine AS build
WORKDIR /workspace
COPY . .
RUN gradle dependencies --no-daemon-q
RUN gradle bootJar --no-daemon -x test -q
FROM eclipse-temurin:21-jre-alpine AS runtime
WORKDIR /app
RUN addgroup -S josthinh && adduser -S josthinh -G josthinh
COPY --from=build --chown=josthinh:josthinh /workspace/build/libs/app.jar /app/app.jar
USER josthinh

EXPOSE 8086

# ENTRYPOINT dạng exec (mảng JSON)
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
