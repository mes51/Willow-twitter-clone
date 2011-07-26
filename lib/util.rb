module Util
    def self.check_login(request)
        return request.session[Const::LOGIN_DATA] != nil
    end
end
