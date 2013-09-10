require './logflow'

class Logbook

  attr_accessor :data_file

  def initialize(data_file)
    @data_file = data_file
  end

  def schema
    # could be other things in the future, or passed in, or auto-selected
    Schema::Zululog
  end

  def raw_data
    CSV.open(data_file)
  end

  def flight_data
    schema.conform(raw_data, schema.options)
  end

  def metadata
    schema.metadata
  end

end
