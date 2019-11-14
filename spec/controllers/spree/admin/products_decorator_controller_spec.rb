require 'rails_helper'

RSpec.describe Spree::Admin::ProductsController, type: :controller do

  stub_authorization!

  context '#import' do
    let(:ability_user) { stub_model(Spree::LegacyUser, has_spree_role?: true) }

    it 'Import products with no file' do
      post :import, {}
      expect(response).to redirect_to(admin_products_path)
      expect(flash[:alert]).to eq Spree.t('notice_messages.no_file')
    end

  end

end
