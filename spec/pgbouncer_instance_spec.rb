require 'spec_helper.rb'

describe 'pgbouncer::example' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['pgbouncer_instance']).converge(described_recipe)
  end

  it 'Setup a pgbouncer instance' do
    expect(chef_run).to create_pgbouncer_instance('example')
  end

  it 'creates the group pgbouncer' do
    expect(chef_run).to create_group('pgbouncer')
  end

  it 'creates the user pgbouncer' do
    expect(chef_run).to create_user('pgbouncer')
  end

  it 'should install pgbouncer' do
    expect(chef_run).to install_package('pgbouncer')
  end

  it 'enables the service pgbouncer' do
    service = chef_run.service('pgbouncer-example')
    expect(service).to do_nothing
  end

  %w(
    /etc/pgbouncer
    /etc/pgbouncer/db_sockets
    /var/log/pgbouncer
    /var/run/pgbouncer
  ).each do |dir|
    it "creates directory #{dir}" do
      expect(chef_run).to create_directory(dir).with(
        user:   'pgbouncer',
        group:  'pgbouncer'
      )
    end
  end

  it 'does not create empty directory' do
    expect(chef_run).to_not create_directory('')
  end

  %w(
    /etc/pgbouncer/userlist-example.txt
    /etc/pgbouncer/pgbouncer-example.ini
    /etc/init/pgbouncer-example.conf
    /etc/logrotate.d/pgbouncer-example
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
    expect(chef_run).to start_service('pgbouncer-example-start')
  end
end
