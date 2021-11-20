FROM buildpack-deps:stretch

RUN groupadd --gid 1000 node \
  && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

ENV NODE_VERSION 12.22.7

WORKDIR /usr/src/

COPY . nuclear

RUN apt-get update && apt-get install -y libnss3 libgtk-3-0 libx11-xcb1 libxss1 libasound2

WORKDIR nuclear

RUN npm install && npm run build:dist && npm run build:electron && npm run pack

RUN ls -a | grep -v release | xargs rm -rf || true

CMD ["./release/linux-unpacked/nuclear"]
