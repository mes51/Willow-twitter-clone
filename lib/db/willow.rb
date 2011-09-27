require IncludePath::PATH + '/lib/db/dataobject.rb'

class Willow < DataObject
  def initialize()
    @id = nil
    @user_id = nil
    @text = nil
    @post_time = nil
    @delete_flag = nil
    super
  end

  attr_accessor :id
  attr_accessor :user_id
  attr_accessor :text
  attr_accessor :post_time
  attr_accessor :delete_flag

  def get_table_name
    return "willow"
  end

  def create_instance(data)
    result = Willow.new
    result.id = data[0]
    result.user_id = data[1]
    result.text = data[2]
    result.post_time = data[3]
    result.delete_flag = data[4]
    return result
  end
end
