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
        user = Util.check_user(post["user_name"], post["password"])
        if user
          redirect_after_login(user, request, response)
          return
        else
          error = "ユーザーID、またはパスワードが違います"
        end
      end
    end

    willow_array = Util.get_willow(nil, Const::SHOW_WILLOW_COUNT)

    template = SimpleTemplate.new(IncludePath::TEMPLATE_PATH + "login.tpl")
    template.replace("error", error)
    template.replace("willow_title", "みんなの川柳")
    template.replace("willow", willow_array)
    template.replace("css", [{ "file" => "willow.css"}])
    template.replace("page_title", "ログイン")
    response.write(template.to_s)
  end

  def redirect_after_login(user, request, response)
    request.session_options[:id] = GenerateSessionID.generate
    request.session[Const::LOGIN_DATA] = { "user_name" => user.user_name, "screen_name" => user.screen_name, "id" => user.id }
    response.redirect("/home/")
  end
end

class DynamicLoader < Login
end
