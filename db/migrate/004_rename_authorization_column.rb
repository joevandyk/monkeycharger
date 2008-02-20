class RenameAuthorizationColumn < ActiveRecord::Migration
  def self.up
    rename_column :captures, :authorization, :authorization_id
  end

  def self.down
  end
end
