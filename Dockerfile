# Builder
FROM ghcr.io/graalvm/graalvm-ce:22.2.0 AS builder
COPY  . /root/app/
WORKDIR /root/app
RUN sed -i 's/\r$//' mvnw 
# sed -i 's/\r$//' mvnw Devido a um problema com caracteres de retorno (\r) precisei adicionar essa linha para remover esses caracteres durante a execução no windows.
RUN ./mvnw clean install -DskipTests

# Application
FROM ghcr.io/graalvm/graalvm-ce:22.2.0 AS application
COPY --from=builder /root/app/target/*.jar /home/app/
WORKDIR /home/app
RUN chmod 0777 /home/app
EXPOSE 8080
ENTRYPOINT java -jar $JAVA_OPTIONS *.jar 