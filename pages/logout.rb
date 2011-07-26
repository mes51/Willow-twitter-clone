require IncludePath::PATH + "lib/page_base.rb"

class Logout < PageBase
    def execute(params, request, response, env)
        request.session[Const::LOGIN_DATA] = ""
        request.session_options[:id] = ""
        #env["rack.session.options"][:id] = ""
        response.redirect("/login/")
    end
end

class DynamicLoader < Logout
end
