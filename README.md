redmine_smile_three_sortings
============================

Redmine plugin that adds a second and third possible sort, and a remove sort link

## How it works

* REWRITES **QueryHelper.column_header**
* REWRITES **SortHelper.sort_link**
* New methods added to **Redmine::SortCriteria** :
  * **second_key**, **second_asc?**
  * **third_key**, **third_asc?**
  * **delete!**, **delete**
* New Application Helper **needs_sort_css?** to determine if the css file for sorts is necessary
* Hook call to include css file in layout (**view_layouts_base_html_head**)

Enjoy !
