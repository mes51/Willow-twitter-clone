require IncludePath::PATH + 'config/db_config'

class DBAccessor
  def initialize()
    @db = Mysql::new(DBConfig::DB_SERVER, DBConfig::DB_USER, DBConfig::DB_PASSWORD)
    @db.query("set character set utf8")
    @db.query("use " + DBConfig::DB_NAME)
  end

  def query(query, data = nil)
    res = nil

    if data
      res = @db.prepare(query).execute(*data)

    else
      res = @db.query(query)
    end

    row = []

    if res.num_rows > 0
      res.each do |c|
        row.push(c)
      end
    end

    DBResult.new(row)
  end
end
