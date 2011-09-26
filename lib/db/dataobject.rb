require IncludePath::PATH + 'lib/db/db_accessor'

class DataObject
    class DataObject::JoinElement
        def initialize()
            @table = nil
            @base_column = ""
            @join_column = ""
            @type = ""
        end

        attr_accessor :table
        attr_accessor :base_column
        attr_accessor :join_column
        attr_accessor :type
    end

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
        @order_by_columns = []
        @join_tables = []
        @like_columns = []
    end

    def get_table_name()
    end

    def create_instance(data)
    end

    def get_column_length
        return @column_names.length
    end

    def order_by(column, order = "asc", table_name = "")
        if table_name.length > 0
            @order_by_columns.push(table_name + "." + column + " " + order)
        else
            @order_by_columns.push(get_table_name + "." + column + " " + order)
        end
    end

    def like(column, value)
      @like_columns.push(get_table_name + "." + column + " like \"" + value + "%\"")
    end

    def find(count = 0, start = 0)
        data = get_data
        @join_tables.each do |j|
            data.concat(j.table.get_data)
        end

        if (count > Const::INT_MAX || count < 0)
            count = 0
        else
            if (start > Const::INT_MAX - 1)
                start = Const::INT_MAX - 1
            elsif (start < 0)
                start = 0
            end
        end

        result = nil
        if data.length > 0
            result = @@db.query(get_select_query(count, start), data)
        else
            result = @@db.query(get_select_query(count, start))
        end

        ret_val = []
        result.data.each do |rd|
            if (@join_tables.length > 0)
                e = []
                e.push(create_instance(rd))
                rd.shift(get_column_length)
                @join_tables.each do |j|
                    e.push(j.table.create_instance(rd))
                    rd.shift(j.table.get_column_length)
                end
                ret_val.push(e)
            else
                ret_val.push(create_instance(rd))
            end
        end

        return ret_val
    end

    def get_count(count = 0, start = 0)
         data = get_data
        @join_tables.each do |j|
            data.concat(j.table.get_data)
        end

        if (count > Const::INT_MAX || count < 0)
            count = 0
        else
            if (start > Const::INT_MAX - 1)
                start = Const::INT_MAX - 1
            elsif (start < 0)
                start = 0
            end
        end

        result = nil
        if data.length > 0
            result = @@db.query(get_select_query(count, start, "count(*) as count"), data)
        else
            result = @@db.query(get_select_query(count, start, "count(*) as count"))
        end

        return result.data[0][0]
    end

    def left_join(da_obj, base_column, join_column)
        join = DataObject::JoinElement.new
        join.table = da_obj
        join.base_column = base_column
        join.join_column = join_column
        join.type = "left"
        @join_tables.push(join)
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

    def update(find_column)
        query = "update " + get_table_name + " set "
        data = []
        set = []
        where_data = nil
        @columns.each do |col|
            temp = self.instance_variable_get(col)
            if (@column_names[col] != find_column)
                if (temp)
                    set.push(@column_names[col] + " = ?")
                    data.push(temp)
                end
            else
                where_data = temp
            end
        end

        query += set.join(", ") + " where " + find_column + " = ?"
        data.push(where_data)
        @@db.query(query, data)
    end

    def update_column(update_columns)
        query = "update " + get_table_name + " set "
        data = []
        update_data = []
        set = []
        where = []
        @columns.each do |col|
            temp = self.instance_variable_get(col)
            if (temp)
                if (update_columns.index(@column_names[col]))
                    set.push(@column_names[col] + " = ?")
                    update_data.push(temp)
                else
                    where.push(@column_names[col] + " = ?")
                    data.push(temp)
                end
            end
        end

        query += set.join(", ") + " where " + where.join(" and ")
        @@db.query(query, update_data.concat(data))
    end

    def get_select_query(count, start, get_column = "*")
        query = "select " + get_column + " from " + get_table_name

        limit = "";
        if (count > 0)
            limit = " limit " + start.to_s + ", " + count.to_s
        end

        order = get_order_by;
        if (order.length > 0)
            order = " order by " + order
        end

        where = get_where

        join = ""
        if (@join_tables.length > 0)
            @join_tables.each do |j|
                table = j.table
                join += " " + j.type + " join " + table.get_table_name + " on (" + get_table_name + "." +
                        j.base_column + " = " + table.get_table_name + "." + j.join_column + ")"

                join_where = table.get_where
                if (where.length > 0 && join_where.length > 0)
                    where += " and "
                end
                where += join_where

                join_order = table.get_order_by
                if (order.length > 0 && join_order.length > 0)
                    order += ", "
                end
                order += join_order
            end
        end

        if where.length > 0
            return query + join +  " where " + where + order + limit
        else
            return query + join + order + limit
        end
    end

    def get_where()
        where = []
        name = get_table_name
        @columns.each do |col|
            temp = self.instance_variable_get(col)
            if temp != nil
                where.push(name + "." + @column_names[col] + " = ?")
            end
        end
        @like_columns.each do |l|
            where.push(l)
        end
        return where.join(" and ")
    end
    protected :get_where

    def get_order_by()
        return @order_by_columns.join(", ")
    end
    protected :get_order_by

    def get_data()
        data = []
        @columns.each do |col|
            temp = self.instance_variable_get(col)
            if temp != nil
                data.push(temp)
            end
        end
        return data
    end
    protected :get_data
end
