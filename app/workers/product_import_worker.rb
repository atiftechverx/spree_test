class ProductImportWorker
  include Sidekiq::Worker

  def perform(filepath)
    ProductImport.new.import(filepath)
  end
end
