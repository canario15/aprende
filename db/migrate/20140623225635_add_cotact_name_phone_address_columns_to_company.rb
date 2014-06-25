class AddCotactNamePhoneAddressColumnsToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :contact_name, :string
    add_column :companies, :phone, :string
    add_column :companies, :address, :string
  end
end
