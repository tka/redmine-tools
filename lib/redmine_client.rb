require 'rest-core'

RedmineClient = RC::Builder.client do
  use RC::DefaultSite , Settings.host
  use RC::DefaultHeaders, {"X-Redmine-API-Key" => Settings.api_access_key}
  use RC::JsonRequest, true
  use RC::JsonResponse, true
  use RC::CommonLogger, method(:puts)
end
