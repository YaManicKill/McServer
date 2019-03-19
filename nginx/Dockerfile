FROM alpine:3.9

RUN apk update && apk add --no-cache nginx

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/usr/sbin/nginx", "-g", "pid /tmp/nginx.pid; daemon off;"]
