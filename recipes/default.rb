#
# Cookbook Name:: git-deploy
# Recipe:: default
#
# Copyright 2013, Edify Software Consulting.
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

package "git"

users_manage "git" do
    data_bag node[:git_deploy][:users_data_bag]
    group_name "git"
    group_id 3500
end

sudo "git" do
    user "git"
    runas "ALL"
    nopasswd true
end

directory "/srv/git" do
    owner "git"
    group "git"
    mode 0775
end

directory "/srv/git/#{node[:git_deploy][:repo]}.git" do
    owner "git"
    group "git"
    mode 0775
    recursive true
end

execute "create app GIT repo" do
    user "git"
    cwd "/srv/git/#{node[:git_deploy][:repo]}.git"
    command "git init ; git config receive.denyCurrentBranch ignore"
    not_if { File.exists? "/srv/git/#{node[:git_deploy][:repo]}.git/.git" }
end

cookbook_file "/srv/git/#{node[:git_deploy][:repo]}.git/.git/hooks/post-receive" do
    source "post-receive"
    owner "git"
    group "git"
    mode 0755
end
