require './logflow'

# ZULULOG_LOGTEN_KEY_MAPPING = {
#   "Flight Date/Time"      => "flight_flightDate",
#   "Aircraft ID"           => "flight_selectedAircraftID",
#   # "Route"                 => "",
#   "Flight Remarks"        => "flight_remarks",
#   "Instructor Name"       => "flight_selectedCrewInstructor",
#   "Day Takeoffs"          => "flight_dayTakeoffs",
#   "Night Takeoffs"        => "flight_nightTakeoffs",
#   # "Day Touch/Go"          => "",
#   # "Night Touch/Go"        => "",
#   "Day Full Stop"         => "flight_dayLandings",
#   "Night Full Stop"       => "flight_nightLandings",
#   "Instrument Approaches" => "flight_totalApproaches",
#   "Night Flight Time"     => "flight_night",
#   "Simulated Instrument"  => "flight_simulatedInstrument",
#   "Flight Simulator"      => "flight_simulator",
#   # "Helicopter"            => "",
#   # "Tailwheel"             => "",
#   "X/Ctry"                => "flight_crossCountry",
#   "Solo"                  => "flight_solo",
#   "Dual Received"         => "flight_dualReceived",
#   "Total PIC Time"        => "flight_pic",
#   "Total Flight Time"     => "flight_totalTime",
#   # "VFR"                   => ""
# }

# potential computed values:
# flight_dualReceivedNight
# flight_touchAndGoes
# flight_from
# flight_to
# flight_route

describe Schema::Zululog do
  let(:flight0) { CSV.parse(%Q{,,,,,,,,,,,,,,,,,,,,,,,}) }
  let(:flight1) { CSV.parse(%Q{2-Feb-2009,430u,AGC,Four fundamentals,Chuck Testa,1,,,,1,,,,,,,,,,1.0,,1.0,TRUE,}) }
  let(:flight2) { CSV.parse(%Q{27-Apr-2013,5204A,SQL O22,Day trip to Columbia's campground,,1,1,,,1,1,,,,,,,2.1,,,2.1,2.1,TRUE,}) }
  let(:flight3) { CSV.parse(%Q{11-Jun-2011,5204a,KSQL KRHV KSQL,"All maneuvers, all landings, 15 knot crosswind",Chuck Testa,1,,3,,1,,,,,,,,,,1.4,,1.4,TRUE,}) }
  let(:flight4) { CSV.parse(%Q{6-Jun-2011,5204a,KSQL KPAO KHWD KSQL,"Short and soft field takeoffs/landings, traffic pattern",Chuck Testa,2,,3,1,2,,,,,,,,,,1.3,,1.3,TRUE,}) }
  let(:flight5) { CSV.parse(%Q{4-Jan-2011,4739j,AGC FKL AGC,XC to FKL and night landings,Chuck Testa,1,1,,3,,2,,1.1,,,,,1.9,,1.9,,1.9,TRUE,}) }
  let(:flight6) { CSV.parse(%Q{8-Sep-2012,51458,,"G1000 systems/failures, GPS/VOR tracking, autopilot, KSQL GPS Runway 30Y approach",Chuck Testa,,,,,,,,,1.4,1.4,,,,,1.4,,,TRUE,}) }
  let(:flight7) { CSV.parse(%Q{31-Mar-2009,596cs,AGC,1st Solo,,1,,5,,1,,,,,,,,,0.5,0.4,0.5,0.9,TRUE,}) }

  after do
    data = Schema::Zululog.conform(@raw_data)
    expect(data.first.attributes).to include(@expected_output)
  end

  it "should not fail on rows with no data" do
    @raw_data = flight0
    @expected_output = {}
  end

  it "should generate a flight key" do
    @raw_data = flight1
    @expected_output = { flight_key: Digest::MD5.hexdigest(flight1.join(',')) }
  end

  it "should transcribe date" do
    @raw_data = flight1
    @expected_output = { flight_flightDate: '2-Feb-2009' }
  end

  it "should transcribe aircraft ID" do
    @raw_data = flight1
    @expected_output = { flight_selectedAircraftID: '430u' }
  end

  it "should transcribe instructor name" do
    @raw_data = flight1
    @expected_output = { flight_selectedCrewInstructor: 'Chuck Testa' }
  end

  it "should transcribe day takeoffs" do
    @raw_data = flight4
    @expected_output = { flight_dayTakeoffs: "2" }
  end

  it "should transcribe night takeoffs" do
    @raw_data = flight2
    @expected_output = { flight_nightTakeoffs: "1" }
  end

  it "should transcribe day landings" do
    @raw_data = flight4
    @expected_output = { flight_dayLandings: "2" }
  end

  it "should transcribe night landings" do
    @raw_data = flight2
    @expected_output = { flight_nightLandings: "1" }
  end

  it "should transcribe instrument approaches" do
    @raw_data = flight1
    @expected_output = { flight_totalApproaches: nil }
  end

  it "should transcribe night flight time" do
    @raw_data = flight5
    @expected_output = { flight_night: "1.1" }
  end

  it "should transcribe simulated instrument flight time" do
    @raw_data = flight6
    @expected_output = { flight_simulatedInstrument: "1.4" }
  end

  it "should transcribe simulator flight time" do
    @raw_data = flight6
    @expected_output = { flight_simulator: "1.4" }
  end

  it "should transcribe XC flight time" do
    @raw_data = flight5
    @expected_output = { flight_crossCountry: "1.9" }
  end

  it "should transcribe solo flight time" do
    @raw_data = flight7
    @expected_output = { flight_solo: "0.5" }
  end

  it "should transcribe dual flight time" do
    @raw_data = flight5
    @expected_output = { flight_dualReceived: "1.9" }
  end

  it "should transcribe PIC flight time" do
    @raw_data = flight7
    @expected_output = { flight_pic: "0.5" }
  end

  it "should transcribe total flight time" do
    @raw_data = flight5
    @expected_output = { flight_totalTime: "1.9" }
  end

  describe "remarks" do
    it "should transcribe remarks with slashes and commas" do
      @raw_data = flight4
      @expected_output = { flight_remarks: "Short and soft field takeoffs/landings, traffic pattern" }
    end

    it "should transcribe remarks with single quotes" do
      @raw_data = flight2
      @expected_output = { flight_remarks: "Day trip to Columbia's campground" }
    end
  end

  describe "route" do
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
    it "should work when only day T&G has a value" do
      @raw_data = flight3
      @expected_output = { flight_touchAndGoes: 3 }
    end

    it "should sum day and night T&G values" do
      @raw_data = flight4
      @expected_output = { flight_touchAndGoes: 4 }
    end
  end
end
