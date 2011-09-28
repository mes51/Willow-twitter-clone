class Setting < PageBase
  def execute(params, request, response, env)
    if (params.length > 1 && params[1] == Const::CHANGE_SETTING)
      post = request.POST
      if (post["token"] == request.session[Const::POST_TOKEN])
        user = User.new
        user.id = request.session[Const::LOGIN_DATA]["id"]
        if (post["new_password"].length > 0 && post["new_password"] == post["new_password_verify"])
          if (Util.check_user(request.session[Const::LOGIN_DATA]["user_name"], post["old_password"]))
            user.password = post["new_password"]
            user.hash_password
          else
            response.redirect("/setting/")
            return
          end
        end
        user.screen_name = post["screen_name"]
        user.update("id")
        request.session[Const::LOGIN_DATA]["screen_name"] = user.screen_name
        response.redirect("/home/")
        return
      end
    end

    token = generate_token
    request.session[Const::POST_TOKEN] = token
    template = SimpleTemplate.new(IncludePath::TEMPLATE_PATH + "setting.tpl")
    template.replace("css", [{ "file" => "setting.css"}])
    template.replace("page_title", "設定")
    template.replace("screen_name", request.session[Const::LOGIN_DATA]["screen_name"])
    template.replace("token", token)
    response.write(template.to_s)
  end

  def login_only?
    true
  end

  def no_cache?
    true
  end

  def clear_token?
    false
  end

  def generate_token
    SecureRandom.hex(Const::TOKEN_LENGTH)
  end
end

class DynamicLoader < Setting
end

