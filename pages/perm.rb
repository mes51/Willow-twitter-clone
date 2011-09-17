require IncludePath::PATH + "lib/db/user.rb"
require IncludePath::PATH + "lib/db/willow.rb"
require IncludePath::PATH + "lib/gen_sid.rb"
require IncludePath::PATH + "lib/page_base.rb"

class Permanent < PageBase
  def execute(params, request, response, env)
    if params.length < 2
      response.write("川柳のIDが指定されていません")
      return
    end

    willow = Util.get_willow_by_id(params[1])
    unless willow
      response.write("指定されたIDの川柳はありません")
      return
    end

    template = SimpleTemplate.new(IncludePath::TEMPLATE_PATH + "perm.tpl")
    template.replace("css", [{ "file" => "perm.css"}])
    template.replace("page_title", willow["willow_screen"] + "(@" + willow["willow_user"] + ")の川柳")
    template.replace("willow_title", willow["willow_screen"] + "の川柳")
    template.replace("willow", [willow])
    response.write(template.to_s)
  end
end

class DynamicLoader < Permanent
end
