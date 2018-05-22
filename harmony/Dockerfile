FROM java:8

RUN apt-get install -y git && \
    git clone https://github.com/kodality/ethereum-harmony

WORKDIR /ethereum-harmony

RUN ./gradlew classes

COPY keystore /root/ethereumj/keystore

EXPOSE 8080
CMD ["./gradlew", "runPrivate"]
