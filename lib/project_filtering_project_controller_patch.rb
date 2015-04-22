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
		

		@attributes = (params[:project] || {}).reject {|k,v| v.blank?}
		logger.info "@attributes:  #{@attributes.inspect}"
		@attributes.keys.each {|k| @attributes[k] = '' if @attributes[k] == 'none'}
		if custom = @attributes[:custom_field_values]
			custom.reject! {|k,v| v.blank?}
			custom_field_sql_arr = []
			logger.info "custom:  #{custom.inspect}"
			logger.info "custom.keys:  #{custom.keys.inspect}"
			custom.keys.each do |k|
				if custom[k].is_a?(Array)
					custom[k] << '' if custom[k].delete('__none__')
					custom_field_query_arr=[]
					custom[k].each do |val|
						custom_field_query_arr.push(" LOWER(value) LIKE '#{val.downcase}' ")
					end

				custom_field_sql_arr.push("(custom_field_id=#{k} AND ("+custom_field_query_arr.join(" OR ")+"))" )
				else
					custom[k] = '' if custom[k] == '__none__'
					custom_field_sql_arr.push("(custom_field_id=#{k} AND LOWER(value) LIKE '#{custom[k].downcase}' )")
				end

				final_query=custom_field_sql_arr.join(" OR ")
				final_query=final_query+" and customized_type='Project' "
				logger.info "where:  #{final_query.inspect}"
				logger.info "count keys:  #{custom.keys.size}"
				customValRes = CustomValue.select("customized_id").where(final_query).group("customized_id").having("count(distinct custom_field_id)=#{custom.keys.size}")
				logger.info "custom RESULT QUERY list:  #{customValRes.inspect}"
  		    
				if !customValRes.blank?
					@projects = Project.where(" id IN (#{customValRes.collect(&:customized_id).join(',')})")
					logger.info "found projects list:  #{@projects.inspect}"
				else
					@projects = Project.where("1=2") #I wan an empty obj
				end
			end
		end
		
		if @project.blank?
			@project=Project.new
		end
		logger.info "attributes key list:  #{@attributes.keys.inspect}"
		
		# Computed fields ########################################################
		@project_count = @projects.count
		end
	end

end
