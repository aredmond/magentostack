# Encoding: utf-8

require_relative 'spec_helper'

# Apache-fpm
if os[:family] == 'redhat'
  docroot = '/var/www/html/magento'
  apache_service_name = 'httpd'
  fpm_service_name = 'php-fpm'
  apache2ctl = '/usr/sbin/apachectl'
else
  docroot = '/var/www/magento'
  apache_service_name = 'apache2'
  fpm_service_name = 'php5-fpm'
  apache2ctl = '/usr/sbin/apache2ctl'
end

describe service(apache_service_name) do
  it { should be_enabled }
  it { should be_running }
end

describe service(fpm_service_name) do
  it { should be_enabled }
  it { should be_running }
end
describe port(80) do
  it { should be_listening }
end
describe port(443) do
  it { should be_listening }
end

modules = %w(
  status actions alias auth_basic
  authn_file authz_groupfile authz_host
  authz_user autoindex dir env mime
  negotiation setenvif ssl headers
  expires log_config logio fastcgi
)
# Apache 2.4(default on Ubuntu 14) doesn't have the authz_default module
modules << 'authz_default' unless os[:release] == '14.04'
modules.each do |mod|
  describe command("#{apache2ctl} -M") do
    its(:stdout) { should match(/^ #{mod}_module/) }
  end
end

## test configuration syntax
describe command("#{apache2ctl} -t") do
  its(:exit_status) { should eq 0 }
end

## apachectl -S on Apache 2.4(default on Ubuntu 14) has a different output
if os[:release] == '14.04'
  describe command("#{apache2ctl} -S") do
    its(:stdout) { should match(/\*:443                  mymagento.com/) }
    its(:stdout) { should match(/\*:80                   mymagento.com/) }
  end
else
  describe command("#{apache2ctl} -S") do
    its(:stdout) { should match(/port 443 namevhost mymagento.com/) }
    its(:stdout) { should match(/port 80 namevhost mymagento.com/) }
  end
end

describe file(docroot) do
  it { should be_directory }
end

## Create an index.php for testing purpose
## using wget because curl is nto there by default on ubuntu
describe command('wget -qO- localhost') do
  before do
    File.open("#{docroot}/index.php", 'w') { |file| file.write('<?php phpinfo(); ?>') }
  end
  its(:stdout) { should match(/FPM\/FastCGI/) }
  after do
    File.delete("#{docroot}/index.php")
  end
end