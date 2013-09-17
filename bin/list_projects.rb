#!/bin/env ruby

require 'bundler'
Bundler.setup

require 'rest-core'
require 'settingslogic'
require './lib/settings'

RedmineClient = RC::Builder.client do
  use RC::DefaultSite , Settings.host
  use RC::DefaultHeaders, {"X-Redmine-API-Key" => Settings.api_access_key}
  use RC::JsonRequest, true
  use RC::JsonResponse, true
  use RC::CommonLogger, method(:puts)
end

client=RedmineClient.new
client.get('/projects.json')["projects"].sort_by{|x|x["id"]}.each{|x|
  printf("% 4d %s\n", x["id"], x["name"])
}
