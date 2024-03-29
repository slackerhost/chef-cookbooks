# encoding: utf-8
# Author:: Joshua Timberman <joshua@getchef.com>
# Copyright:: Copyright 2009-2014, Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Generic cookbook attributes
default['postfix']['mail_type']  = 'client'
default['postfix']['relayhost_role'] = 'relayhost'
default['postfix']['multi_environment_relay'] = false
default['postfix']['use_procmail'] = false
default['postfix']['use_alias_maps'] = false
default['postfix']['use_transport_maps'] = false
default['postfix']['use_access_maps'] = false
default['postfix']['use_virtual_aliases'] = false
default['postfix']['use_virtual_aliases_domains'] = false
default['postfix']['aliases'] = {}
default['postfix']['transports'] = {}
default['postfix']['access'] = {}
default['postfix']['virtual_aliases'] = {}
default['postfix']['virtual_aliases_domains'] = {}
default['postfix']['main_template_source'] = 'postfix'
default['postfix']['master_template_source'] = 'postfix'
default['postfix']['sender_canonical_map_entries'] = {}
default['postfix']['smtp_generic_map_entries'] = {}
default['postfix']['access_db_type'] = 'hash'
default['postfix']['aliases_db_type'] = 'hash'
default['postfix']['transport_db_type'] = 'hash'
default['postfix']['virtual_alias_db_type'] = 'hash'
default['postfix']['virtual_alias_domains_db_type'] = 'hash'

case node['platform']
when 'smartos'
  default['postfix']['conf_dir'] = '/opt/local/etc/postfix'
  default['postfix']['aliases_db'] = '/opt/local/etc/postfix/aliases'
  default['postfix']['transport_db'] = '/opt/local/etc/postfix/transport'
  default['postfix']['access_db'] = '/opt/local/etc/postfix/access'
  default['postfix']['virtual_alias_db'] = '/opt/local/etc/postfix/virtual'
  default['postfix']['virtual_alias_domains_db'] = '/opt/local/etc/postfix/virtual_domains'
when 'omnios'
  default['postfix']['conf_dir'] = '/opt/omni/etc/postfix'
  default['postfix']['aliases_db'] = 'opt/omni/etc/postfix/aliases'
  default['postfix']['transport_db'] = '/opt/omni/etc/postfix/transport'
  default['postfix']['access_db'] = '/opt/omni/etc/postfix/access'
  default['postfix']['virtual_alias_db'] = '/etc/omni/etc/postfix/virtual'
  default['postfix']['virtual_alias_domains_db'] = '/etc/omni/etc/postfix/virtual_domains'
  default['postfix']['uid'] = 11
else
  default['postfix']['conf_dir'] = '/etc/postfix'
  default['postfix']['aliases_db'] = '/etc/aliases'
  default['postfix']['transport_db'] = '/etc/postfix/transport'
  default['postfix']['access_db'] = '/etc/postfix/access'
  default['postfix']['virtual_alias_db'] = '/etc/postfix/virtual'
  default['postfix']['virtual_alias_domains_db'] = '/etc/postfix/virtual_domains'
end

# Non-default main.cf attributes
default['postfix']['main']['biff'] = 'no'
default['postfix']['main']['append_dot_mydomain'] = 'no'
default['postfix']['main']['myhostname'] = (node['fqdn'] || node['hostname']).to_s.chomp('.')
default['postfix']['main']['mydomain'] = (node['domain'] || node['hostname']).to_s.chomp('.')
default['postfix']['main']['myorigin'] = '$myhostname'
default['postfix']['main']['mydestination'] = [node['postfix']['main']['myhostname'], node['hostname'], 'localhost.localdomain', 'localhost'].compact
default['postfix']['main']['smtpd_use_tls'] = 'yes'
default['postfix']['main']['smtp_use_tls'] = 'yes'
default['postfix']['main']['smtp_sasl_auth_enable'] = 'no'
default['postfix']['main']['mailbox_size_limit'] = 0
default['postfix']['main']['mynetworks'] = nil
default['postfix']['main']['inet_interfaces'] = 'loopback-only'

# Conditional attributes
case node['platform_family']
when 'smartos'
  default['postfix']['main']['smtpd_use_tls'] = 'no'
  default['postfix']['main']['smtp_use_tls'] = 'no'
  cafile = '/opt/local/etc/postfix/cacert.pem'
when 'rhel'
  cafile = '/etc/pki/tls/cert.pem'
else
  cafile = "#{node['postfix']['conf_dir']}/cacert.pem"
end

if node['postfix']['use_procmail']
  default['postfix']['main']['mailbox_command'] = '/usr/bin/procmail -a "$EXTENSION"'
end

if node['postfix']['main']['smtpd_use_tls'] == 'yes'
  default['postfix']['main']['smtpd_tls_cert_file'] = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
  default['postfix']['main']['smtpd_tls_key_file'] = '/etc/ssl/private/ssl-cert-snakeoil.key'
  default['postfix']['main']['smtpd_tls_CAfile'] = cafile
  default['postfix']['main']['smtpd_tls_session_cache_database'] = 'btree:${data_directory}/smtpd_scache'
end

if node['postfix']['main']['smtp_use_tls'] == 'yes'
  default['postfix']['main']['smtp_tls_CAfile'] = cafile
  default['postfix']['main']['smtp_tls_session_cache_database'] = 'btree:${data_directory}/smtp_scache'
end

if node['postfix']['main']['smtp_sasl_auth_enable'] == 'yes'
  default['postfix']['sasl_password_file'] = "#{node['postfix']['conf_dir']}/sasl_passwd"
  default['postfix']['main']['smtp_sasl_password_maps'] = "hash:#{node['postfix']['sasl_password_file']}"
  default['postfix']['main']['smtp_sasl_security_options'] = 'noanonymous'
  default['postfix']['sasl']['smtp_sasl_user_name'] = ''
  default['postfix']['sasl']['smtp_sasl_passwd']    = ''
  default['postfix']['main']['relayhost'] = ''
end

if node['postfix']['use_alias_maps']
   default['postfix']['main']['alias_maps'] = ["hash:#{node['postfix']['aliases_db']}"]
end

if node['postfix']['use_transport_maps']
   default['postfix']['main']['transport_maps'] = ["hash:#{node['postfix']['transport_db']}"]
end

if node['postfix']['use_access_maps']
   default['postfix']['main']['access_maps'] = ["hash:#{node['postfix']['access_db']}"]
end

if node['postfix']['use_virtual_aliases']
  default['postfix']['main']['virtual_alias_maps'] = ["#{node['postfix']['virtual_alias_db_type']}:#{node['postfix']['virtual_alias_db']}"]
end

if node['postfix']['use_virtual_aliases_domains']
  default['postfix']['main']['virtual_alias_domains'] = ["#{node['postfix']['virtual_alias_domains_db_type']}:#{node['postfix']['virtual_alias_domains_db']}"]
end

# # Default main.cf attributes according to `postconf -d`
# default['postfix']['main']['relayhost'] = ''
# default['postfix']['main']['milter_default_action']  = 'tempfail'
# default['postfix']['main']['milter_protocol']  = '6'
# default['postfix']['main']['smtpd_milters']  = ''
# default['postfix']['main']['non_smtpd_milters']  = ''
# default['postfix']['main']['sender_canonical_classes'] = nil
# default['postfix']['main']['recipient_canonical_classes'] = nil
# default['postfix']['main']['canonical_classes'] = nil
# default['postfix']['main']['sender_canonical_maps'] = nil
# default['postfix']['main']['recipient_canonical_maps'] = nil
# default['postfix']['main']['canonical_maps'] = nil

# Master.cf attributes
default['postfix']['master']['submission'] = false
