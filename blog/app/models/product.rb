class Product < ActiveRecord::Base
  self.table_name = "oc_product"
  self.primary_key = "product_id"

#  alias_attribute "id", "product_id"
end
