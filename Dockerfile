FROM homiedashboard/node:amd64-latest
#FROM homiedashboard/node:armhf-latest # arch=armhf
ARG ARG_ARCH=amd64
ARG ARG_HOMIE_DASHBOARD_VERSION=latest
# needed for ARG not to be ignored
RUN echo "Building Homie Dashboard ${ARG_HOMIE_DASHBOARD_VERSION} Docker image for ${ARG_ARCH}"

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
  && npm install "homie-dashboard@${ARG_HOMIE_DASHBOARD_VERSION}" \
  && apk del build-dependencies

USER homie-dashboard

# ADD overlay-common /overlay
# ADD overlay-${ARG_ARCH} /overlay

VOLUME ["/homie-dashboard"]

EXPOSE 35589

CMD ["node", "./node_modules/homie-dashboard/src/bin/cli.js", "start", "--ip", "0.0.0.0", "--port", "35589", "--dataDir", "/homie-dashboard"]
