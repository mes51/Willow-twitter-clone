require 'kconv'
require 'find'

require 'rack/request'
require 'rack/response'

require '../config/include_path.rb'
require '../lib/const.rb'
require '../lib/template.rb'
require '../lib/util.rb'

class WillowApp
    def call(env)
        req = Rack::Request.new(env)
        res = Rack::Response.new
        p = req.params["args"].split("/")
        routing(p[0], p, req, res, env)

        res.finish
    end

    def routing(page, params, request, response, env)
        response['Content-Type'] = 'text/html;charset=utf-8'
        require_file = nil

        Find.find("../pages") { |name|
            if File::basename(name, ".*") == page
                require_file = name
                break
            end
        }

        if (require_file == nil)
            if (page != nil && page != "")
                response.status = 404
                return
            else
                require_file = "../pages/login.rb"
            end
        end

        require require_file
        loader = DynamicLoader.new
        
        if (loader.login_only)
            if (!Util.check_login(request))
                response.redirect("/login/")
                return
            end
        end

        if (loader.no_cache)
            response.header["Pragma"] = "no-cache"
            response.header["Cache-Control"] = "no-cache"
            response.header["Expires"] = "0"
        end

        if (loader.clear_token && request.session_options[:id] && request.session_options[:id].length > 0)
            request.session[Const::POST_TOKEN] = ""
        end
        
        loader.execute(params, request, response, env)
    end
end
