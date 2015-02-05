# encoding: utf-8
require 'spec_helper'

# Write integration tests with Serverspec - http://serverspec.org/
describe 'pgbouncer::example' do
  describe group('pgbouncer') do
    it { should exist }
  end

  describe user('pgbouncer') do
    it { should exist }
  end

  describe package('pgbouncer') do
    it { should be_installed }
  end

  describe service('pgbouncer-database_example_com_ro') do
    it { should be_enabled }
  end

  %w(
    /etc/pgbouncer
    /etc/pgbouncer/db_sockets
    /var/log/pgbouncer
    /var/run/pgbouncer
    /etc/pgbouncer/db_sockets/database_example_com_ro
  ).each do |dir|
    describe file(dir) do
      it { should be_directory }
    end
  end

  %w(
    /etc/pgbouncer/userlist-database_example_com_ro.txt
    /etc/pgbouncer/pgbouncer-database_example_com_ro.ini
    /etc/init/pgbouncer-database_example_com_ro.conf
    /etc/logrotate.d/pgbouncer-database_example_com_ro
  ).each do |f|
    describe file(f) do
      it { should be_file }
    end
  end

  describe service('pgbouncer-database_example_com_ro') do
    it { should be_running }
  end
end
