require_relative '../logbook_parser'

describe LogbookParser, "#flight_data" do
  let(:logbook) { LogbookParser.new('data/logbook.csv') }
  subject(:flight_data) { logbook.flight_data }

  it "should return an array of flight hashes" do
    expect(flight_data).to be_an Array
  end
end
