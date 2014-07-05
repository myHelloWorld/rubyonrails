task :moveImage => :environment do
  brands = ["gh","tms","jurl","mh","cvt","hlr","biog"]
  for brand in brands
    products = Product.where('model like :prefix', prefix: "#{brand}%")
      for product in products
        image = product.image
        puts "#{product.model} #{product.image}"
        path = brand+"/"+brand+"-"
        if image.include? path
          puts "in its own brand folder #{image}"            
        else
          puts path
          newImage = image.sub(/#{brand}-/,path)
          product.image = newImage
          product.save
          puts "after save #{product.model} #{product.image}" 
        end
     end
  end

end
