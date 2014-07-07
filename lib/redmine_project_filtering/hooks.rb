require 'pp'

module ProjectFilteringPlugin

  class Hooks < Redmine::Hook::ViewListener

    def view_layouts_base_sidebar(context={})
      # We're only interested in the 'index' action of the ProjectsController
      controller = context[:controller]
      if not controller.kind_of? ProjectsController or controller.action_name != 'index' then
        return ""
      end

      return context[:controller].send(:render_to_string, {
        :partial => 'projects/hooks/sidebar',
        :locals => context
      })
    end

  end

end
