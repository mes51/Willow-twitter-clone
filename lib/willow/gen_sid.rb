module GenerateSessionID
  def self.generate
    length = Rack::Session::Abstract::ID::DEFAULT_OPTIONS[:sidbits] / 4
    SecureRandom.hex(length)
  end
end
