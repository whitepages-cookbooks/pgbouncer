require 'spec_helper.rb'

describe 'pgbouncer::example' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['pgbouncer_connection']).converge(described_recipe)
  end

  it "Setup a pgbouncer instance" do
    expect(chef_run).to create_pgbouncer_instance('database_example_com_ro')
  end

  it 'creates the group pgbouncer' do
    expect(chef_run).to create_group('pgbouncer')
  end

  it 'creates the user pgbouncer' do
    expect(chef_run).to create_user('pgbouncer')
  end

  it "should install pgbouncer" do
    expect(chef_run).to install_package('pgbouncer')
  end

  it 'enables the service pgbouncer' do
    service = chef_run.service('pgbouncer-database_example_com_ro')
    expect(service).to do_nothing
  end

  %w(
    /etc/pgbouncer
    /etc/pgbouncer/db_sockets
    /var/log/pgbouncer
    /var/run/pgbouncer
    /etc/pgbouncer/db_sockets/database_example_com_ro
  ).each do |dir|
    it "creates directory #{dir}" do
      expect(chef_run).to create_directory(dir).with(
        user:   'pgbouncer',
        group:  'pgbouncer'
      )
    end
  end

  %w(
    /etc/pgbouncer/userlist-database_example_com_ro.txt
    /etc/pgbouncer/pgbouncer-database_example_com_ro.ini
    /etc/init/pgbouncer-database_example_com_ro.conf
    /etc/logrotate.d/pgbouncer-database_example_com_ro
  ).each do |file|
    it "creates file #{file}" do
      expect(chef_run).to create_template(file).with(
        user:   'pgbouncer',
        group:  'pgbouncer',
        mode: 00644
      )
    end
  end

  it 'start pgbouncer instance' do
    expect(chef_run).to start_service('pgbouncer-database_example_com_ro-start')
  end
end
