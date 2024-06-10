FROM ruby:latest

WORKDIR /app

COPY Gemfile ./

RUN bundle install

COPY . .

EXPOSE 9292

#Ensure executable permissions
RUN chmod +x start.sh

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "--port", "9292"]
# CMD ["gunicorn", "main:app", "-b", "0.0.0.0:8000", "--workers=1"]
# CMD ["./start.sh"]
