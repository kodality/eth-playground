FROM mhart/alpine-node:9.11.1

WORKDIR /app
COPY . .
RUN chmod +x start.sh
RUN apk add --no-cache git

RUN npm i -g npm@5.6.0
RUN npm install

#fix broken dependency
RUN mv fix/* node_modules/

EXPOSE 8080
ENTRYPOINT ["/app/start.sh"]