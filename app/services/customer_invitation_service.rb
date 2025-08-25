# app/services/customer_invitation_service.rb

# Processes the customer file to find people to invite.
class CustomerInvitationService
  MAX_DIST = 100.0

  def initialize(file)
    @file = file
  end

  def call
    invitees = @file.read.each_line.filter_map do |line|
      customer = parse(line)
      next unless customer && customer['latitude'] && customer['longitude'] && customer['user_id']

      dist = distance_from_office(customer)

      { user_id: customer['user_id'], name: customer['name'] } if dist <= MAX_DIST
    end

    invitees.sort_by { |c| c[:user_id] }
  end

  private

  def parse(line)
    JSON.parse(line)
  rescue JSON::ParserError
    Rails.logger.warn "Skipping invalid JSON: #{line.strip}"
    nil
  end

  def distance_from_office(customer)
    lat = customer['latitude'].to_f
    lon = customer['longitude'].to_f
    
    DistanceCalculator.calculate(DistanceCalculator::OFFICE_LAT, DistanceCalculator::OFFICE_LON, lat, lon)
  end
end
