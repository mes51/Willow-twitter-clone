class Post < PageBase
  def execute(params, request, response, env)
    if (params.length > 1 && params[1] == Const::POST_WILLOW)
      post = request.POST
      if (post["token"] == request.session[Const::POST_TOKEN])
        willow = Willow.new
        willow.user_id = request.session[Const::LOGIN_DATA]["id"]
        willow.text = post["willow"].delete("\r")
        willow.delete_flag = 0
        willow.insert

        response.redirect("/home/")
        return
      end
    end

    token = generate_token
    request.session[Const::POST_TOKEN] = token
    template = SimpleTemplate.new(IncludePath::TEMPLATE_PATH + "post.tpl")
    template.replace("page_title", "投稿")
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

class DynamicLoader < Post
end
