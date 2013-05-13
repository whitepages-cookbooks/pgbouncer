require 'spec_helper.rb'

describe 'pgbouncer::example' do
  let (:chef_run) do
    runner = ChefSpec::ChefRunner.new(:step_into => [ 'pgbouncer_connection' ])

    runner.converge 'pgbouncer::example'
    runner
  end
  
  it "should install pgbouncer" do
    chef_run.should install_package 'pgbouncer'
  end

  describe "pgbouncer::example should setup the directories" do
    [
     '/etc/pgbouncer',
     '/etc/pgbouncer/db_sockets',
     '/var/log/pgbouncer',
    ].each do |dir|
      subject { chef_run.directory(dir) }
      it { should_not be_nil }
      it { should be_created }
      it { should be_owned_by('pgbouncer','pgbouncer') }
    end
  end

  describe "pgbouncer::example should generate the correct pgbouncer configuration entries" do
    subject { chef_run }
    [
     '/etc/pgbouncer/userlist-database_example_com_ro.txt',
     '/etc/pgbouncer/pgbouncer-database_example_com_ro.ini',
     '/etc/init/pgbouncer-database_example_com_ro.conf',
     '/etc/logrotate.d/pgbouncer-database_example_com_ro'
    ].each do |file|
      it { should create_file file }
    end
  end

  it "should start the service" do
    chef_run.should start_service 'pgbouncer-database_example_com_ro'
  end
end
