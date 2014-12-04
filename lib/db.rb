class DB
  attr_reader :db

  def initialize
    @db = PG.connect(host: 'localhost', dbname:'atx_data')
  end

  def get_airline_count
    sql = %q[
      SELECT COUNT(DISTINCT carrier) FROM flight_arrivals;
    ]
    result = db.exec(sql)
    result.entries.first['count'].to_i
  end

  def get_all_airlines
    sql = "SELECT DISTINCT carrier FROM flight_arrivals;"
    result = db.exec(sql)
    result.entries
  end

  def get_carrier_delayed_arrivals
    sql = %q[
      SELECT
        carrier,
        COUNT(carrier)
      FROM flight_arrivals
      WHERE arrival_delay > 0
      GROUP BY carrier
      ORDER BY count DESC;
    ]

    result = db.exec(sql)
    result.entries
  end


  def get_city_delayed_departures
    sql = %q[
      SELECT
        origin_city,
        COUNT(origin_city)
        FROM flight_arrivals
        WHERE departure_delay > 0
        GROUP BY origin_city
        ORDER BY count DESC;
    ]

    result = db.exec(sql)
    result.entries
  end

  def get_city_delayed_arrivals
    sql = %q[
      SELECT
        origin_city,
        COUNT(origin_city)
        FROM flight_arrivals
        WHERE arrival_delay > 0
        GROUP BY origin_city
        ORDER BY count DESC;
    ]

    result = db.exec(sql)
    result.entries
  end

  def get_carrier_average_lateness
    sql = %q[
      SELECT
        carrier,
        AVG(departure_delay) as departure,
        AVG(arrival_delay) as arrival
      FROM flight_arrivals
      GROUP BY carrier
      ORDER BY carrier ASC;
    ]

    result = db.exec(sql)
    result.entries
  end

  def get_overall_lateness
    sql = %[
      SELECT
        AVG(departure_delay) as departure,
        AVG(arrival_delay) as arrival
      FROM flight_arrivals;
    ]

    result = db.exec(sql)
    result.entries.first
  end

  def build_carrier_profile carrier
    sql = %Q[
      SELECT
        avg(departure_delay) as avg_dep_delay,
        avg(arrival_delay) as avg_arr_delay,
        count(departure_delay) as cnt_dep_delay,
        count(arrival_delay) as cnt_arr_delay
      FROM flight_arrivals
      WHERE carrier = '#{carrier}'
    ]
    result = db.exec(sql)
    result.entries.first
  end
end
