class ChangeDefaultValueScoreToGame < ActiveRecord::Migration
  def self.up
  	change_column :games, :score, :integer, :default => 0
  end

  def self.down
  	change_column_default(:games, :score, nil)
  end

end
