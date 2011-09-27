require IncludePath::PATH + "lib/page_base.rb"
require IncludePath::PATH + "lib/db/willow.rb"

class Home < PageBase
  def execute(params, request, response, env)
    screen_name = request.session[Const::LOGIN_DATA]["screen_name"]
    user_name = request.session[Const::LOGIN_DATA]["user_name"]
    screen_name.force_encoding("utf-8")

    limit_start = 0
    if (params.length > 1)
      limit_start = params[1].to_i
    end

    willow_array = Util.get_friend_willow(request.session[Const::LOGIN_DATA]["id"], Const::SHOW_WILLOW_COUNT, 1, limit_start)

    exists_old = willow_array.length > Const::SHOW_WILLOW_COUNT
    if (exists_old)
      willow_array.pop
    end

    willow = Willow.new
    willow.user_id = request.session[Const::LOGIN_DATA]["id"]

    template = SimpleTemplate.new(IncludePath::TEMPLATE_PATH + "home.tpl")
    template.replace("css", [{ "file" => "willow.css" }])
    template.replace("js", [{ "js_file" => "search.js" }])
    template.replace("page_title", "ホーム")
    template.replace("willow_title", screen_name + "の川柳")
    template.replace("willow", willow_array)
    if (exists_old)
      template.replace("old_post", "common/old_post.tpl")
      template.replace("old_post_link", "/home/" + Const::SHOW_WILLOW_COUNT.to_s + "/")
    else
      template.replace("old_post", "common/no_old_post.tpl")
    end
    response.write(template.to_s)
  end

  def login_only
    return true
  end
end

class DynamicLoader < Home
end
