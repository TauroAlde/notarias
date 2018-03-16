class CreateSegmentUserImports < ActiveRecord::Migration[5.0]
  def change
    create_table :segment_user_imports do |t|

      t.timestamps
    end
  end
end
