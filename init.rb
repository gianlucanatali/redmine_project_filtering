# -*- coding: utf-8 -*-
require 'redmine'

require_dependency 'project_filtering_hook_listener'
require_dependency 'project_filtering_project_controller_patch'

Rails.configuration.to_prepare do
  unless ProjectsController.included_modules.include?(FilterProjectsControllerPatch)
    ProjectsController.send(:include, FilterProjectsControllerPatch)
  end
end

Redmine::Plugin.register :redmine_project_filtering do
  name 'Redmine Project Filtering plugin'
  author 'Antonio García-Domínguez'
  description 'Adds filtering to the project list'
  version '0.0.2'
  url 'http://github.com/bluezio/redmine_project_fitlering'
  author_url 'http://neptuno.uca.es/~agarcia'

  requires_redmine :version_or_higher => '2.5'
end
