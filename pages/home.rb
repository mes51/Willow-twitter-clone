require IncludePath::PATH + "lib/page_base.rb"
require IncludePath::PATH + "lib/db/willow.rb"

class Home < PageBase
    def execute(params, request, response, env)
        screen_name = request.session[Const::LOGIN_DATA]["screen_name"]
        user_name = request.session[Const::LOGIN_DATA]["user_name"]
        screen_name.force_encoding("utf-8")

        willow = Willow.new
        willow.user_id = request.session[Const::LOGIN_DATA]["id"]
        willow.delete_flag = 0
        willow.order_by("post_time", "desc")

        willow_array = []
        willow.find(Const::SHOW_WILLOW_COUNT).each do |w|
            split = w.text.split("\n")
            willow_array.push({ "willow_line1" => split[0], "willow_line2" => split[1], "willow_line3" => split[2], "willow_user" => user_name, "willow_screen" => screen_name })
        end

        template = SimpleTemplate.new(IncludePath::TEMPLATE_PATH + "home.tpl")
        template.replace("css", [{ "file" => "willow.css"}])
        template.replace("willow_title", screen_name + "の川柳")
        template.replace("willow", willow_array)
        response.write(template.to_s)
    end

    def login_only
        return true
    end
end

class DynamicLoader < Home
end
