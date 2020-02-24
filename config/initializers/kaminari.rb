# https://coderwall.com/p/qkwiwa/fix-undefined-method-per-error-on-will_paginate-and-activeadmin
# https://github.com/gregbell/active_admin/wiki/How-to-work-with-will_paginate
# https://github.com/activeadmin/activeadmin/issues/5239#issuecomment-462098839

if defined?(WillPaginate)
  module WillPaginate
    module ActiveRecord
      module RelationMethods
        def per(value = nil) per_page(value) end
        def total_count() count end
      end
    end
    module CollectionMethods
      alias_method :num_pages, :total_pages
    end
  end
end
