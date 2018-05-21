FROM mhart/alpine-node:8.11.2

WORKDIR /app
COPY . .
RUN chmod +x start.sh
RUN apk add --no-cache git

RUN npm i -g npm@5.6.0
RUN npm install -g truffle
RUN npm install

EXPOSE 8088
ENTRYPOINT "/app/start.sh"