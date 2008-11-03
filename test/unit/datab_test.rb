require 'test_helper'

class DatabTest < ActiveSupport::TestCase
  
  setup do
    ActiveRecord::Base.connection.execute "drop database rbdb_test1" rescue nil
    Datab.create :name => 'rbdb_test1'
    ActiveRecord::Base.connection.execute "drop database rbdb_test2" rescue nil
    Datab.create :name => 'rbdb_test2'
    ActiveRecord::Base.connection.execute "drop database rbdb_test3" rescue nil
    Datab.create :name => 'rbdb_test3'
    ActiveRecord::Base.connection.execute "use rbdb_test3"
    ActiveRecord::Base.connection.create_table 'table1' do |t|
      t.integer :field1
    end
    ActiveRecord::Base.connection.create_table 'table2' do |t|
      t.string :field1
    end
  end
  
  should "find created databases" do
    assert Datab.all.detect {|datab| datab.name == 'rbdb_test1'}, Datab.all.inspect
    assert Datab.all.detect {|datab| datab.name == 'rbdb_test2'}, Datab.all.inspect
    assert Datab.all.detect {|datab| datab.name == 'rbdb_test3'}, Datab.all.inspect
  end
  
  should "find a specific database" do
    assert_not_nil Datab.find('rbdb_test1')
    assert_nil Datab.find('does_not_exist')
  end
  
  should "list tables of an empty database" do
    assert_equal 0, Datab.find('rbdb_test1').tables.size
  end
  
  should "list tables" do
    assert_equal 2, Datab.find('rbdb_test3').tables.size
  end

end