gem 'captcha'
require 'captcha'

require IncludePath::PATH + "lib/db/user.rb"
require IncludePath::PATH + "lib/db/follow.rb"
require IncludePath::PATH + "lib/gen_sid.rb"
require IncludePath::PATH + "lib/page_base.rb"

class SignUp < PageBase
    def execute(params, request, response, env)
        post = request.POST
        error = ""
        if (post.length > 0 && post["digest"].length > 0 && post["captcha"].length > 0 && post["user_name"].length > 0 &&
            post["screen_name"].length > 0 && post["password"].length > 0 && post["password"] == post["password-verify"])
            unless (/[^0-9a-zA-Z]/ =~ post["user_name"] || /[[:cntrl:]]/ =~ post["screen_name"])
                if (CAPTCHA::Web.is_valid(post["captcha"], post["digest"]))
                    newUser = User.new
                    newUser.user_name = post["user_name"]
                    if (newUser.find.length <= 0)
                        newUser.screen_name = post["screen_name"]
                        newUser.password = post["password"]
                        newUser.delete_flag = 0
                        newUser.hash_password
                        newUser.insert
                        newUser = newUser.find[0]
                        follow = Follow.new
                        follow.user_id = newUser.id
                        follow.follow_user_id = newUser.id
                        follow.delete_flag = 0
                        follow.insert
                        request.session_options[:id] = GenerateSessionID.generate
                        request.session[Const::NEW_USER] = { "user_name" => post["user_name"], "password" => post["password"] }
                        response.redirect("/login/new/")
                        return
                    else
                        error = "指定されたIDはすでに登録されています"
                    end
                else
                    error = "認証に失敗しました"
                end
            else
                error = "ユーザーID、または表示名に使用不可能な文字が含まれています"
            end
        end

        response.header["Pragma"] = "no-cache"
        response.header["Cache-Control"] = "no-cache"
        response.header["Expires"] = "0"
        captcha = create_captcha
        template = SimpleTemplate.new(IncludePath::TEMPLATE_PATH + "signup.tpl")
        template.replace("css", [{ "file" => "setting.css" }])
        template.replace("page_title", "アカウント作成")
        template.replace("captcha_img", "/" + Const::CAPTCHA_DIR_NAME + "/" + captcha.file_name)
        template.replace("captcha_digest", captcha.digest)
        template.replace("error", error)
        response.write(template.to_s)
    end

    def create_captcha()
        c = CAPTCHA::Web.new
        c.font = "/usr/share/fonts/bitstream-vera/VeraSe.ttf"
        c.image_dir = IncludePath::PATH + "public/captcha"
        c.font_size = 24
        c.rotation = 30
        c.x_spacing = 6
        c.y_wiggle = 25
        c.clean_up_interval = 300
        c.clean
        c.image
        return c
    end

    def no_cache
        return true
    end
end

class DynamicLoader < SignUp
end
