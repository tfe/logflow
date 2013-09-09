require 'rubygems'
require 'bundler/setup'
Bundler.require

data_file = ENV['LOGBOOK_CSV'] || 'data/logbook.csv'

ZULULOG_LOGTEN_KEY_MAPPING = {
  # "Flight Date/Time"      => "flight_flightDate",
  # "Aircraft ID"           => "flight_selectedAircraftID",
  # # "Route"                 => "",
  # "Flight Remarks"        => "flight_remarks",
  # "Instructor Name"       => "",
  # "Day Takeoffs"          => "flight_dayTakeoffs",
  # "Night Takeoffs"        => "flight_nightTakeoffs",
  # # "Day Touch/Go"          => "",
  # # "Night Touch/Go"        => "",
  # "Day Full Stop"         => "flight_dayLandings",
  # "Night Full Stop"       => "flight_nightLandings",
  # "Instrument Approaches" => "flight_totalApproaches",
  # "Night Flight Time"     => "flight_night",
  # "Simulated Instrument"  => "flight_simulatedInstrument",
  # "Flight Simulator"      => "flight_simulator",
  # # "Helicopter"            => "",
  # # "Tailwheel"             => "",
  # "X/Ctry"                => "flight_crossCountry",
  # "Solo"                  => "flight_solo",
  # "Dual Received"         => "flight_dualReceived",
  # "Total PIC Time"        => "flight_pic",
  # "Total Flight Time"     => "flight_totalTime",
  # # "VFR"                   => ""
  "Flight Date/Time"      => "flight_flightDate",
  "Aircraft ID"           => "flight_selectedAircraftID",
  # "Route"                 => "",
  "Flight Remarks"        => "flight_remarks",
  "Instructor Name"       => "flight_selectedCrewInstructor",
  "Day Takeoffs"          => "flight_dayTakeoffs",
  "Night Takeoffs"        => "flight_nightTakeoffs",
  # "Day Touch/Go"          => "",
  # "Night Touch/Go"        => "",
  "Day Full Stop"         => "flight_dayLandings",
  "Night Full Stop"       => "flight_nightLandings",
  "Instrument Approaches" => "flight_totalApproaches",
  "Night Flight Time"     => "flight_night",
  "Simulated Instrument"  => "flight_simulatedInstrument",
  "Flight Simulator"      => "flight_simulator",
  # "Helicopter"            => "",
  # "Tailwheel"             => "",
  "X/Ctry"                => "flight_crossCountry",
  "Solo"                  => "flight_solo",
  "Dual Received"         => "flight_dualReceived",
  "Total PIC Time"        => "flight_pic",
  "Total Flight Time"     => "flight_totalTime",
  # "VFR"                   => ""
}.tap do |h|
  h.keys.each { |k| h[k.to_sym] = h.delete(k) }
end

# potential computed values:
# flight_dualReceivedNight
# flight_touchAndGoes
# flight_from
# flight_to
# flight_route

puts "Processing logbook at #{data_file}..."

total_rows = SmarterCSV.process(data_file, strings_as_keys: true, key_mapping: ZULULOG_LOGTEN_KEY_MAPPING) do |row|
  # print '.'

  debugger
  a=1
end

puts ""
puts "Finished #{total_rows} rows"
