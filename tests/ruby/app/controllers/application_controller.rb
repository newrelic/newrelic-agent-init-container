class ApplicationController < ActionController::API
  def hello
    render plain: "Hello, World!"
  end
end
