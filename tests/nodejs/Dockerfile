FROM node:lts

WORKDIR /app

COPY index.js .
RUN npm install newrelic@latest --verbose

CMD ["node", "-r", "newrelic", "index.js"]
