FROM openjdk:17-ea-jdk-alpine3.14
LABEL maintainer="PM"

COPY target/*.jar /app.jar
RUN apk add -U tzdata; \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
    echo 'Asia/Shanghai' > /etc/timezone; \
    #更新文件最后编辑时间
    touch /app.jar

ENV JAVA_OPTS=""
ENV PARAMS=""

EXPOSE 8080

ENTRYPOINT [ "sh", "-c", "java -Djava.security.egd=file:/dev/./urandom ${JAVA_OPTS} -jar /app.jar ${PARAMS}" ]
