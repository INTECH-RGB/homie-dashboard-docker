FROM node:6-alpine
#FROM resin/armhf-alpine-node:6-slim # arch=armhf
ARG ARCH=amd64
ARG HOMIE_DASHBOARD_VERSION=latest
# needed for ARG not to be ignored
RUN echo "Building Homie Dashboard $HOMIE_DASHBOARD_VERSION Docker image for $ARCH"

# Home directory for homie-dashboard source code
RUN mkdir -p /usr/src/homie-dashboard

# User data directory
RUN mkdir -p /homie-dashboard

WORKDIR /usr/src/homie-dashboard

# Add homie-dashboard user so we aren't running as root
RUN adduser -h /usr/src/homie-dashboard -D -H homie-dashboard \
  && chown -R homie-dashboard:homie-dashboard /homie-dashboard \
  && chown -R homie-dashboard:homie-dashboard /usr/src/homie-dashboard

RUN apk add --no-cache --virtual build-dependencies make g++ python \
  && npm install "homie-dashboard@$HOMIE_DASHBOARD_VERSION" \
  && apk del build-dependencies

USER homie-dashboard

# ADD overlay-common /overlay
# ADD overlay-${ARCH} /overlay

VOLUME ["/homie-dashboard"]

EXPOSE 35589

CMD ["node", "./node_modules/homie-dashboard/src/bin/cli.js", "--ip", "0.0.0.0", "--port", "35589", "--dataDir", "/homie-dashboard"]
