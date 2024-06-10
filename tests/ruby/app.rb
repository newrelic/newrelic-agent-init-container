# frozen_string_literal: true

require 'sinatra'

set :bind, '0.0.0.0'
set :port, 9292

get '/' do
  'hello, world!'
end
