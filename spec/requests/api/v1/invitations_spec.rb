require 'rails_helper'

RSpec.describe "Api::V1::Invitations", type: :request do
  describe "POST /api/v1/invite" do
    let(:valid_file) do
      fixture_path = Rails.root.join('spec', 'fixtures', 'customers.txt')
      Rack::Test::UploadedFile.new(fixture_path)
    end

    let(:invalid_file) do
      fixture_path = Rails.root.join('spec', 'fixtures', 'invalid_customers.txt')
      Rack::Test::UploadedFile.new(fixture_path)
    end

    before do
      fixtures_dir = Rails.root.join('spec', 'fixtures')
      FileUtils.mkdir_p(fixtures_dir)
      
      File.open(fixtures_dir.join('customers.txt'), 'w') do |f|
        f.puts '{"latitude": "19.0760", "user_id": 1, "name": "Alice", "longitude": "72.8777"}' # Within 100km
        f.puts '{"latitude": "28.7041", "user_id": 2, "name": "Bob", "longitude": "77.1025"}'   # Far away
      end

      File.open(fixtures_dir.join('invalid_customers.txt'), 'w') do |f|
        f.puts 'this is not json'
      end
    end

    context "with a valid file" do
      it "returns a success response with the correct customers" do
        post "/api/v1/invite", params: { customers_file: valid_file }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(1)
        expect(json_response.first['user_id']).to eq(1)
        expect(json_response.first['name']).to eq('Alice')
      end
    end

    context "without a file" do
      it "returns a bad request error" do
        post "/api/v1/invite"
        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to include("File not provided")
      end
    end

    context "with a file containing invalid data" do
       it "returns a success response but processes only valid lines" do
        post "/api/v1/invite", params: { customers_file: invalid_file }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to be_empty
      end
    end
  end
end
