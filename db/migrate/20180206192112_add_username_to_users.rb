class AddUsernameToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :username, :string
    #add_index :users, :username, unique: true
    execute("CREATE UNIQUE INDEX index_users_on_username ON users USING btree (username);")
  end

  def down
    remove_column :users, :username
    #add_index :users, :username, unique: true
    execute("DROP INDEX index_users_on_username;")
  end
end
