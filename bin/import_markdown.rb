#!/bin/env ruby


require 'bundler'
Bundler.setup
require 'pry'
$LOAD_PATH << './lib'
require 'settings'
require 'redmine_client'
require 'issue'
require "kramdown"

puts File.absolute_path(ARGV[0])
source = open( ARGV[0], 'r' ){|f| f.read}

doc = Kramdown::Document.new(source)

issues= doc.to_issues
puts "="*80
issues.select{|x| x.parent == nil }.each do |issue|
  issue.save_to_redmine
  puts issue.to_s
end 


