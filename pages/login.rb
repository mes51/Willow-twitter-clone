require IncludePath::PATH + "lib/db/user.rb"
require IncludePath::PATH + "lib/gen_sid.rb"

class Login
    def execute(params, request, response, env)
        error = ""
        if (params[1] == Const::NEW_USER)
            newUser = request.session[Const::NEW_USER]
            request.session[Const::NEW_USER] = nil
            if (newUser != nil && check_user(newUser["user_name"], newUser["password"]))
                redirect_after_login(newUser["user_name"], request, response)
                return
            end
        elsif (request.session[Const::LOGIN_DATA])
            response.redirect("/home/")
            return
        else
            post = request.POST
            if (post.length > 0)
                if (check_user(post["user_name"], post["password"]))
                    redirect_after_login(post["user_name"], request, response)
                    return
                else
                    error = "ユーザーID、またはパスワードが違います"
                end
            end
        end

        template = SimpleTemplate.new(IncludePath::TEMPLATE_PATH + "login.tpl")
        template.replace("error", error)
        response.write(template.to_s)
    end

    def check_user(id, password)
        user = User.new
        user.user_name = id
        user.password = password
        user.delete_flag = 0
        user.hash_password
        return user.find.length > 0
    end

    def redirect_after_login(id, request, response)
        user = User.new
        user.user_name = id
        user.delete_flag = 0
        user = user.find
        request.session_options[:id] = GenerateSessionID.generate
        request.session[Const::LOGIN_DATA] = { "user_name" => id, "screen_name" => user[0].screen_name }
        response.redirect("/home/")
    end
end

class DynamicLoader < Login
    def initialize()
        @login_only = false
    end

    attr_reader :login_only
end
