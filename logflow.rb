require 'rubygems'
require 'bundler/setup'
Bundler.require

require_relative 'logbook_parser'

get '/' do
  logbook_file = ENV['LOGBOOK_CSV'] || 'data/logbook.csv'
  logbook = LogbookParser.new(logbook_file)

  metadata = {
    application: "logflow",
    version: "0.1",
    dateFormat: "dd-MMM-yyyy" # 2-Feb-2009
  }

  data = {
    metadata: metadata,
    flights: logbook.flight_data.map(&:attributes)
  }

  <<-HTML
    <a href="logten://addFlights/#{URI.escape(JSON.generate(data))}">Import flight data:</a>
    <pre>#{JSON.pretty_generate(data)}</pre>
  HTML
end
