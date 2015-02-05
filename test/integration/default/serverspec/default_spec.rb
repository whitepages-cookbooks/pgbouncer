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

  describe service('pgbouncer-example') do
    it { should be_enabled }
  end

  %w(
    /etc/pgbouncer
    /etc/pgbouncer/db_sockets
    /var/log/pgbouncer
    /var/run/pgbouncer
    /etc/pgbouncer/db_sockets/example
  ).each do |dir|
    describe file(dir) do
      it { should be_directory }
    end
  end

  %w(
    /etc/pgbouncer/userlist-example.txt
    /etc/pgbouncer/pgbouncer-example.ini
    /etc/init/pgbouncer-example.conf
    /etc/logrotate.d/pgbouncer-example
  ).each do |f|
    describe file(f) do
      it { should be_file }
    end
  end

  describe service('pgbouncer-example') do
    it { should be_running }
  end
end
