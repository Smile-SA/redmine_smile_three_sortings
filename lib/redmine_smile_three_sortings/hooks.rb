#*******************************************************************************
# redmine_smile_three_sortings Redmine plugin.
#
# Hooks.
#
#*******************************************************************************

module ThreeSortingsHook
  class Hooks < Redmine::Hook::ViewListener
    Rails.logger.debug "==>plugin hook view_layouts_base_html_head"
    render_on :view_layouts_base_html_head, :partial => "redmine_smile_three_sortings/sorts_css"
  end # class Hooks
end # module
