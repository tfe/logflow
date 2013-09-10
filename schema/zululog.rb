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

    column :flight_from, 2 do |route|
      route.split.first
    end

    column :flight_to, 2 do |route|
      route.split.last
    end

    column :flight_route, 2 do |route|
      route.split.slice(1..-2).join(' ').presence
    end
  end
end
