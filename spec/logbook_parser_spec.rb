require_relative '../logbook_parser'

describe LogbookParser do
  let(:logbook) { LogbookParser.new('data/logbook.csv') }

  describe "#flight_data" do
    subject(:flight_data) { logbook.flight_data }

    it "should return an array of flight hashes" do
      expect(flight_data).to respond_to(:to_a)
    end
  end

end
