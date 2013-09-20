#!/bin/env ruby

require 'bundler'
Bundler.setup

require './lib/settings'
require './lib/redmine_client'

client=RedmineClient.new
client.get("/projects/#{Settings.default_project_id}/memberships.json")["memberships"].sort_by{|x|x["id"]}.each{|x|
  roles = x["roles"].map{|r| r['name'] }.join(', ')
  printf("% 4d % 10s %s\n", x["user"]["id"], x["user"]["name"], roles )
}
