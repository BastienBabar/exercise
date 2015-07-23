class CreateGroupevents < ActiveRecord::Migration
  def change
    create_table :groupevents do |t|
      t.date :startdate
      t.date :enddate
      t.string :name
      t.text :description
      t.string :location
      t.integer :status

      t.timestamps
    end
  end
end
