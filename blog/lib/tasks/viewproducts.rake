task :viewproduct => :environment do
  product = Product.first;
  puts "product #{product.model}"
  productsStr = ""
  header = ""
  products = Product.where("product_id > ?",0).order("model")
  customerGroupDescriptions = CustomerGroupDescription.where("customer_group_id > ? and language_id = ?",0,2).order("name")
  header <<("product_id,model,name,weight,status_id,status,")
  for customterGroupDescription in customerGroupDescriptions
    header << (customterGroupDescription.name + ",")
  end
  
  productsStr << header[0..-2]
  f = File.open("products.csv","w")
  f.write(productsStr<<"\n"); 
  for product in products
#  Product.find_each(batch_size: 100) do |product|
    productStr =""
    productDescription = ProductDescription.where("product_id = ? and language_id = ?",product.product_id,2).first
    puts "product description #{product.product_id}, #{product.model}, #{productDescription.name}"
    productStr << (product.product_id.to_s + "," + product.model.to_s + "," + productDescription.name + "," + product.weight.to_s + "," + product.stock_status_id.to_s + ","+ product.status.to_s + ",")
     for customterGroupDescription in customerGroupDescriptions
        groupPrice =""
        puts "customer group #{customterGroupDescription.customer_group_id}, #{customterGroupDescription.name}"
        productSpecial = ProductSpecial.where("product_id = ? and customer_group_id = ? and date_start = ?",product.product_id,customterGroupDescription.customer_group_id,'0000-00-00')
          unless productSpecial.empty? 
            for ps in productSpecial
              groupPrice << (ps.price.to_s + ",")
              puts "product special #{ps.product_special_id}, #{ps.price}"
            end
          else
              groupPrice << "0,"
              puts "product special # 0 "
          end
        productStr << groupPrice
      end
    puts "productStr:#{productStr}"
    f.write(productStr[0..-2]<<"\n")
  end
  f.close
  puts "productsStr:#{productsStr}"    
end
