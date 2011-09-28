class DBResult
  def initialize(data)
    @data = data
  end

  attr_reader :data

  def row_length
    @data.length
  end

  def to_s
    text = "<table border=1>\n"

    @data.each do |row|
      text += "<tr>"
      row.each do |r|
        text += "<td>" + r.to_s + "</td>"
      end
      text += "</tr>\n"
    end

    text += '</table>'
  end
end
