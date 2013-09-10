require 'active_support/core_ext/object/blank'

module Schema
  class Zululog
    extend Conformist

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
