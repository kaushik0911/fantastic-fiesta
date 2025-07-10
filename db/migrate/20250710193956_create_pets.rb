class CreatePets < ActiveRecord::Migration[8.0]
  def change
    create_table :pets do |t|
      t.integer :pet_type, null: false
      t.integer :tracker_type, null: false
      t.integer :owner_id, null: false # not uniq, owner can have many pets

      t.boolean :in_zone, null: false, default: true
      t.boolean :lost_tracker, default: false # cats only

      t.timestamps
    end
  end
end
