class ProductImportJob < ApplicationJob
  queue_as :default

  def perform(filepath)
    ProductImport.new.import(filepath)
  end

end
