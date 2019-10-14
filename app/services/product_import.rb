class ProductImport
  require 'roo'

  def import(file_path)
    spreadsheet = Roo::CSV.new(file_path)
    spreadsheet.default_sheet = spreadsheet.sheets.first
    header = spreadsheet.row(1)
    byebug
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      # Don't import row where the Slug is blank
      next if row['Slug'].blank?
      
      product = Spree::Product.find_by(slug: row['Slug'])
      product = create_product(Spree::Product.new, row) if product.nil? && row['Name'].present?
      
      create_variant(product, row) if row['Name'].blank? && row['Slug'].present?
    end

    # path =  "#{Rails.root}/sample.csv"
    # ProductImport.import(path)
  end

  private

  def create_product(product, row)
    product.name = row['Name']
    product.description = row['Description']
    product.price = row['Price'].nil? ? 0 : row['Price']
    product.available_on = row['Availability Date']
    product.slug = row['Slug']
    # tax_category = Spree::TaxCategory.find_by!(name: "Clothing")
    set_taxons(product, row)
    set_option_types(product)
    set_shipping_category(product)
    product.save!
    Rails.logger.info "Product created successfully."
    product
  end

  def create_variant(product, row)
    Rails.logger.info "Creating Variant..."
    variant = Spree::Variant.find_by(product_id: product.id, sku: row['SKU'])
    if variant.nil?
      variant = Spree::Variant.new(product: product, sku: row['SKU'], price: row['Price'], cost_price: row['Cost Price'])
    end
    set_option_values(variant, row)
    variant.save!
    set_stock(variant, row)
    product.variants << variant
    variant
  end

  def set_taxons(product, row)
    if row['Category'].present?
      taxon = Spree::Taxon.where(["LOWER(name) LIKE ?","%#{row['Category'].downcase}%"]).first
      taxon = Spree::Taxon.create(name: row['Category'].capitalize) if taxon.nil?
      product.taxons << taxon unless product.taxons.include?(taxon)
    end
  end

  def set_option_types(product)
    size, color = find_or_create_option_types
    product.option_types << size unless product.option_types.include?(size)
    product.option_types << color unless product.option_types.include?(color)
  end

  def set_shipping_category(product)
    default_shipping_category = Spree::ShippingCategory.find_or_create_by(name: 'Default')
    product.shipping_category = default_shipping_category
  end

  def set_option_values(variant, row)
    size, color = find_or_create_option_types
    option_value_size = Spree::OptionValue.find_or_create_by(name: row['Size'], presentation: row['Size'], option_type: size)
    variant.option_values << option_value_size unless variant.option_values.include?(option_value_size)
    
    option_value_color = Spree::OptionValue.find_or_create_by(name: row['Color'], presentation: row['Color'], option_type: color)
    variant.option_values << option_value_color unless variant.option_values.include?(option_value_color)
  end

  def set_stock(variant, row)
    variant.stock_items.each do |stock_item|
      Spree::StockMovement.create(quantity: row['Quantity'].to_i, stock_item: stock_item)
    end
  end

  def find_or_create_option_types
    [
      Spree::OptionType.find_or_create_by(name: "Size", presentation: "Size"), 
      Spree::OptionType.find_or_create_by(name: "Color", presentation: "Color")
    ]
  end

end