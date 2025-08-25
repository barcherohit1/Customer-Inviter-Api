# lib/distance_calculator.rb

module DistanceCalculator
  R_KM = 6371.0 # Earth's radius in kilometers
  OFFICE_LAT = 19.0590317
  OFFICE_LON = 72.7553452

  def self.calculate(lat1, lon1, lat2, lon2)
    # Convert everything to radians first
    lat1_r, lon1_r = to_rad(lat1), to_rad(lon1)
    lat2_r, lon2_r = to_rad(lat2), to_rad(lon2)

    d_lon = lon2_r - lon1_r

    # Spherical law of cosines
    cos_angle = Math.sin(lat1_r) * Math.sin(lat2_r) +
                Math.cos(lat1_r) * Math.cos(lat2_r) * Math.cos(d_lon)

    # Clamp the value to the valid range for acos [-1, 1] to prevent float errors
    cos_angle = [1.0, [-1.0, cos_angle].max].min
    
    angle = Math.acos(cos_angle)

    R_KM * angle
  end

  private

  # convert degrees to radians
  def self.to_rad(degrees)
    (degrees || 0) * Math::PI / 180
  end
end
