require 'bundler/setup'
require 'rest-client'
require 'base64'
require 'dotenv'
Dotenv.load

class Zackylab
  def self.members? gh_id
    basic = Base64.encode64(":#{ENV['GH_PERSONAL_TOKEN']}")
    response = RestClient.get "https://api.github.com/orgs/zackylab/members/#{gh_id}", { Authorization: "Basic #{basic}" }
    response.code == 204
  end
end