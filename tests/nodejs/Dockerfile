ARG RUNTIME_VERSION=22
FROM node:${RUNTIME_VERSION}

WORKDIR /app

COPY index.js .
RUN npm install newrelic@latest --verbose

CMD ["node", "-r", "newrelic", "index.js"]
