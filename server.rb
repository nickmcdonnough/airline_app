require 'sinatra'
require 'sinatra/reloader'
require 'pg'

helpers do
  def get_db_connection
    PG.connect(host: 'localhost', dbname:'atx_data')
  end
end

get '/' do
  erb :index
end

# how many different airlines are represented?
get '/carriers' do
  sql1 = %q[
    SELECT COUNT(DISTINCT carrier) FROM flight_arrivals;
  ]
  sql2 = "SELECT DISTINCT carrier FROM flight_arrivals;"

  db = get_db_connection
  p db
  result1 = db.exec(sql1)
  result2 = db.exec(sql2)
  p result1.entries
  p result2.entries
  @carrier_count = result1.entries.first['count']
  @carriers = result2.entries
  erb :carriers
end
