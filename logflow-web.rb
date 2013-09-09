require 'rubygems'
require 'bundler/setup'
Bundler.require

get '/' do

  metadata = {
    application: "logflow",
    version: "0.1",
    dateFormat: "dd-MMM-yyyy" # 2-Feb-2009
  }

  flight_data = {
    metadata: metadata,
    flights: [
      {
        flight_flightDate: "2-Feb-2009",
        flight_to: "KSQL",
        flight_from: "KWVI",
        flight_pic: "1:30",
        flight_remarks: "Testing app's apostrophe ability/slashes."
      }
    ]
  }

  %Q{<a href="logten://addFlights/#{URI.escape(JSON.generate(flight_data))}">Import sample flight</a>}
end
