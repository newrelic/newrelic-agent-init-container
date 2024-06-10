FROM ruby:latest

WORKDIR /app

COPY Gemfile ./

RUN bundle install

COPY . .

EXPOSE 9292

#Ensure executable permissions
RUN chmod +x start.sh

CMD ["./start.sh"]
