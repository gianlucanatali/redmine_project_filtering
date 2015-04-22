require 'pp'

module ProjectFilteringPlugin

  class Hooks < Redmine::Hook::ViewListener
  
	#render_on :view_projects_show_sidebar_bottom, :partial => 'projects/show_project_filters_custom_fields'

    def view_layouts_base_sidebar(context={})
      # We're only interested in the 'index' action of the ProjectsController
      controller = context[:controller]
      if not controller.kind_of? ProjectsController or controller.action_name != 'index' then
        return ""
      end
	  
	  #render_on :view_projects_show_sidebar_bottom, :partial => 'projects/show_project_filters_custom_fields'
    
      return context[:controller].send(:render_to_string, {
        :partial => 'projects/show_project_filters_custom_fields',
        :locals => context
      })
    end

  end

end
