require 'spec_helper'
require 'rails_generator'
require 'rails_generator/scripts/generate'

describe 'foreign_key_migration generator' do

  before(:each) do
    FileUtils.mkdir_p(fake_rails_root)
    @original_files = file_list
  end

  after(:each) do
    FileUtils.rm_r(fake_rails_root)
  end

  context "without parameters" do
    it "should generate a migration with default filename" do
      Rails::Generator::Scripts::Generate.new.run(["foreign_key_migration"], :destination => fake_rails_root)
      migration = (file_list - @original_files).first
      File.basename(migration).should include("create_foreign_keys.rb")
    end
  end

  context "with parameter" do
    it "should generate a migration with the proper filename" do
      Rails::Generator::Scripts::Generate.new.run(["foreign_key_migration", "indexes_of_foolanito"], :destination => fake_rails_root)
      migration = (file_list - @original_files).first
      File.basename(migration).should include("indexes_of_foolanito.rb")
    end
  end

  it "should generate a migration with correct content" do
    MIGRATION=<<-EOF
class CreateForeignKeys < ActiveRecord::Migration
  def self.up
    add_foreign_key "ideas", ["user_id"], "users", [:id]
    add_foreign_key "users", ["account_id"], "accounts", [:id]
  end

  def self.down
  end
end
    EOF
    Rails::Generator::Scripts::Generate.new.run(["foreign_key_migration"], :destination => fake_rails_root)
    migration = (file_list - @original_files).first
    IO.read(migration).should == MIGRATION
  end

  def fake_rails_root
    File.join(File.dirname(__FILE__), 'rails_root')
  end

  def file_list
    Dir.glob(File.join(fake_rails_root, "db/migrate/*"))
  end

end
