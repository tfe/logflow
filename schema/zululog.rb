require './logflow'

module Schema
  class Zululog
    extend Conformist

    def self.options
      { skip_first: true }
    end

    def self.metadata
      { dateFormat: "dd-MMM-yyyy" } # 2-Feb-2009
    end

    column :flight_key, 0..23 do |values|
      Digest::MD5.hexdigest(values.join(','))
    end

    column :flight_flightDate, 0
    column :flight_selectedAircraftID, 1
    column :flight_remarks, 3
    column :flight_selectedCrewInstructor, 4
    column :flight_dayTakeoffs, 5
    column :flight_nightTakeoffs, 6
    column :flight_dayLandings, 9
    column :flight_nightLandings, 10
    column :flight_totalApproaches, 11
    column :flight_night, 12
    column :flight_simulatedInstrument, 13
    column :flight_simulator, 14
    column :flight_crossCountry, 17
    column :flight_solo, 18
    column :flight_dualReceived, 19
    column :flight_pic, 20
    column :flight_totalTime, 21

    column :flight_from, 2 do |route|
      route && route.split.first
    end

    column :flight_to, 2 do |route|
      route && route.split.last
    end

    column :flight_route, 2 do |route|
      route && route.split.slice(1..-2).join(' ').presence
    end

    column :flight_touchAndGoes, 7, 8 do |values|
      values.map(&:to_i).sum
    end
  end
end
