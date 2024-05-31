FROM node:lts

RUN npm install newrelic@latest

COPY index.js .

CMD ["node", "-r", "newrelic", "index.js"]
