require IncludePath::PATH + '/lib/db/dataobject.rb'
require 'digest/sha2' 

class User < DataObject
  def initialize()
    @id = nil
    @user_name = nil
    @screen_name = nil
    @password = nil
    @delete_flag = nil
    super
  end

  attr_accessor :id
  attr_accessor :user_name
  attr_accessor :screen_name
  attr_accessor :password
  attr_accessor :delete_flag

  def get_table_name
    return "user"
  end

  def hash_password
    @password = Digest::SHA512.hexdigest(@password)
  end

  def create_instance(data)
    result = User.new
    result.id = data[0]
    result.user_name = data[1]
    result.screen_name = data[2]
    result.password = data[3]
    result.delete_flag = data[4]
    return result
  end
end
