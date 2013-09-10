# load bundled gems and std lib stuff
require 'rubygems'
require 'csv'
require 'bundler/setup'
Bundler.require

# load our models and schemas
require './logbook'
Dir[File.join(File.dirname(__FILE__), 'schema', '*.rb')].each { |file| require file }

get '/?:logbook_file?' do |logbook_file|
  logbook_file ||= 'data/logbook.csv'
  logbook = Logbook.new(logbook_file)

  data = {
    flights: logbook.flight_data,
    metadata: {
      application: "logflow",
      version: "0.1"
    }.merge(logbook.metadata)
  }

  <<-HTML
    <a href="logten://addFlights/#{URI.escape(JSON.generate(data))}">Import flight data:</a>
    <pre>#{JSON.pretty_generate(data)}</pre>
  HTML
end
