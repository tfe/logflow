require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'logbook_parser'

get '/' do

  logbook = LogbookParser.new(ENV['LOGBOOK_CSV'] || 'data/logbook.csv')

  metadata = {
    application: "logflow",
    version: "0.1",
    dateFormat: "dd-MMM-yyyy" # 2-Feb-2009
  }

  data = {
    metadata: metadata,
    flights: logbook.flight_data
  }

  %Q{<a href="logten://addFlights/#{URI.escape(JSON.generate(data))}">Import sample flight</a>}
end
