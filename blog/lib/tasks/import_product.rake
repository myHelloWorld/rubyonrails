require 'csv'
namespace :oc do
task :import_product, [:filename] =>:environment do |task, args|
  product = Product.last
  puts product.inspect

  productDescriptions = ProductDescription.find_by(product_id: product.product_id)
  puts productDescriptions.inspect
  #test read csv
  CSV.foreach(args[:filename], :headers => true, :col_sep => '|') do |row|
    puts row['model']
    puts row['english']
    puts row['chinese']
    puts row['price']
    puts row['weight']
    create_product(row)
  end

  end

  
  #test read product and productDescription

  def create_product(row)
  #create new product
    product = Product.new
    product.model = row['model']
    product.sku = ''
    product.upc = ''
    product.ean = ''
    product.jan = ''
    product.isbn = ''
    product.mpn = ''
    product.location = ''
    product.stock_status_id  = 5
    product.manufacturer_id = 0
    product.shipping = true
    product.price = row['price']
    product.points = 0
    product.tax_class_id = 0
    product.date_available = DateTime.now
    product.weight = row['weight']
    product.weight_class_id =0
    product.length = 0
    product.width = 0
    product.height = 0
    product.length_class_id = 1
    product.subtract = 1
    product.sort_order = 0
    product.status = false
    product.date_added = DateTime.now -2
    product.date_modified = DateTime.now -2
    product.save

    #add product name
    productDescription = ProductDescription.new
    productDescription.product_id = product.product_id
    productDescription.language_id = 1
    productDescription.name = row['english']
    productDescription.description = ''
    productDescription.meta_description = ''
    productDescription.meta_keyword = ''
    productDescription.tag = ''


    productDescription.save

    pd = ProductDescription.new
    pd.product_id = product.product_id
    pd.language_id = 2
    pd.name = row['chinese']
    pd.description = ''
    pd.meta_description = ''
    pd.meta_keyword = ''
    pd.tag = ''

    pd.save 

    #add product to store
    productStore = ProductStore.new
    productStore.product_id = product.product_id
    productStore.store_id = 0
    productStore.save

  

  end

end
