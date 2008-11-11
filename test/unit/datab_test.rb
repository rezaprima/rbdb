require File.dirname(__FILE__) + '/../test_helper'

class DatabTest < ActiveSupport::TestCase
  
  def setup
    super
    create_database 'rbdb_test1'
    create_database 'rbdb_test2'
    create_database 'rbdb_test3' do |datab|
      datab.create_table 'table1' do |t|
        t.integer :field1
      end
      datab.create_table 'table2' do |t|
        t.string :field1
      end
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
