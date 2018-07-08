# require 'schema_monkey'
#
# module PostgresEnums
#   module ActiveRecord
#     module Base
#       module ClassMethods
#         def enum(definitions)
#           super(definitions.map do |name, values|
#             values = values.map do |value|
#               [value.to_sym, value.to_s]
#             end.to_h unless values.is_a? Hash
#
#             [name, values]
#           end.to_h)
#         end
#       end
#     end
#
#     module ConnectionAdapters
#       module PostgreSQLAdapter
#
#         def native_database_types
#           types = ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES
#           types.merge(enum: { name: "enum" })
#         end
#
#         def column_spec(column, types)
#           spec = prepare_column_options(column, types)
#           (spec.keys - [:name, :type, :enum_type]).each{ |k| spec[k].insert(0, "#{k}: ")}
#           spec
#         end
#
#         def prepare_column_options(column, types)
#           spec = super
#           spec[:type]      = column.type == :enum ? 'column' : spec[:type]
#           spec[:enum_type] = column.sql_type.inspect if column.type == :enum
#           spec[:array]     = 'true' if column.respond_to?(:array) && column.array
#           spec[:default]   = "\"#{column.default_function}\"" if column.default_function
#           spec
#         end
#
#         def migration_keys
#           super.insert(1, :enum_type) << :array
#         end
#
#         def enum_types
#           query = <<-SQL
#             SELECT t.typname AS enum_name,
#                   string_agg(e.enumlabel, ' ') AS enum_value
#             FROM pg_type t
#             JOIN pg_enum e ON t.oid = e.enumtypid
#             JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace
#             WHERE n.nspname = 'public'
#             GROUP BY enum_name
#           SQL
#           res =  exec_query(query, 'SCHEMA').cast_values
#           res.each do |line|
#             line[1] = line[1].split(' ')
#           end
#           res
#         end
#       end
#     end
#   end
# end
#
#
# SchemaMonkey.register PostgresEnums
