#!/bin/env ruby

require 'bundler'
Bundler.setup

require './lib/settings'
require './lib/redmine_client'

client=RedmineClient.new
result= client.get('projects.json')
projects = result["projects"]

puts "="*80
projects.sort_by{|x|x["id"]}.each{|x|
  printf("% 4d %s\n", x["id"], x["name"])
}
