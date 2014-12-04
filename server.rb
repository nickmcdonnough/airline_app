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
  result1 = db.exec(sql1)
  result2 = db.exec(sql2)
  @carrier_count = result1.entries.first['count']
  @carriers = result2.entries
  erb :carriers
end

get '/delayed-arrivals' do
  sql = %q[
    SELECT
      carrier,
      COUNT(carrier)
    FROM flight_arrivals
    WHERE arrival_delay > 0
    GROUP BY carrier
    ORDER BY count DESC;
  ]

  db = get_db_connection
  result = db.exec(sql)
  @most_delayed = result.entries.first
  @least_delayed = result.entries.last
  erb :most_delayed
end
