require IncludePath::PATH + 'lib/db/db_accessor'

class DataObject
    @@db = DBAccessor.new

    def initialize()
        temp = self.instance_variables
        @columns = temp
        
        names = []
        at = "@".length
        temp.each do |col|
            names.push(col[at, col.length - at])
        end
        pair = temp.zip(names)
        @column_names = Hash[*pair.flatten]
    end

    def get_table_name()
    end

    def create_instance(data)
    end

    def find()
        data = []
        @columns.each do |col|
            temp = self.instance_variable_get(col)
            if temp != nil
                data.push(temp)
            end
        end

        result = nil
        if data.length > 0
            result = @@db.query(get_select_query, data)
        else
            result = @@db.query(get_select_query)
        end

        ret_val = []
        result.data.each do |rd|
            ret_val.push(create_instance(rd))
        end

        return ret_val
    end

    def insert()
        query = "insert into " + get_table_name + " values("
        count = 0
        data = []
        @columns.each do |col|
            data.push(self.instance_variable_get(col))
            count += 1
        end

        values = "?, " * count
        query += values[0, values.length - ", ".length] + ")"

        @@db.query(query, data)
    end

    def get_select_query()
        query = "select * from " + get_table_name
        where = []
        @columns.each do |col|
            temp = self.instance_variable_get(col)
            if temp != nil
                where.push(@column_names[col] + " = ?")
            end
        end

        if where.length > 0
            return query + " where " + where.join(" and ")
        else
            return query
        end
    end
end
