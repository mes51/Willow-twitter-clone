class UserInfo < PageBase
  def execute(params, request, response, env)
    if (params.length <= 1)
      response.write("ユーザーIDがありません")
      return
    end

    user = User.new
    user.user_name = params[1]
    user.delete_flag = 0
    user = user.find
    if (user.length <= 0)
      response.write("指定されたユーザーは存在しません")
      return
    end

    user = user[0]

    user_name = user.user_name
    screen_name = user.screen_name
    user_name.force_encoding("utf-8")
    screen_name.force_encoding("utf-8")

    limit_start = 0
    if (params.length > 2)
      limit_start = params[2].to_i
    end

    willow_array = Util.get_willow(user.id, Const::SHOW_WILLOW_COUNT, 1, limit_start, user_name, screen_name)

    exists_old = willow_array.length > Const::SHOW_WILLOW_COUNT
    if (exists_old)
      willow_array.pop
    end

    template = SimpleTemplate.new(IncludePath::TEMPLATE_PATH + "user.tpl")
    template.replace("css", [{ "file" => "willow.css"}])
    template.replace("js", [{ "js_file" => "search.js" }])
    template.replace("user_name", user_name)
    template.replace("page_title", screen_name + "(@" + user_name + ")の川柳")
    template.replace("willow_title", user.screen_name + "の川柳")
    template.replace("willow", willow_array)
    if (exists_old)
      template.replace("old_post", "common/old_post.tpl")
      template.replace("old_post_link", "/user/" + user_name + "/" + Const::SHOW_WILLOW_COUNT.to_s + "/")
    else
      template.replace("old_post", "common/no_old_post.tpl")
    end
    response.write(template.to_s)
  end
end

class DynamicLoader < UserInfo
end
