# Smile - sort_helper enhancement

# module Smile::Helpers::SortOverride::
# - ThreeSortings
#   2013

module Smile
  module Helpers
    module SortOverride
      module ThreeSortings
        def self.prepended(base)
          three_sorts_instance_methods = [
            :sort_link, # 1/ REWRITTEN RM 4.0.0 OK
          ]

          base.module_eval do
            # 1/ REWRITTEN RM 4.0.0 OK
            #
            # Returns a link which sorts by the named column.
            #
            # - column is the name of an attribute in the sorted record collection.
            # - the optional caption explicitly specifies the displayed link text.
            # - 2 CSS classes reflect the state of the link: sort and asc or desc
            #
            def sort_link(column, caption, default_order)
              css, order = nil, default_order

              if column.to_s == @sort_criteria.first_key
                if @sort_criteria.first_asc?
                  css = 'sort asc'
                  order = 'desc'
                else
                  css = 'sort desc'
                  order = 'asc'
                end
              end

              #################
              # Plugin specific : second sort column
              if @sort_criteria.size >= 2 && column.to_s == @sort_criteria.second_key
                if @sort_criteria.second_asc?
                  css = 'sort2 asc'
                else
                  css = 'sort2 desc'
                end
              end

              # Plugin specific : third sort column
              if @sort_criteria.size >= 3 && column.to_s == @sort_criteria.third_key
                if @sort_criteria.third_asc?
                  css = 'sort3 asc'
                else
                  css = 'sort3 desc'
                end
              end
              # END -- Plugin specific
              ########################

              caption = column.to_s.humanize unless caption

              sort_options = { :sort => @sort_criteria.add(column.to_s, order).to_param }

              #################
              # Plugin specific : url_options because used twice
              url_options = {:params => request.query_parameters.merge(sort_options)}

              # Plugin specific : class removed on first link_to
              link_to(caption, url_options) +
                ##############################################
                # Plugin specific : Sort link on a second line
                '<br/>'.html_safe +
                link_to('&nbsp;&nbsp;&nbsp;&nbsp;'.html_safe, url_options, :class => css)
                # END -- Plugin specific : Sort link on a second line
                #####################################################
            end
          end # base.module_eval do


          trace_prefix       = "#{' ' * (base.name.length + 19)}  --->  "
          last_postfix       = '< (SM::HO::SortOverride::ThreeSortings)'

          smile_instance_methods = base.instance_methods.select{|m|
              three_sorts_instance_methods.include?(m) &&
                base.instance_method(m).source_location.first =~ SmileTools.regex_path_in_plugin('lib/helpers/smile_helpers_sort', :redmine_smile_three_sortings)
            }

          missing_instance_methods = three_sorts_instance_methods.select{|m|
            !smile_instance_methods.include?(m)
          }

          if missing_instance_methods.any?
            trace_first_prefix = "#{base.name} MISS       instance_methods  "
          else
            trace_first_prefix = "#{base.name}            instance_methods  "
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
    end # module SortOverride
  end # module Helpers
end # module Smile
