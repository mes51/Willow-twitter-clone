require 'securerandom'

module GenerateSessionID
    def self.generate
        length = Rack::Session::Abstract::ID::DEFAULT_OPTIONS[:sidbits] / 4
        return SecureRandom.hex(length)
    end
end
