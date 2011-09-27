Require IncludePath::PATH + "lib/db/user.rb"
require IncludePath::PATH + "lib/db/willow.rb"
require IncludePath::PATH + "lib/db/follow.rb"
require IncludePath::PATH + "lib/convert_jp_num.rb"

module Util
  def self.check_login(request)
    return request.session[Const::LOGIN_DATA] != nil
  end

  def self.check_user(id, password)
    user = User.new
    user.user_name = id
    user.password = password
    user.delete_flag = 0
    user.hash_password
    result = user.find
    if result.length > 0
      result[0]
    else
      nil
    end
  end

  def self.get_willow(user_id, count, margin = 0, limit_start = 0, user_name = "", screen_name = "")
    willow = Willow.new
    willow.user_id = user_id
    willow.delete_flag = 0       
    willow.order_by("post_time", "desc")

    if (user_name.length > 0)
      willow_array = []
      willow.find(count + margin, limit_start).each do |w|
        willow_array.push(self.get_template_array(w, user_name, screen_name))
      end
    else
      user = User.new
      user.delete_flag = 0
      willow.left_join(user, "user_id", "id")

      willow_array = []
      willow.find(count + margin, limit_start).each do |w|
        willow_array.push(self.get_template_array(w[0], w[1].user_name, w[1].screen_name))
      end
    end

    if (willow_array.length <= 0 && limit_start > count)
      return self.get_willow(user_id, count, margin, willow.get_count - count, user_name, screen_name)
    else
      return willow_array
    end
  end

  def self.get_willow_by_id(willow_id)
    willow = Willow.new
    willow.id = willow_id
    willow.delete_flag = 0
    willow.left_join(User.new, "user_id", "id")
    willow_array = willow.find

    if willow_array.length > 0
      self.get_template_array(willow_array[0][0], willow_array[0][1].user_name, willow_array[0][1].screen_name)
    else
      nil
    end
  end

  def self.get_friend_willow(user_id, count, margin = 0, limit_start = 0)
    follow = Follow.new
    willow = Willow.new
    follow.user_id = user_id
    follow.delete_flag = 0
    follow.left_join(willow, "follow_user_id", "user_id")
    follow.left_join(User.new, "follow_user_id", "id")
    follow.order_by("post_time", "desc", willow.get_table_name)
    willow_array = []

    follow.find(count + margin, limit_start).each do |f|
      if (f[1].text)
        willow_array << get_template_array(f[1], f[2].user_name, f[2].screen_name)
      end
    end

    if (willow_array.length <= 0 && limit_start > count)
      self.get_friend_willow(user_id, count, margin, follow.get_count - count)
    else
      willow_array
    end
  end

  def self.get_template_array(w, user_name, screen_name)
    split = w.text.split("\n")
    time =  Convert.to_jp_num(w.post_time.year, false) + "年 " + Convert.to_jp_num(w.post_time.month, true) + "月 " +
      Convert.to_jp_num(w.post_time.day, true) + "日 " + Convert.to_jp_num(w.post_time.hour, false) + "時 " + Convert.to_jp_num(w.post_time.minute, false) + "分"

    { "willow_line1" => split[0], "willow_line2" => split[1], "willow_line3" => split[2],
      "willow_user" => user_name, "willow_screen" => screen_name, "willow_post_time" => time,
      "willow_perm" => w.id }
  end
end
