require 'rails_helper'
require_relative '../../lib/distance_calculator'

RSpec.describe DistanceCalculator do
  let(:office_lat) { DistanceCalculator::OFFICE_LAT }
  let(:office_lon) { DistanceCalculator::OFFICE_LON }

  describe '.calculate' do
    it 'is 0 for the same coordinates' do
      dist = DistanceCalculator.calculate(office_lat, office_lon, office_lat, office_lon)
      expect(dist).to eq(0)
    end

    it 'calculates a known distance to a nearby city (Pune)' do
      pune_lat = 18.5204
      pune_lon = 73.8567
      dist = DistanceCalculator.calculate(office_lat, office_lon, pune_lat, pune_lon)
      expect(dist).to be_within(1.0).of(130.5)
    end

    it 'calculates a known distance to a faraway city (Delhi)' do
      delhi_lat = 28.7041
      delhi_lon = 77.1025
      dist = DistanceCalculator.calculate(office_lat, office_lon, delhi_lat, delhi_lon)
      expect(dist).to be_within(1.0).of(1159.7)
    end
  end
end
