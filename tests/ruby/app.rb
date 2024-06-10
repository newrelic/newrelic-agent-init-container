# frozen_string_literal: true

require 'sinatra'

get '/' do
  status = NewRelic::Agent::Tracer.current_transaction ? 'active' : 'inactive'

  "Hello, World! New Relic is #{status}"
end
