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
      # Invoke the original version first
      index_without_filter

      # Domain objects #########################################################
      @all_roles = Role.sorted

      # Filter by roles ########################################################
      if params[:filter_roles] then
        @filter_roles = params[:filter_roles].map {|r| r[0].to_i}
      else
        @filter_roles = @all_roles.map {|r| r.id}
      end
      @filter_roles = @filter_roles.sort

      @projects = @projects.select do |p|
        sorted_proles_ids = User.current.roles_for_project(p).map {|r| r.id}.sort
        matching_proles = @filter_roles & sorted_proles_ids
        next not(matching_proles.empty?)
      end

      # Computed fields ########################################################
      @project_count = @projects.count
    end
  end

end
