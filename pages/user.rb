require IncludePath::PATH + "lib/page_base.rb"
require IncludePath::PATH + "lib/db/willow.rb"
require IncludePath::PATH + "lib/db/user.rb"

class UserInfo < PageBase
    def execute(params, request, response, env)
        if (params.length <= 1)
            response.write("ユーザーIDがありません")
            return
        end

        user = User.new
        user.user_name = params[1]
        user.delete_flag = 0
        user = user.find
        if (user.length <= 0)
            response.write("指定されたユーザーは存在しません")
            return
        end

        user = user[0]
        willow = Willow.new
        willow.user_id = user.id
        willow.delete_flag = 0
        willow.order_by("post_time", "desc")

        screen_name = user.screen_name
        screen_name.force_encoding("utf-8")

        willow_array = []
        willow.find(Const::SHOW_WILLOW_COUNT).each do |w|
            split = w.text.split("\n")
            willow_array.push({ "willow_line1" => split[0], "willow_line2" => split[1], "willow_line3" => split[2], "willow_user" => user.user_name, "willow_screen" => screen_name })
        end

        template = SimpleTemplate.new(IncludePath::TEMPLATE_PATH + "user.tpl")
        template.replace("css", [{ "file" => "willow.css"}])
        template.replace("willow_title", user.screen_name + "の川柳")
        template.replace("willow", willow_array)
        response.write(template.to_s)
    end
end

class DynamicLoader < UserInfo
end
