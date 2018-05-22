FROM java:8

RUN apt-get install -y git && \
    git clone https://github.com/ether-camp/ethereum-harmony

WORKDIR /ethereum-harmony

COPY src/main /ethereum-harmony/src/main
RUN ./gradlew classes

COPY keystore /root/ethereumj/keystore

EXPOSE 8080
CMD ["./gradlew", "runPrivate"]
