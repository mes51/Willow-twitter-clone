class Home
    def execute(params, request, response, env)
        template = SimpleTemplate.new(IncludePath::TEMPLATE_PATH + "home.tpl")
        template.replace("user_name", request.session[Const::LOGIN_DATA]["user_name"])
        template.replace("screen_name", request.session[Const::LOGIN_DATA]["screen_name"])
        response.write(template.to_s)
    end
end

class DynamicLoader < Home
    def initialize()
        @login_only = true
    end

    attr_reader :login_only
end
