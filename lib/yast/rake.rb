#--
# Yast rake
#
# Copyright (C) 2009-2013 Novell, Inc.
#   This library is free software; you can redistribute it and/or modify
# it only under the terms of version 2.1 of the GNU Lesser General Public
# License as published by the Free Software Foundation.
#
#   This library is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
# details.
#
#   You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
#++
require "packaging"

#create wrapper to Packaging Configuration
module Yast
  module Tasks
    def self.configuration &block
      ::Packaging.configuration &block
    end
  end
end

# yast integration testing takes too long and require osc:build so it create
# circle, so replace test dependency with test:unit
task = Rake::Task["package"]
prerequisites = task.prerequisites
prerequisites.delete("test")
# ensure we have proper version in spec
prerequisites.push("version:update_spec")

task.enhance(prerequisites)

Yast::Tasks.configuration do |conf|
  conf.obs_project = "YaST:Head"
  conf.obs_sr_project = "openSUSE:Factory"
  conf.package_name = File.read("RPMNAME").strip if File.exists?("RPMNAME")
end

# load own tasks
task_path = File.expand_path("../../tasks", __FILE__)
Dir["#{task_path}/*.rake"].each do |f|
  load f
end

