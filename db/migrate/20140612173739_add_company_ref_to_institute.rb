class AddCompanyRefToInstitute < ActiveRecord::Migration
  def change
    add_reference :institutes, :company, index: true
  end
end
