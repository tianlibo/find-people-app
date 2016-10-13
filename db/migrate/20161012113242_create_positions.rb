class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.belongs_to :user, index: true
      t.decimal :latitude, :precision => 9, :scale => 6
      t.decimal :longitude, :precision => 9, :scale => 6
      t.decimal :precision, :precision => 9, :scale => 6

      t.timestamps 
    end
  end
end
