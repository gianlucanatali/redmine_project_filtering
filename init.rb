# -*- coding: utf-8 -*-
require 'redmine'

require_dependency 'redmine_project_filtering/hooks'

Redmine::Plugin.register :redmine_project_filtering do
  name 'Redmine Project Filtering plugin'
  author 'Antonio García-Domínguez'
  description 'Adds filtering to the project list'
  version '0.0.1'
  url 'http://github.com/bluezio/redmine_project_fitlering'
  author_url 'http://neptuno.uca.es/~agarcia'
end
