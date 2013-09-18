#!/bin/env ruby

require 'bundler'
Bundler.setup

require './lib/settings'
require './lib/redmine_client'

client=RedmineClient.new
result= client.post('issues.json', :issue => {
  project_id: Settings.default_project_id,
  subject: ARGV[0]
})

puts "="*80
puts result.inspect
