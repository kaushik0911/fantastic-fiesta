class CreateOwners < ActiveRecord::Migration[8.0]
  def change
    create_table :owners do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone

      t.timestamps
    end
  end
end
