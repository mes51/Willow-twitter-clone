require IncludePath::PATH + "lib/page_base.rb"
require IncludePath::PATH + "lib/db/willow.rb"

class Home < PageBase
    def execute(params, request, response, env)
        willow = Willow.new
        willow.user_id = request.session[Const::LOGIN_DATA]["id"]
        willow.delete_flag = 0

        willow_array = []
        willow.find.each do |w|
            split = w.text.split("\n")
            willow_array.push({ "willow_line1" => split[0], "willow_line2" => split[1], "willow_line3" => split[2] })
        end

        template = SimpleTemplate.new(IncludePath::TEMPLATE_PATH + "home.tpl")
        template.replace("user_name", request.session[Const::LOGIN_DATA]["user_name"])
        template.replace("screen_name", request.session[Const::LOGIN_DATA]["screen_name"])
        template.replace("willow", willow_array)
        response.write(template.to_s)
    end

    def login_only
        return true
    end
end

class DynamicLoader < Home
end
