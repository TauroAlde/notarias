#Active Admin, has a conflict with the will_paginate gem, where it marks error in the
#method "per" this method replaces or overwrites the method to fix the error
Kaminari.configure do |config|
  config.page_method_name = :per_page_kaminari
end