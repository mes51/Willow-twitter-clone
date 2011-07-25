require IncludePath::PATH + '/lib/db/dataobject.rb'

class Follow < DataObject
    def initialize()
        @id = nil
        @user_id = nil
        @follow_user_id = nil
        @delete_flag = nil
    end

    attr_accessor :id
    attr_accessor :user_id
    attr_accessor :follow_user_id
    attr_accessor :delete_flag

    def get_table_name
        return "follow"
    end

    def create_instance(data)
        result = Follow.new
        result.id = data[0]
        result.user_id = data[1]
        result.follow_user_id = data[2]
        result.delete_flag = data[3]
        return result
    end
end
