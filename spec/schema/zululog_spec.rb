require './logflow'

describe Schema::Zululog do
  let(:flight1) { [%Q{2-Feb-2009,430u,AGC,Four fundamentals,Chuck Testa,1,,,,1,,,,,,,,,,1.0,,1.0,TRUE,}.split(',')] }
  let(:flight2) { [%Q{27-Apr-2013,5204A,SQL O22,Day trip to Columbia campground,,2,,,,2,,,,,,,,2.1,,,2.1,2.1,TRUE,}.split(',')] }
  let(:flight3) { [%Q{11-Jun-2011,5204a,KSQL KRHV KSQL,"All maneuvers, all landings, 15 knot crosswind",Chuck Testa,1,,3,,1,,,,,,,,,,1.4,,1.4,TRUE,}.split(',')] }
  let(:flight4) { [%Q{6-Jun-2011,5204a,KSQL KPAO KHWD KSQL,"Short and soft field takeoffs and landings, traffic pattern",Chuck Testa,2,,3,,2,,,,,,,,,,1.3,,1.3,TRUE,}.split(',')] }

  describe "route" do

    after do
      data = Schema::Zululog.conform(@raw_data)
      expect(data.first.attributes).to include(@expected_output)
    end

    it "should work with one airport" do
      @raw_data = flight1
      @expected_output = {
        flight_from:  'AGC',
        flight_to:    'AGC',
        flight_route: nil
      }
    end

    it "should work with two airports" do
      @raw_data = flight2
      @expected_output = {
        flight_from:  'SQL',
        flight_to:    'O22',
        flight_route: nil
      }
    end

    it "should work with three airports" do
      @raw_data = flight3
      @expected_output = {
        flight_from:  'KSQL',
        flight_to:    'KSQL',
        flight_route: 'KRHV'
      }
    end

    it "should work with four airports" do
      @raw_data = flight4
      @expected_output = {
        flight_from:  'KSQL',
        flight_to:    'KSQL',
        flight_route: 'KPAO KHWD'
      }
    end
  end

  describe "touch and goes" do
    
  end


end
