require 'spec_helper.rb'

describe 'pgbouncer::default' do
  let (:chef_run) do
    runner = ChefSpec::ChefRunner.new(:step_into => [ 'pgbouncer_connection', 'directory', 'template' ])

    runner.converge 'pgbouncer::default'
    runner
  end
  
  it "should install pgbouncer" do
    chef_run.should install_package 'pgbouncer'
  end

  it "should setup the directories" do
    chef_run.should create_directory "/etc/pgbouncer"
    chef_run.should create_directory "/etc/pgbouncer/dbsockets"
    chef_run.should create_directory "/var/log/pgbouncer"
    chef_run.directory('/etc/pgbouncer').should be_owned_by('pgbouncer','pgbouncer')
    chef_run.directory('/etc/pgbouncer/dbsockets').should be_owned_by('pgbouncer','pgbouncer')
    chef_run.directory('/var/log/pgbouncer').should be_owned_by('pgbouncer','pgbouncer')
  end
end
