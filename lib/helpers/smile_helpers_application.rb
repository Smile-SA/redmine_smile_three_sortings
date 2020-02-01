# Smile - application_helper enhancement
# module Smile::Helpers::ApplicationOverride
#
# - 1/ module ::ThreeSortings

module Smile
  module Helpers
    module ApplicationOverride
      ##################
      # 1/ ThreeSortings
      module ThreeSortings
        def self.prepended(base)
          three_sortings_instance_methods = [
            # module_eval
            :needs_sort_css?,              # 1/ new method V4.0.0 OK
          ]

          # module_eval mandatory with helpers, but no more access to rewritten methods
          # => use of alias method to access to ancestor version
          base.module_eval do
            # 1/ New method, RM 4.0.0 OK
            def needs_sort_css?
              if action_name == 'index'
                if [
                  'issues', 'timelog',
                  'journals_history', 'weekly_history', 'version_workloads',
                  'files', 'users',
                ].include?(controller_name)
                  return true
                end
              end

              if action_name == 'show'
                if [
                  'boards',
                ].include?(controller_name)
                  return true
                end
              end

              if action_name == 'page' && controller_name == 'my'
                return true
              end

              false
            end
          end

          smile_instance_methods = base.instance_methods.select{|m|
              three_sortings_instance_methods.include?(m) &&
                base.instance_method(m).source_location.first =~ SmileTools.regex_path_in_plugin('lib/helpers/smile_helpers_application', :redmine_smile_three_sortings)
            }

          missing_instance_methods = three_sortings_instance_methods.select{|m|
            !smile_instance_methods.include?(m)
          }

          trace_prefix         = "#{' ' * (base.name.length + 15)}  --->  "
          module_name          = 'SM::HO::AppOverride::ThreeSortings'
          last_postfix         = "< (#{module_name})"

          if missing_instance_methods.any?
            trace_first_prefix = "#{base.name} MIS instance_methods  "
          else
            trace_first_prefix = "#{base.name}     instance_methods  "
          end

          SmileTools::trace_by_line(
            (
              missing_instance_methods.any? ?
              missing_instance_methods :
              smile_instance_methods
            ),
            trace_first_prefix,
            trace_prefix,
            last_postfix,
            :redmine_smile_three_sortings
          )

          if missing_instance_methods.any?
            raise trace_first_prefix + missing_instance_methods.join(', ') + '  ' + last_postfix
          end
        end # def self.prepended
      end # module ThreeSortings
    end # module ApplicationOverride
  end # module Helpers
end # module Smile
