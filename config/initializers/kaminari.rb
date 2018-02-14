#Active Admin, tiene conflicto con la gema will_paginate, donde marca error en el
#metodo "per" este metodo remplaza o sobre escribe el metodo para corregir el error
Kaminari.configure do |config|
  config.page_method_name = :per_page_kaminari
end