class Post
    def execute(params, request, response, env)
        if (params.length > 1 && params[1] == Const::POST_WILLOW)
            response.redsirect("/home/")
            return
        end

        template = SimpleTemplate.new(IncludePath::TEMPLATE_PATH + "post.tpl")
        response.write(template.to_s)
    end
end

class DynamicLoader < Post
    def initialize()
        @login_only = true
    end

    attr_reader :login_only
end
