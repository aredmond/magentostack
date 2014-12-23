# Encoding: utf-8
#
# Cookbook Name:: magentostack
# Recipe:: _magento_redis
#
# Copyright 2014, Rackspace Hosting
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

master_name, master_ip, master_port = MagentostackUtil.best_redis_session_master(node)
unless master_name && master_ip && master_port
  Chef::Log.warn('magentostack::_magento_redis could not locate a master redis session node')
  return
end

# we're going to do some dirty work here with XML files to configure redis
include_recipe 'xmledit'

# ensure redis session store module is enabled
xml_edit 'enable redis in ./app/etc/modules/Cm_RedisSession.xml' do
  path "#{node['magentostack']['web']['dir']}/app/etc/modules/Cm_RedisSession.xml"
  target '/config/modules/Cm_RedisSession/active[text()=\'false\']'
  fragment '<active>true</active>'
  action :replace # because this file is shipped already with CE/EE
end

# ensure session store is set to db in local.xml
xml_edit 'set session_store to db in ./app/etc/local.xml' do
  path "#{node['magentostack']['web']['dir']}/app/etc/local.xml"
  target '/config/global/session_save'
  parent '/config/global'
  fragment '<session_save><![CDATA[db]]></session_save>'
  action :append_if_missing # because the whole section doesn't exist by default
end

redis_session_fragment = "<redis_session>
      <host>#{master_ip}</host>
      <port>#{master_port}</port>
      <password></password>
      <timeout>2.5</timeout>
      <persistent></persistent>
      <db>2</db>
      <compression_threshold>2048</compression_threshold>
      <compression_lib>gzip</compression_lib>
      <log_level>4</log_level>
      <max_concurrency>6</max_concurrency>
      <break_after_frontend>5</break_after_frontend>
      <break_after_adminhtml>30</break_after_adminhtml>
      <bot_lifetime>7200</bot_lifetime>
    </redis_session>"

xml_edit 'set redis_session in ./app/etc/local.xml' do
  path "#{node['magentostack']['web']['dir']}/app/etc/local.xml"
  target '/config/global/redis_session'
  parent '/config/global'
  fragment redis_session_fragment
  action :append_if_missing # because the whole section doesn't exist by default
end
