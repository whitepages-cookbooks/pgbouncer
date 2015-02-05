# Encoding: utf-8
def create_pgbouncer_instance(db_name)
  ChefSpec::Matchers::ResourceMatcher.new(:pgbouncer_connection, :setup, db_name)
end
