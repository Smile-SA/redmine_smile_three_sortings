# Smile - add methods to the Redmine::SortCriteria class
#
# module ThreeSortings
# - Display sort icons for second and third sort column

module Smile
  module RedmineOverride
    module SortCriteriaOverride
      module ThreeSortings
        def self.prepended(base)
          three_sorts_criteria_instance_methods = [
            :second_key,  # 1/ new method
            :second_asc?, # 2/ new method
            :third_key,   # 3/ new method
            :third_asc?,  # 4/ new method
            :delete!,     # 5/ new method
            :delete,      # 6/ new method
          ]

          base_name = 'RM::SortCriteria'


          trace_prefix       = "#{' ' * (base_name.length + 16)}  --->  "
          last_postfix       = '< (SM::RM::SortCriteriaOverride::ThreeSortings)'

          smile_instance_methods = base.instance_methods.select{|m|
              base.instance_method(m).owner == self
            }

          missing_instance_methods = three_sorts_criteria_instance_methods.select{|m|
            !smile_instance_methods.include?(m)
          }

          if missing_instance_methods.any?
            trace_first_prefix = "#{base_name} MISS instance_methods  "
          else
            trace_first_prefix = "#{base_name}      instance_methods  "
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

        # 1/ new method
        def second_key
          second.try(:first)
        end

        # 2/ new method
        def second_asc?
          second.try(:last) == 'asc'
        end

        # 3/ new method
        def third_key
          self[2].try(:first)
        end

        # 4/ new method
        def third_asc?
          self[2].try(:last) == 'asc'
        end

        # 5/ new method
        def delete!(key)
          key = key.to_s
          delete_if {|k,o| k == key}
          normalize!
        end

        # 6/ new method
        def delete(*args)
          self.class.new(self).delete!(*args)
        end
      end # module ThreeSortings
    end # module SortCriteriaOverride
  end # module RedmineOverride
end # module Smile
