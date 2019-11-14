require 'rails_helper'

RSpec.describe 'Import Product', type: :feature do

  stub_authorization!

  context '#import' do
    let(:ability_user) { stub_model(Spree::LegacyUser, has_spree_role?: true) }

    scenario 'Import products with csv' do
      visit spree.admin_products_path
      filepath = Rails.root.join("sample.csv")
      find('#importProductsForm input[type="file"]', :visible => false).set(filepath)
      click_button "Import"
      expect(page).to have_content(Spree.t('notice_messages.import_success'))
    end

  end

end
