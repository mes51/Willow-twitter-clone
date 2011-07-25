require 'cgi'

class SimpleTemplate
    def initialize(file)
        if (file != nil && Find.find(file))
            fp = open(file)
            @base_text = fp.read
            fp.close

            marker_text = @base_text.scan(/\{#.*?#\}/)
            @marker = []
            @element = {}
            start = "{#".length
            trim_length = "}#".length + start
            marker_text.each do |text|
                temp = text[start, text.length - trim_length]
                split = temp.split(":")
                if (split.length > 1)
                    case split[0]
                        when "include" then
                            include_temp = SimpleTemplate.new(IncludePath::TEMPLATE_PATH + split[1])
                            @base_text = @base_text.gsub("{#" + temp + "#}", include_temp.base_text)
                            include_temp.get_marker_ref.each do |m|
                                add_marker(m)
                            end
                        else
                            add_marker(temp)
                    end
                else
                    add_marker(temp)
                end
            end
            @base_text.force_encoding("utf-8")
        end
    end

    attr_reader :base_text

    def copy(replace)
        result = SimpleTemplate.new
        result.base_text = @base_text.dup
        result.set_marker(Marshal.load(Marshal.dump(@marker)))
        if (replace == true)
            result.set_element(Marshal.load(Marshal.dump(@element)))
        end
        return result
    end

    def replace(key, value, no_escape = false)
        if (@element[key])
            unless (no_escape)
                value = CGI.escapeHTML(value)
            end
            @element[key] = value
        end
    end

    def set_element(value)
        @element = value
    end
    private :set_element

    def get_marker
        return Marshal.load(Marshal.dump(@marker))
    end

    def get_marker_ref
        return @marker
    end
    protected :get_marker_ref

    def set_marker(value)
        @marker = value
    end
    private :set_marker

    def add_marker(key, value = "")
        unless (@element[key])
            @marker.push(key)
            @element.store(key, value)
        end
    end
    private :add_marker

    def to_s
        result = @base_text.dup
        @element.each do |key, value|
            value_text = value.to_s
            value_text.force_encoding("utf-8")
            result = result.gsub("{#" + key + "#}", value_text)
        end
        return result
    end
end
