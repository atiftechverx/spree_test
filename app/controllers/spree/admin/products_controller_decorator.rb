module Spree::Admin::ProductsControllerDecorator

  def import
    if params[:import].nil?
      redirect_to admin_products_path, flash: { alert: Spree.t('notice_messages.no_file') }
    else
      # ProductImport.new.import(params[:import][:import_file].path)
      ProductImportJob.perform_later(params[:import][:import_file].path)
      redirect_to admin_products_path, flash: { notice: Spree.t('notice_messages.import_success') }
    end
  end

end

Spree::Admin::ProductsController.prepend(Spree::Admin::ProductsControllerDecorator)