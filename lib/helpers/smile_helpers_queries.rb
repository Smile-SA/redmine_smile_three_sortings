# Smile - queries_helper enhancement

# module Smile::Helpers::QueriesOverride
# * module ::ThreeSortings

module Smile
  module Helpers
    module QueriesOverride
      #*****************
      # 1/ ThreeSortings
      module ThreeSortings
        def self.prepended(base)
          three_sortings_instance_methods = [
            :column_header, # 1/ REWRITTEN RM 4.0.0 OK
          ]

          base.module_eval do
            # 1/ REWRITTEN RM 4.0.0 OK
            #
            def column_header(query, column, options={})
              if column.sortable?
                css, order = nil, column.default_order
                if column.name.to_s == query.sort_criteria.first_key
                  if query.sort_criteria.first_asc?
                    #31433: Use "icon icon-*" classes for sort-handler, collapsible fieldsets and collapsible versions
                    css = 'sort asc icon icon-sorted-desc'
                    # Plugin specific : Issues list : icon to remove sort on column
                    css_del = 'sort-del asc'
                    order = 'desc'
                  else
                    #31433: Use "icon icon-*" classes for sort-handler, collapsible fieldsets and collapsible versions
                    css = 'sort desc icon icon-sorted-asc'
                    # Plugin specific : Issues list : icon to remove sort on column
                    css_del = 'sort-del desc'
                    order = 'asc'
                  end
                end

                #################
                # Plugin specific : second sort column
                if query.sort_criteria.size >= 2 && column.name.to_s == query.sort_criteria.second_key
                  if query.sort_criteria.second_asc?
                    css = 'sort2 asc'
                    # Plugin specific : Issues list : icon to remove sort on column
                    css_del = 'sort2-del asc'
                  else
                    css = 'sort2 desc'
                    # Plugin specific : Issues list : icon to remove sort on column
                    css_del = 'sort2-del desc'
                  end
                end

                # Plugin specific : third sort column
                if query.sort_criteria.size >= 3 && column.name.to_s == query.sort_criteria.third_key
                  if query.sort_criteria.third_asc?
                    css = 'sort3 asc'
                    # Plugin specific : Issues list : icon to remove sort on column
                    css_del = 'sort3-del asc'
                  else
                    css = 'sort3 desc'
                    # Plugin specific : Issues list : icon to remove sort on column
                    css_del = 'sort3-del desc'
                  end
                end
                # END -- Plugin specific
                ########################

                param_key = options[:sort_param] || :sort
                sort_param = { param_key => query.sort_criteria.add(column.name, order).to_param }
                while sort_param.keys.first.to_s =~ /^(.+)\[(.+)\]$/
                  sort_param = {$1 => {$2 => sort_param.values.first}}
                end

                #################
                # Plugin specific : Issues list : icon to remove sort on column
                sort_delete_param = { param_key => query.sort_criteria.delete(column.name).to_param }

                #################
                # Plugin specific : class removed on first link_to
                link_options = {
                    :title => l(:label_sort_by, "\"#{column.caption}\"")
                    # :class => css
                  }
                if options[:sort_link_options]
                  link_options.merge! options[:sort_link_options]
                end

                ################
                # Plugin specific : url_options variabl because used twice
                url_options = {:params => request.query_parameters.deep_merge(sort_param)}

                #################
                # Plugin specific : Issues list : icon to remove sort on column
                url_delete_options = {:params => request.query_parameters.deep_merge(sort_delete_param)}

                content = link_to(column.caption,
                    url_options,
                    link_options
                  ) +
                  ##############################################
                  # Plugin specific : Sort link on a second line
                  '<br/>'.html_safe +
                  link_to('&nbsp;'.html_safe, url_options, :class => css) +
                  #################
                  # Plugin specific : Issues list : icon to remove sort on column
                  '<br/>'.html_safe +
                  link_to('&nbsp'.html_safe, url_delete_options, :class => css_del)
                  # END -- Plugin specific : Sort link on a second line
                  #####################################################
              else
                content = column.caption
              end
              content_tag('th', content, :class => column.css_classes)
            end
          end # base.module_eval do


          trace_prefix       = "#{' ' * (base.name.length + 16)}  --->  "
          last_postfix       = '< (SM::HO::QueriesOverride::ThreeSortings)'

          smile_instance_methods = base.instance_methods.select{|m|
              three_sortings_instance_methods.include?(m) &&
                base.instance_method(m).source_location.first =~ SmileTools.regex_path_in_plugin('lib/helpers/smile_helpers_queries', :redmine_smile_three_sortings)
            }

          missing_instance_methods = three_sortings_instance_methods.select{|m|
            !smile_instance_methods.include?(m)
          }

          if missing_instance_methods.any?
            trace_first_prefix = "#{base.name} MISS    instance_methods  "
          else
            trace_first_prefix = "#{base.name}         instance_methods  "
          end

          SmileTools::trace_by_line(
            (
              missing_instance_methods.any? ?
              missing_instance_methods :
              smile_instance_methods
            ),
            trace_first_prefix,
            trace_prefix,
            last_postfix
          )

          if missing_instance_methods.any?
            raise trace_first_prefix + missing_instance_methods.join(', ') + '  ' + last_postfix
          end
        end # def self.prepended
      end # module ThreeSortings
    end # module QueriesOverride
  end # module Helpers
end # module Smile
