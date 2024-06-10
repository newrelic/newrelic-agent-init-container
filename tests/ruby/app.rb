# frozen_string_literal: true

require 'sinatra'

set :bind, '0.0.0.0'
set :port, 4567

get '/' do
  return 'no new relic txn' unless NewRelic::Agent::Tracer.current_transaction

  'hello, world!'
end
