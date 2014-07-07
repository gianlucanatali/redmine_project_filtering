# Patch for ProjectsController that allows filtering in the "index"
# action, based on the information in [1] and [2].
#
# NOTE: due to this approach, if another plugin overrides the index
# action of the ProjectController, this plugin will be disabled!
#
# [1]: http://www.redmine.org/projects/redmine/wiki/Plugin_Internals
# [2]: https://github.com/edavis10/redmine_rate/blob/master/lib/rate_users_helper_patch.rb

module FilterProjectsControllerPatch

  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
    base.class_eval do
      alias_method_chain :index, :filter
    end
  end

  module InstanceMethods
    def index_with_filter(context={})
      index_without_filter

      # For now, just try duplicating the filter element
      @projects.push(@projects[0])

      @project_count = @projects.count
    end
  end

end
