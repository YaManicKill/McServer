FROM node:18

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN git clone https://github.com/DerEnderKeks/Yanius.git .

RUN npm install

COPY default.json /usr/src/app/config/

ENTRYPOINT ["npm", "start"]