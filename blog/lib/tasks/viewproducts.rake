task :viewproduct, [:date_added] => :environment do |task, args|
  product = Product.first;
  puts "product #{product.model}"
  productsStr = ""
  header = ""
  products = Product.where("product_id > ? and date_added > ?",0,args[:date_added]).order("model")
  customerGroupDescriptions = CustomerGroupDescription.where("customer_group_id > ? and language_id = ?",0,2).order("name")
  #add product related column header
  header <<("product_id,model,name,weight,status_id,status,")
  for customterGroupDescription in customerGroupDescriptions
    header << (customterGroupDescription.name + ",")
  end
  
  header <<("date_addedx")
  productsStr << header[0..-2]
  f = File.open("ihaitao_products_"+Time.now.strftime("%Y%m%d%H%M%S").to_s+".csv","w")
  f.write(productsStr<<"\n") 
  for product in products
#  Product.find_each(batch_size: 100) do |product|
    productStr =""
    productDescription = ProductDescription.where("product_id = ? and language_id = ?",product.product_id,2).first
    puts product.inspect
    puts productDescription.inspect
    puts "product description #{product.product_id}, #{product.model}, #{productDescription.name}"
    productStr << (product.product_id.to_s + "," + product.model.to_s + "," + productDescription.name + "," + product.weight.to_s + "," + product.stock_status_id.to_s + ","+ product.status.to_s + ",")
    #add price groups
      for customterGroupDescription in customerGroupDescriptions
        groupPrice =""
        puts "customer group #{customterGroupDescription.customer_group_id}, #{customterGroupDescription.name}"
        productSpecial = ProductSpecial.where("product_id = ? and customer_group_id = ? and date_start >= ?",product.product_id,customterGroupDescription.customer_group_id,'0000-00-00')
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
    productStr << (product.date_added.to_s + ",")
    puts "productStr:#{productStr}" 
    f.write(productStr[0..-2]<<"\n")
  end
  f.close
  puts "productsStr:#{productsStr}"    
end
