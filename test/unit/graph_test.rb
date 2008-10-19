require 'test_helper'

class GraphTest < ActiveSupport::TestCase

  setup do
    ActiveRecord::Base.connection.execute "drop database rbdb_test4" rescue nil
    Datab.create :name => 'rbdb_test4'
    ActiveRecord::Base.connection.execute "use rbdb_test4"
    ActiveRecord::Base.connection.create_table 'table1' do |t|
      t.string :email
      t.integer :another_field
      t.datetime :created_at
      t.string :language, :default => 'FR'
      t.integer :many_values
    end
    @table = Datab.find('rbdb_test4').tables.first
    1.upto 200 do |i| 
      @table.ar_class.create :another_field => (i % 4), :created_at => "10-10-2000".to_date + (i % 40).day + rand(1000).seconds, :many_values => i % 51
    end
  end

  should "not consider id, created_at, email column relevant" do
    @table = Datab.find('rbdb_test4').tables.first
    assert !Graph.is_relevant?(@table, @table.columns[0])
    assert !Graph.is_relevant?(@table, @table.columns[1])
  end
  
  should "not consider a column with all values distinct relevant" do
    @table = Datab.find('rbdb_test4').tables.first
    assert !Graph.is_relevant?(@table, @table.columns[3])
  end
  
  should "not consider a column with only one distinct value relevant" do
    @table = Datab.find('rbdb_test4').tables.first
    assert !Graph.is_relevant?(@table, @table.columns[4])
  end
  
  should "not consider render a pie with more than 50 values" do
    @table = Datab.find('rbdb_test4').tables.first
    assert_equal 50, Graph.compute(@table, @table.columns[5].name).size
  end
  
  should "get all the relevant columns of the table" do
    @table = Datab.find('rbdb_test4').tables.first
    columns = Graph.select_relevant_columns @table
    assert_equal ['another_field', 'many_values'], columns.map(&:name)
  end
  
  should "group the values to display only the 95% values and 5% of other cumulated values" do
    @table = Datab.find('rbdb_test4').tables.first
    assert true
    #assert_equal 11, Graph.arrange_values(Graph.compute(@table, @table.columns[5].name)).size
  end
  
  should "group max 5% of an array" do 
    assert_equal [[0,90],[0,4],[0,2],["Other",4]], Graph.arrange_values([[0,90],[0,4],[0,2],  [0,1],[0,1],[0,1],[0,1]])
  end
  
  should "group exactly 5% of the array" do
    assert_equal [[0,90],[0,5], ["Other",5]], Graph.arrange_values([[0,90],[0,5],  [0,1],[0,1],[0,1],[0,1],[0,1]])
  end
  
  should "generate values grouped by day for the created_at column of a table" do
    @table = Datab.find('rbdb_test4').tables.first
    assert Graph.generate_created_at @table
  end
  
  should "generate values grouped by day for the created_at column of a table and sum every day" do
    @table = Datab.find('rbdb_test4').tables.first
    assert Graph.generate_created_at @table, true
  end

end
