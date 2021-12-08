FROM alpine:3.15.0

# Installing Base Libraries
###############################################################################
RUN apk add --no-cache --update npm

# Copy source code & install dependencies
###############################################################################
COPY ./app /root/src/
WORKDIR /root/src
RUN npm install

# Env variables
###############################################################################
# this can be parameterized
ENV SERVER_PORT=8000
EXPOSE $SERVER_PORT

# RUN node app.js
ENTRYPOINT ["node", "app.js"]
