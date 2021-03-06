#
# Cookbook Name:: wrapper
# Recipe:: default_expanded
#
# Copyright 2014, Rackspace
#

def enterprise?
  node['magentostack'] && node['magentostack']['flavor'] == 'enterprise'
end

# This wrapper's default recipe is intended to build a single node magento
# installation with all components split apart (such as separate redis instances)
#
# Add more recipes in the wrapper for other topologies/configurations of magentostack.
%w(
  wrapper::_redis_password
  magentostack::redis_object
  magentostack::redis_object_slave
  magentostack::redis_page
  magentostack::redis_page_slave
  magentostack::redis_session
  magentostack::redis_session_slave
  magentostack::redis_sentinel
  magentostack::redis_configure
  magentostack::apache-fpm
  magentostack::magento_install
  magentostack::nfs_server
  magentostack::nfs_client
  magentostack::mysql_master
  magentostack::newrelic
  magentostack::_find_mysql
  magentostack::magento_configure
  magentostack::magento_admin
  magentostack::mysql_holland
).each do |recipe|
  include_recipe recipe
end

# if enterprise edition, also enable the FPC for testing
if enterprise?
  include_recipe 'magentostack::_magento_fpc'
else
  include_recipe 'magentostack::varnish'
  include_recipe 'magentostack::_magento_turpentine'
end
