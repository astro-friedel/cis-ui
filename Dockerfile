FROM node:alpine3.10

# Install depedencies
RUN apk add --update vim git python3
RUN yarn -v foo >/dev/null 2>&1 || npm install -g yarn;

RUN yarn global add grunt http-server

# Copy in source
ENV SRCDIR /usr/share/nginx/html
WORKDIR $SRCDIR
COPY package.json .

# XXX: npm postinstall won't run, execute manually
RUN yarn && \
    cd node_modules/the-graph && \
    yarn && \
    grunt build && \
    rm -rf node-modules/ && \
    cd ../..

COPY . .
RUN grunt
EXPOSE 80
ENTRYPOINT [ "http-server" ]
CMD [ "-p", "80", "-d", "False" ]
