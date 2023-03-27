FROM node:19

ENV THELOUNGE_HOME "/var/opt/thelounge"
VOLUME "${THELOUNGE_HOME}"

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Expose HTTP.
ENV PORT 9000

EXPOSE ${PORT}
ENTRYPOINT ["yarn", "start"]

RUN git clone https://github.com/thelounge/thelounge.git .
RUN yarn
RUN NODE_ENV=production yarn build