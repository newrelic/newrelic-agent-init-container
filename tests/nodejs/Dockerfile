ARG RUNTIME_VERSION=20
FROM node:${RUNTIME_VERSION}

WORKDIR /app

COPY index.js .
RUN npm install newrelic@latest --verbose

CMD ["node", "-r", "newrelic", "index.js"]
