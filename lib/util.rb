require IncludePath::PATH + "lib/db/user.rb"

module Util
    def self.check_login(request)
        return request.session[Const::LOGIN_DATA] != nil
    end

    def self.check_user(id, password)
        user = User.new
        user.user_name = id
        user.password = password
        user.delete_flag = 0
        user.hash_password
        return user.find.length > 0
    end
end
