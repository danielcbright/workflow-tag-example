#
# Cookbook:: build_cookbook
# Recipe:: publish
#
# Copyright:: 2018, The Authors, All Rights Reserved.
include_recipe 'delivery-truck::publish'

require 'chef/cookbook/metadata'

# Read in Metadata file in current cookbook
cookbook_name = node['delivery']['change']['project']
metadata = Chef::Cookbook::Metadata.new
metadata.from_file("/var/opt/delivery/workspace/<automate-hostname.fqdn>/<enterprise-name>/<org-name>/#{cookbook_name}/master/build/publish/repo/metadata.rb")

cookbook_version = "#{metadata.version}"

vault_data = get_workflow_vault_data

execute "Set git username information" do
  command "git config --global user.email \"<you@email.com>\" && git config --global user.name \"<Your Name>\""
  live_stream true
end

delivery_github 'tag' do
  deploy_key vault_data['publish']['github']['key']
  tag "v#{cookbook_version}"
  branch node['delivery']['change']['pipeline']
  remote_url 'ssh://git@<HOSTNAME:PORT>/<somepath>.git'
  repo_path node['delivery']['workspace']['repo']
  cache_path node['delivery']['workspace']['cache']
  action :push
end
