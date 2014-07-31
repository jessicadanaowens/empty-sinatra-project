class CreatePhotos < ActiveRecord::Migration
  def up
    create_table :photos do |t|
      t.references :user
      t.string :filename
      t.string :tempfile
    end
  end

  def down
    # add reverse migration code here
  end
end
