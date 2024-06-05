FROM ruby:latest

WORKDIR /app

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

COPY Gemfile ./

RUN bundle install

COPY . .

EXPOSE 4567

#Ensure executable permissions
RUN chmod +x start.sh

CMD ["./start.sh"]
