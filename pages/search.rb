require IncludePath::PATH + "lib/page_base.rb"
require IncludePath::PATH + "lib/db/willow.rb"
require IncludePath::PATH + "lib/db/user.rb"

class Search < PageBase
  def execute(params, request, response, env)
    if params.length <= 1
      response.write("検索文字列がありません")
      return
    elsif /[^0-9a-zA-Z]/ =~ params[1]
      response.write("検索文字列に使用できない文字列が含まれています")
      return
    end

    user = User.new
    user.like("user_name", params[1])
    user.delete_flag = 0
    
    result_array = []
    user.find.each do |u|
      result_array.push({ "user_name" => u.user_name, "screen_name" => u.screen_name })
    end

    template = SimpleTemplate.new(IncludePath::TEMPLATE_PATH + "search.tpl")
    template.replace("css", [{ "file" => "search.css"}])
    template.replace("js", [{ "js_file" => "search.js" }])
    template.replace("search_user", params[1])
    template.replace("page_title", params[1] + "の検索結果")
    template.replace("search_title", params[1] + "から始まるユーザーの検索結果")
    template.replace("search_result", result_array)
    response.write(template.to_s)
  end

  def login_only
    true
  end
end

class DynamicLoader < Search
end
