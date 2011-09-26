require 'securerandom'

require IncludePath::PATH + "lib/page_base.rb"
require IncludePath::PATH + "lib/db/user.rb"
require IncludePath::PATH + "lib/db/follow.rb"

class Following < PageBase
  def execute(params, request, response, env)
    if params.length < 2
      response.write("ユーザーIDが指定されていません")
      return
    elsif params[1] == request.session[Const::LOGIN_DATA]["user_name"]
      response.write("自分をフォロー、またはフォロー解除することは出来ません")
      return
    end

    user = User.new
    user.user_name = params[1]
    user.delete_flag = 0
    user = user.find
    if user.length < 1
      response.write("指定されたユーザーは存在しません")
      return
    end
 
    user = user[0]
    post = request.POST
    if (post.length > 0)
      if post["token"] == request.session[Const::POST_TOKEN]
        follow = get_follow(request.session[Const::LOGIN_DATA]["id"], user.id, false)
        if post["action"] == "follow"
          if follow.length > 0
            follow[0][0].delete_flag = 0
            follow[0][0].update_column(["delete_flag"])
          else
            follow = Follow.new
            follow.user_id = request.session[Const::LOGIN_DATA]["id"]
            follow.follow_user_id = user.id
            follow.delete_flag = 0
            follow.insert
          end
          response.redirect("/home/")
        elsif post["action"] == "unfollow" && follow.length > 0 && follow[0][0].delete_flag == 0
            follow[0][0].delete_flag = 1
            response.write(follow[0][0].update_column(["delete_flag"]))
            response.redirect("/home/")
        end
      end
    end

    follow = get_follow(request.session[Const::LOGIN_DATA]["id"], user.id, true)

    template = SimpleTemplate.new(IncludePath::TEMPLATE_PATH + "follow.tpl")
    template.replace("css", [{ "file" => "setting.css" }])
    template.replace("screen_name", user.screen_name)
    template.replace("user_name", user.user_name)
    template.replace("page_title", user.user_name + "のフォロー・フォロー解除")
    if follow.length > 0
      template.replace("now_following", "います")
      template.replace("action_message", "フォロー解除")
      template.replace("action", "unfollow")
    else
      template.replace("now_following", "いません")
      template.replace("action_message", "フォロー")
      template.replace("action", "follow")
    end
    response.write(template.to_s)
  end

  def get_follow(user_id, follow_user_id, check_delete)
    follow = Follow.new
    follow.user_id = user_id
    follow.follow_user_id = follow_user_id
    if check_delete
      follow.delete_flag = 0
    end
    follow.left_join(User.new, "follow_user_id", "id")
    follow.find
  end

  def login_only
    true
  end

  def no_cache
    true
  end

  def clear_token
    false
  end

  def generate_token
    SecureRandom.hex(Const::TOKEN_LENGTH)
  end

end

class DynamicLoader < Following
end
