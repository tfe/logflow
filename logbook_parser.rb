# load libraries
require 'csv'

# load our app and schemas
require_relative 'logflow'
Dir[File.join(File.dirname(__FILE__), 'schema', '*.rb')].each {|file| require file }

class LogbookParser

  attr_accessor :data_file

  def initialize(data_file)
    @data_file = data_file
  end

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
    h.keys.each { |k| h[k.downcase.gsub(' ', '_')] = h.delete(k) }
  end

  # potential computed values:
  # flight_dualReceivedNight
  # flight_touchAndGoes
  # flight_from
  # flight_to
  # flight_route

  def schema
    # could be other things in the future, or passed in, or auto-selected
    Schema::Zululog
  end

  def raw_data
    CSV.open(data_file)
  end

  def flight_data
    schema.conform(raw_data)
  end

  private

  def computed_fields(flight)
    {}.tap do |h|
      route_parts = flight['route'].split
      h[:flight_from]  = route_parts.first
      h[:flight_to]    = route_parts.last
      h[:flight_route] = nil
      h[:flight_touchAndGoes]
    end
  end
end
