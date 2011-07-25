class Logout
    def execute(params, request, response, env)
        request.session[Const::LOGIN_DATA] = ""
        request.session_options[:id] = ""
        #env["rack.session.options"][:id] = ""
        response.redirect("/login/")
    end
end

class DynamicLoader < Logout
    def initialize()
        @login_only = false
    end

    attr_reader :login_only
end
