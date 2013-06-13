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

git_user_info = data_bag_item(node[:git_deploy][:users_data_bag], "git")

group "git" do
    action :create
end

user "git" do
    action :create
    comment "Git deploy user"
    gid "git"
    home "/home/git"
    shell "/usr/bin/git-shell"
    supports :manage_home => true
end

sudo "git" do
    user "git"
    runas "ALL"
    nopasswd true
end

directory "/home/git/.ssh" do
    owner "git"
    group "git"
    mode 00755
end

template "/home/git/.ssh/authorized_keys" do
    source "authorized_keys.erb"
    owner "git"
    group "git"
    variables(:keys => git_user_info["ssh_keys"])
    mode 00600
end


directory "/srv/git" do
    owner "git"
    group "git"
    mode 00775
end

directory "/srv/git/#{node[:git_deploy][:repo]}.git" do
    owner "git"
    group "git"
    mode 00775
    recursive true
end

directory "srv/app" do
    owner "git"
    group "git"
    mode 00755
end

execute "create app GIT repo" do
    user "git"
    cwd "/srv/git/#{node[:git_deploy][:repo]}.git"
    command "git init --bare"
    not_if { File.exists? "/srv/git/#{node[:git_deploy][:repo]}.git/.git" }
end

template "/srv/git/#{node[:git_deploy][:repo]}.git/hooks/pre-receive" do
    source "pre-receive.erb"
    owner "git"
    group "git"
    mode 00755
end

cookbook_file "/home/git/receiver" do
    source "receiver"
    owner "git"
    group "git"
    mode 00755
end

