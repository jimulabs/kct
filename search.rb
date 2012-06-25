#!/usr/local/bin/ruby
WEB = true

require_relative 'scrapers'
require 'cgi'
require 'json'

cgi = CGI.new
term = cgi.params['term'][0]
projects = search term
cgi.out do
  result = { 'status'=>'ok', 'projects'=>projects }
  result.to_json
end
