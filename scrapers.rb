#!/usr/bin/ruby
#
require 'scrapi'

TidyFFI.library_path = '/home/lintonye/.rvm/gems/ruby-1.9.3-p194/gems/scrapi-2.0.0/lib/tidy/libtidy.so'

def search(term)
  project_scr = Scraper.define do
    process 'div.project-thumbnail>a>img:first-child', :thumbnail=>'@src'
    process 'h2>a', :name=>:text, :link=>'@href'
    result :thumbnail, :name, :link
  end

  kct_scr = Scraper.define do
    array :projects
    process 'ul.project-card-list>li.project', :projects=>project_scr
    result :projects
  end

  url = "http://www.kickstarter.com/projects/search?utf8=&term=#{term}"
  projects = kct_scr.scrape URI.parse(url)
end

def project(link)
  project_scr = Scraper.define do
    root = 'div[id=moneyraised]'
    process "#{root} div[id=backers_count]", :backers=>'@data-backers-count'
    process "#{root} div[id=pledged]", :pledged=>'@data-pledged'
    result :backers, :pledged
  end

  url = "http://www.kickstarter.com#{link}"
  project_scr.scrape URI.parse(url)
end

#puts search 'table'
#puts project('/projects/gaborvida/chameleon-a-better-home-screen-for-your-android-ta?ref=search')
