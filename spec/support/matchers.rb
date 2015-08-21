# Encoding: utf-8
def create_pgbouncer_instance(instance_name)
  ChefSpec::Matchers::ResourceMatcher.new(:pgbouncer_instance, :setup, instance_name)
end
