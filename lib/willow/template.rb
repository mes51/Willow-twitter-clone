class SimpleTemplate
  class SimpleTemplate::TemplateElement
    attr_accessor :marker
    attr_accessor :type
    attr_accessor :value
    attr_accessor :include_template

    TYPE_INCLUDE = "include"
    TYPE_ARRAY_HASH = "hash_array"
    TYPE_NORMAL = "normal"
    TYPE_LOAD = "load"
    TYPE_NONE = "none"

    def initialize
      @type = TYPE_NONE
    end

    def copy(replace)
      result = SimpleTemplate::TemplateElement.new
      result.marker = @marker.dup
      result.type = @type.dup
      if (@include_template)
        result.include_template = @include_template.copy(replace)
      end
      if (replace == true)
        result.value = Marshal.load(Marshal.dump(@value))
      end
      result
    end
  end

  def initialize(file)
    @marker = []
    @element = {}
    @other_element = {}
    @include_element = []
    include_file = []
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
        e = SimpleTemplate::TemplateElement.new
        if (split.length > 1)
          case split[0]
          when "include" then
            file = IncludePath::TEMPLATE_PATH + split[1]
            unless (include_file.index(include_file))
              e.type = SimpleTemplate::TemplateElement::TYPE_INCLUDE
              e.marker = temp
              e.include_template = SimpleTemplate.new(file)
              include_file.push(file)
            end
          when "hash_array" then
            e.type = SimpleTemplate::TemplateElement::TYPE_ARRAY_HASH
            e.marker = split[2]
            e.include_template = SimpleTemplate.new(IncludePath::TEMPLATE_PATH + split[1])
            @base_text = @base_text.gsub("{#" + temp + "#}", "{#" + split[2] + "#}")
          when "load" then
            e.type = SimpleTemplate::TemplateElement::TYPE_LOAD
            e.marker = split[1]
            @base_text = @base_text.gsub("{#" + temp + "#}", "{#" + split[1] + "#}")
          else
            e.type = SimpleTemplate::TemplateElement::TYPE_NORMAL
            e.marker = temp
          end
        else
          e.type = SimpleTemplate::TemplateElement::TYPE_NORMAL
          e.marker = temp
        end
        add(e)
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
    include_element = []
    other_element = {}
    if (replace == true)
      element = Marshal.load(Marshal.dump(@element))
      include_element = Marshal.load(Marshal.dump(@include_element))
      other_element = Marshal.load(Marshal.dump(@other_element))
    else
      @element.each do |k, v|
        element.store(k, v.copy(replace))
      end
      @include_element.each do |v|
        include_element.puch(v.copy(replace))
      end
    end
    result.set_element(element)
    result.set_include_element(include_element)
    result.set_other_element(other_element)
    result
  end

  def replace(key, value, no_escape = false)
    if (value.class.to_s == "String" && !no_escape)
      value = CGI.escapeHTML(value)
    end
    if (@element[key])
      @element[key].value = value
    else
      @other_element.store(key, value)
    end
    @include_element.each do |e|
      e.include_template.replace(key, value, no_escape)
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

  def set_include_element(value)
    @include_element = value
  end
  protected :set_include_element

  def set_other_element(value)
    @other_element = value
  end
  protected :set_other_element

  def get_marker
    result = Marshal.load(Marshal.dump(@marker))
    @include_element.each do |i|
      i.include_template.get_marker.each do |m|
        unless (result.index(m))
          result.push(m)
        end
      end
    end
    result
  end

  def get_marker_ref
    @marker
  end
  protected :get_marker_ref

  def set_marker(value)
    @marker = value
  end
  protected :set_marker

  def add(e)
    unless (@element[e.marker])
      if (e.type != SimpleTemplate::TemplateElement::TYPE_INCLUDE)
        @marker.push(e.marker)
        @element.store(e.marker, e)
      else
        @include_element.push(e)
      end
    end
  end
  private :add

  def to_s
    result = @base_text.dup
    @element.each do |k, v|
      value_text = ""
      case v.type
      when SimpleTemplate::TemplateElement::TYPE_ARRAY_HASH then
        if (v.value.class.to_s == "Array")
          v.value.each do |vv|
            temp = v.include_template.copy(false)
            temp.get_marker_ref.each do |m|
              temp.replace(m, vv[m])
            end
            value_text += temp.to_s
          end
        end
      when SimpleTemplate::TemplateElement::TYPE_NORMAL then
        value_text = v.value.to_s
      when SimpleTemplate::TemplateElement::TYPE_LOAD then
        if (v.value)
          template = SimpleTemplate.new(IncludePath::TEMPLATE_PATH + v.value)
          @element.each do |tk, tv|
            template.replace(tk, tv)
          end
          @other_element.each do |tk, tv|
            template.replace(tk, tv)
          end
          value_text = template.to_s
        end
      end
      value_text.force_encoding("utf-8")
      result = result.gsub("{#" + k + "#}", value_text)
    end
    @include_element.each do |v|
      result = result.gsub("{#" + v.marker + "#}", v.include_template.to_s)
    end
    result
  end
end
