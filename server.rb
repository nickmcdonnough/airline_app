require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require './lib/db'

helpers do
  def get_db_connection
    DB.new
  end
end

get '/' do
  db = get_db_connection
  @carrier_list = db.get_all_airlines
  erb :index
end

post '/impossible' do
  carrier = params[:carrier]
  redirect to '/carriers/' + carrier
end

get '/carriers/:carrier' do
  db = get_db_connection
  @info = db.build_carrier_profile params[:carrier]
  erb :carrier
end


get '/carriers' do
  db = get_db_connection

  @carrier_count = db.get_airline_count
  @carriers = db.get_all_airlines
  erb :carriers
end

get '/carrier-delayed-arrivals' do
  db = get_db_connection
  delays = db.get_carrier_delayed_arrivals

  @most_delayed = delays.first
  @least_delayed = delays.last
  erb :carrier_delayed_arrivals
end

get '/city-delayed-departures' do
  db = get_db_connection
  delays = db.get_city_delayed_departures

  @most_delayed = delays.first
  @least_delayed = delays.last
  erb :city_most_delayed_deps
end

get '/city-delayed-arrivals' do
  db = get_db_connection
  delays = db.get_city_delayed_arrivals

  @most_delayed = delays.first
  @least_delayed = delays.last
  erb :city_most_delayed_arrivals
end

get '/carrier-average-lateness' do
  db = get_db_connection
  @averages = db.get_carrier_average_lateness
  erb :carrier_average_lateness
end

get '/overall-lateness' do
  db = get_db_connection
  @overall = db.get_overall_lateness
  erb :overall_lateness
end
