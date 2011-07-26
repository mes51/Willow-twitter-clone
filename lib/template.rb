require 'cgi'

class SimpleTemplate
    def initialize(file)
        @marker = []
        @element = {}
        @array_include = {}
        if (file != nil && Find.find(file))
            fp = open(file)
            @base_text = fp.read
            fp.close

            marker_text = @base_text.scan(/\{#.*?#\}/)
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
                        when "hash_array" then
                            @base_text = @base_text.gsub("{#" + temp + "#}", "{#" + split[2] + "#}")
                            add_marker(split[2], "", SimpleTemplate.new(IncludePath::TEMPLATE_PATH + split[1]))
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
        result = SimpleTemplate.new(nil)
        result.set_base_text(@base_text.dup)
        result.set_marker(Marshal.load(Marshal.dump(@marker)))
        element = {}
        if (replace == true)
            element = Marshal.load(Marshal.dump(@element))
        else
            @marker.each do |m|
                element.store(m, "")
            end
        end
        result.set_element(element)
        return result
    end

    def replace(key, value, no_escape = false)
        if (@element[key])
            if (value.class.to_s == "String")
                unless (no_escape)
                    value = CGI.escapeHTML(value)
                end
                @element[key] = value
            else
                @element[key] = value
            end
        end
    end

    def set_base_text(value)
        @base_text = value
    end
    protected :set_base_text

    def set_element(value)
        @element = value
    end
    protected :set_element

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
    protected :set_marker

    def add_marker(key, value = "", array = nil)
        unless (@element[key])
            @marker.push(key)
            @element.store(key, value)
            if (array)
                @array_include.store(key, array)
            end
        end
    end
    private :add_marker

    def to_s
        result = @base_text.dup
        @element.each do |key, value|
            value_text = ""
            if (@array_include[key])
                if (value.class.to_s == "Array")
                    value.each do |v|
                        temp = @array_include[key].copy(false)
                        temp.get_marker_ref.each do |m|
                            temp.replace(m, v[m])
                        end
                        value_text += temp.to_s
                    end
                end
            else
                value_text = value.to_s
            end
            value_text.force_encoding("utf-8")
            result = result.gsub("{#" + key + "#}", value_text)
        end
        return result
    end
end
