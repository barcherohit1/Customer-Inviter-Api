require 'rails_helper'

RSpec.describe CustomerInvitationService do
  def run_service_with(lines)
    file = StringIO.new(lines.join("\n"))
    CustomerInvitationService.new(file).call
  end

  describe '#call' do
    let(:nearby_customer) { { latitude: '19.07', user_id: 12, name: 'Nearby Person', longitude: '72.87' }.to_json }
    let(:faraway_customer) { { latitude: '28.70', user_id: 2, name: 'Faraway Person', longitude: '77.10' }.to_json }
    let(:another_nearby_customer) { { latitude: '18.92', user_id: 5, name: 'Another Person', longitude: '72.83' }.to_json }
    let(:invalid_line) { 'this is not json' }

    it 'only includes customers within 100km' do
      result = run_service_with([nearby_customer, faraway_customer])
      
      expect(result.length).to eq(1)
      expect(result.first[:user_id]).to eq(12)
    end

    it 'sorts the results by user_id' do
      result = run_service_with([nearby_customer, another_nearby_customer])
      
      expect(result.map { |c| c[:user_id] }).to eq([5, 12])
    end

    it 'skips invalid lines without crashing' do
      result = run_service_with([nearby_customer, invalid_line, another_nearby_customer])
      
      expect(result.length).to eq(2)
      expect(result.map { |c| c[:user_id] }).to eq([5, 12])
    end

    it 'returns an empty array when no customers are in range' do
      result = run_service_with([faraway_customer])
      
      expect(result).to be_empty
    end
  end
end
