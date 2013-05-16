chef_repo = File.join(File.dirname(__FILE__), "..", "..", "..")
chef_server_url "http://127.0.0.1:8889"
node_name "pgbouncer-test"
client_key = File.join(File.dirname(__FILE__), "test.pem")
cookbook_path File.join(File.dirname(__FILE__), "..", "..")