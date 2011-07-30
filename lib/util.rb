require IncludePath::PATH + "lib/db/user.rb"
require IncludePath::PATH + "lib/db/willow.rb"

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

    def self.get_willow(user_id, count, margin = 0, limit_start = 0, user_name = "", screen_name = "")
        willow = Willow.new
        willow.user_id = user_id
        willow.delete_flag = 0       
        willow.order_by("post_time", "desc")

        if (user_name.length > 0)
            willow_array = []
            willow.find(count + margin, limit_start).each do |w|
                split = w.text.split("\n")
                willow_array.push({ "willow_line1" => split[0], "willow_line2" => split[1], "willow_line3" => split[2], "willow_user" => user_name, "willow_screen" => screen_name })
            end
        else
            user = User.new
            user.delete_flag = 0
            willow.left_join(user, "user_id", "id")

            willow_array = []
            willow.find(count + margin, limit_start).each do |w|
                split = w[0].text.split("\n")
                willow_array.push({ "willow_line1" => split[0], "willow_line2" => split[1], "willow_line3" => split[2], "willow_user" => w[1].user_name, "willow_screen" => w[1].screen_name })
            end
        end

        if (willow_array.length <= 0 && limit_start > count)
            return self.get_willow(user_id, count, margin, willow.get_count - count, user_name, screen_name)
        else
            return willow_array
        end
    end
end
