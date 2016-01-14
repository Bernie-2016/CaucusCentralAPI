#
# We want to get 64-bit primary keys.
#
ca = ActiveRecord::ConnectionAdapters
if ca.const_defined? :PostgreSQLAdapter
  ca::PostgreSQLAdapter::NATIVE_DATABASE_TYPES[:primary_key] = 'bigint primary key'
end

if ca.const_defined? :AbstractMysqlAdapter
  ca::AbstractMysqlAdapter::NATIVE_DATABASE_TYPES[:primary_key] =
        'BIGINT UNSIGNED NULL PRIMARY KEY'
end

module ActiveRecord
  class Base
    include Concerns::RandomId
  end
end
