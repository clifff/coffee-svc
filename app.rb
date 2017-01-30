require 'sinatra'
require 'json'

get '/' do
  content_type :json
  [
    { id: 1, type: 'Latte', size: '12oz', roaster: 'stumptown' }
  ].to_json
end
