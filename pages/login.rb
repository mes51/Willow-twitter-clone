require IncludePath::PATH + "lib/db/user.rb"
require IncludePath::PATH + "lib/db/willow.rb"
require IncludePath::PATH + "lib/gen_sid.rb"
require IncludePath::PATH + "lib/page_base.rb"

class Login < PageBase
    def execute(params, request, response, env)
        error = ""
        if (params[1] == Const::NEW_USER)
            newUser = request.session[Const::NEW_USER]
            request.session[Const::NEW_USER] = nil

            if (newUser != nil && Util.check_user(newUser["user_name"], newUser["password"]))
                redirect_after_login(newUser["user_name"], request, response)
                return
            end
        elsif (request.session[Const::LOGIN_DATA])
            response.redirect("/home/")
            return
        else
            post = request.POST
            if (post.length > 0)
                if (Util.check_user(post["user_name"], post["password"]))
                    redirect_after_login(post["user_name"], request, response)
                    return
                else
                    error = "ユーザーID、またはパスワードが違います"
                end
            end
        end

        user = User.new
        user.delete_flag = 0
        willow = Willow.new
        willow.delete_flag = 0
        willow.order_by("post_time", "desc")
        willow.left_join(user, "user_id", "id")

        willow_array = []
        willow.find(Const::SHOW_WILLOW_COUNT).each do |w|
            split = w[0].text.split("\n")
            willow_array.push({ "willow_line1" => split[0], "willow_line2" => split[1], "willow_line3" => split[2], "willow_user" => w[1].user_name, "willow_screen" => w[1].screen_name })
        end

        template = SimpleTemplate.new(IncludePath::TEMPLATE_PATH + "login.tpl")
        template.replace("error", error)
        template.replace("willow_title", "みんなの川柳")
        template.replace("willow", willow_array)
        template.replace("css", [{ "file" => "willow.css"}])
        response.write(template.to_s)
    end

    def redirect_after_login(id, request, response)
        user = User.new
        user.user_name = id
        user.delete_flag = 0
        user = user.find
        request.session_options[:id] = GenerateSessionID.generate
        request.session[Const::LOGIN_DATA] = { "user_name" => id, "screen_name" => user[0].screen_name, "id" => user[0].id }
        response.redirect("/home/")
    end
end

class DynamicLoader < Login
end
