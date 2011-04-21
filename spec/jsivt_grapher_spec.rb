require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


module JGSpecH
    NodesWithParentsAndData  = {
      :a => {:id => :a, :parents => [:aa], :data => "A", :other_stuff => "_A_"},
      #b,c have no parents
      :b => {:id => :b, :data => "B", :other_stuff => "_B_"},
      :c => {:id => :c, :data => "C", :other_stuff => "_C_"},
      :aa => {:id => :aa, :parents => [:a], :data => "AA", :other_stuff => "_AA_"},
      :ab => {:id => :ab, :parents => [:a, :bb, :aaa], :data => "AB", :other_stuff => "_AB_"},
      :ac => {:id => :ac, :parents => [:a], :data => "AC", :other_stuff => "_AC_"},
      :ba => {:id => :ba, :parents => [:b, :ab], :data => "BA", :other_stuff => "_BA_"},
      :bb => {:id => :bb, :parents => [:b], :data => "BB", :other_stuff => "_BB_"},
      :bc => {:id => :bc, :parents => [:b, :bbb], :data => "BC", :other_stuff => "_BC_"},
      :cc => {:id => :cc, :parents => [:c], :data => "CC", :other_stuff => "_CC_"},
      :aaa => {:id => :aaa, :parents => [:aa], :data => "AAA", :other_stuff => "_AAA_"},
      :bbb => {:id => :bbb, :parents => [:bb, :aaa], :data => "BBB", :other_stuff => "_BBB_"},
      :bcc => {:id => :bcc, :parents => [:bc], :data => "BCC", :other_stuff => "_BCC_"}
    }
   NodesWithChildren = {:a => {:children => [:aa, :ab, :ac]},
                      :b => {:children => [:ba, :bb, :bc]},
                      :c => {:children => [:cc]},
                      :aa => {:children => [:a, :aaa]},
                      :ab => {:children => [:ba]},
                      :ac => {:children => []},
                      :ba => {:children => []},
                      :bb => {:children => [:ab, :bbb]},
                      :bc => {:children => [:bcc]},
                      :cc => {:children => []},
                      :aaa => {:children => [:ab, :bbb]},
                      :bbb => {:children => [:bc]},
                      :bcc => {:children => []}
   }

  Nodes = NodesWithParentsAndData.merge(NodesWithChildren){|k,v1,v2| v1.merge(v2)}
end


shared_examples_for "initialize" do
  @nodes = JGSpecH::Nodes
  @name_key = :id
  @children_key = :children

  it "initializes" do
    jg.should be_a JsivtGrapher
  end
end

shared_examples_for "to adjacency list" do
  @nodes = JGSpecH::Nodes
  @name_key = :id
  @chidren_key = :children

  it "has list" do
    jg.to_adj.should == :foo
  end
end


describe "JsivtGrapher with default key for data" do
  it_behaves_like "initialize" do
    normal_data_struc = {:name_key => @name_key, :children_key => @children_key}
    jg = JsivtGrapher.new(@nodes, normal_data_struc)
    let(:jg) { jg }
  end
end

describe "JsivtGrapher with cusomizing key for data" do
  it_behaves_like "initialize" do
    diff_data_struc = {:name_key => @name_key, :children_key => @children_key, :data_key => :other_stuff}
    jg = JsivtGrapher.new(@nodes, diff_data_struc)
    let(:jg) {jg}
  end
end

describe "Making adjacency with default key for data" do
  before(:each) do
    @nodes = JGSpecH::Nodes
  end

  it "returns data in jsivt adjacency format" do
    #sorry for my ugly mess, not my format
    #validated that original graph and output graph matched with this data
    expected_result = JSON.parse("[{\"id\":\"a\",\"name\":\"id: a\",\"data\":{\"id\":\"a\",\"parents\":[\"aa\"],\"data\":\"A\",\"other_stuff\":\"_A_\",\"children\":[\"aa\",\"ab\",\"ac\"]},\"adjacencies\":[\"aa\",\"ab\",\"ac\"]},{\"id\":\"b\",\"name\":\"id: b\",\"data\":{\"id\":\"b\",\"data\":\"B\",\"other_stuff\":\"_B_\",\"children\":[\"ba\",\"bb\",\"bc\"]},\"adjacencies\":[\"ba\",\"bb\",\"bc\"]},{\"id\":\"c\",\"name\":\"id: c\",\"data\":{\"id\":\"c\",\"data\":\"C\",\"other_stuff\":\"_C_\",\"children\":[\"cc\"]},\"adjacencies\":[\"cc\"]},{\"id\":\"aa\",\"name\":\"id: aa\",\"data\":{\"id\":\"aa\",\"parents\":[\"a\"],\"data\":\"AA\",\"other_stuff\":\"_AA_\",\"children\":[\"a\",\"aaa\"]},\"adjacencies\":[\"a\",\"aaa\"]},{\"id\":\"ab\",\"name\":\"id: ab\",\"data\":{\"id\":\"ab\",\"parents\":[\"a\",\"bb\",\"aaa\"],\"data\":\"AB\",\"other_stuff\":\"_AB_\",\"children\":[\"ba\"]},\"adjacencies\":[\"ba\"]},{\"id\":\"ac\",\"name\":\"id: ac\",\"data\":{\"id\":\"ac\",\"parents\":[\"a\"],\"data\":\"AC\",\"other_stuff\":\"_AC_\",\"children\":[]},\"adjacencies\":[]},{\"id\":\"ba\",\"name\":\"id: ba\",\"data\":{\"id\":\"ba\",\"parents\":[\"b\",\"ab\"],\"data\":\"BA\",\"other_stuff\":\"_BA_\",\"children\":[]},\"adjacencies\":[]},{\"id\":\"bb\",\"name\":\"id: bb\",\"data\":{\"id\":\"bb\",\"parents\":[\"b\"],\"data\":\"BB\",\"other_stuff\":\"_BB_\",\"children\":[\"ab\",\"bbb\"]},\"adjacencies\":[\"ab\",\"bbb\"]},{\"id\":\"bc\",\"name\":\"id: bc\",\"data\":{\"id\":\"bc\",\"parents\":[\"b\",\"bbb\"],\"data\":\"BC\",\"other_stuff\":\"_BC_\",\"children\":[\"bcc\"]},\"adjacencies\":[\"bcc\"]},{\"id\":\"cc\",\"name\":\"id: cc\",\"data\":{\"id\":\"cc\",\"parents\":[\"c\"],\"data\":\"CC\",\"other_stuff\":\"_CC_\",\"children\":[]},\"adjacencies\":[]},{\"id\":\"aaa\",\"name\":\"id: aaa\",\"data\":{\"id\":\"aaa\",\"parents\":[\"aa\"],\"data\":\"AAA\",\"other_stuff\":\"_AAA_\",\"children\":[\"ab\",\"bbb\"]},\"adjacencies\":[\"ab\",\"bbb\"]},{\"id\":\"bbb\",\"name\":\"id: bbb\",\"data\":{\"id\":\"bbb\",\"parents\":[\"bb\",\"aaa\"],\"data\":\"BBB\",\"other_stuff\":\"_BBB_\",\"children\":[\"bc\"]},\"adjacencies\":[\"bc\"]},{\"id\":\"bcc\",\"name\":\"id: bcc\",\"data\":{\"id\":\"bcc\",\"parents\":[\"bc\"],\"data\":\"BCC\",\"other_stuff\":\"_BCC_\",\"children\":[]},\"adjacencies\":[]}]")

    jg = JsivtGrapher.new(@nodes)
    jg_adj = JSON.parse(jg.to_adj)
    jg_adj.should == expected_result  #to_adj returns a json string
  end

  it "returns data in jsivt tree format (to depth)" do
    #not my format, data verified
    expected_result = JSON.parse("{\"id\":\"aa\",\"name\":\"id: aa\",\"data\":{\"id\":\"aa\",\"parents\":[\"a\"],\"data\":\"AA\",\"other_stuff\":\"_AA_\",\"children\":[\"a\",\"aaa\"]},\"children\":[{\"id\":\"a\",\"name\":\"id: a\",\"data\":{\"id\":\"a\",\"parents\":[\"aa\"],\"data\":\"A\",\"other_stuff\":\"_A_\",\"children\":[\"aa\",\"ab\",\"ac\"]},\"children\":[{\"id\":\"aa\",\"name\":\"id: aa\",\"data\":{\"id\":\"aa\",\"parents\":[\"a\"],\"data\":\"AA\",\"other_stuff\":\"_AA_\",\"children\":[\"a\",\"aaa\"]},\"children\":[{\"id\":\"a\",\"name\":\"id: a\",\"data\":{\"id\":\"a\",\"parents\":[\"aa\"],\"data\":\"A\",\"other_stuff\":\"_A_\",\"children\":[\"aa\",\"ab\",\"ac\"]},\"children\":[{\"id\":\"aa\",\"name\":\"id: aa\",\"data\":{\"id\":\"aa\",\"parents\":[\"a\"],\"data\":\"AA\",\"other_stuff\":\"_AA_\",\"children\":[\"a\",\"aaa\"]},\"children\":[{\"id\":\"a\",\"name\":\"id: a\",\"data\":{\"id\":\"a\",\"parents\":[\"aa\"],\"data\":\"A\",\"other_stuff\":\"_A_\",\"children\":[\"aa\",\"ab\",\"ac\"]},\"children\":[]},{\"id\":\"aaa\",\"name\":\"id: aaa\",\"data\":{\"id\":\"aaa\",\"parents\":[\"aa\"],\"data\":\"AAA\",\"other_stuff\":\"_AAA_\",\"children\":[\"ab\",\"bbb\"]},\"children\":[]}]},{\"id\":\"ab\",\"name\":\"id: ab\",\"data\":{\"id\":\"ab\",\"parents\":[\"a\",\"bb\",\"aaa\"],\"data\":\"AB\",\"other_stuff\":\"_AB_\",\"children\":[\"ba\"]},\"children\":[{\"id\":\"ba\",\"name\":\"id: ba\",\"data\":{\"id\":\"ba\",\"parents\":[\"b\",\"ab\"],\"data\":\"BA\",\"other_stuff\":\"_BA_\",\"children\":[]},\"children\":[]}]},{\"id\":\"ac\",\"name\":\"id: ac\",\"data\":{\"id\":\"ac\",\"parents\":[\"a\"],\"data\":\"AC\",\"other_stuff\":\"_AC_\",\"children\":[]},\"children\":[]}]},{\"id\":\"aaa\",\"name\":\"id: aaa\",\"data\":{\"id\":\"aaa\",\"parents\":[\"aa\"],\"data\":\"AAA\",\"other_stuff\":\"_AAA_\",\"children\":[\"ab\",\"bbb\"]},\"children\":[{\"id\":\"ab\",\"name\":\"id: ab\",\"data\":{\"id\":\"ab\",\"parents\":[\"a\",\"bb\",\"aaa\"],\"data\":\"AB\",\"other_stuff\":\"_AB_\",\"children\":[\"ba\"]},\"children\":[{\"id\":\"ba\",\"name\":\"id: ba\",\"data\":{\"id\":\"ba\",\"parents\":[\"b\",\"ab\"],\"data\":\"BA\",\"other_stuff\":\"_BA_\",\"children\":[]},\"children\":[]}]},{\"id\":\"bbb\",\"name\":\"id: bbb\",\"data\":{\"id\":\"bbb\",\"parents\":[\"bb\",\"aaa\"],\"data\":\"BBB\",\"other_stuff\":\"_BBB_\",\"children\":[\"bc\"]},\"children\":[{\"id\":\"bc\",\"name\":\"id: bc\",\"data\":{\"id\":\"bc\",\"parents\":[\"b\",\"bbb\"],\"data\":\"BC\",\"other_stuff\":\"_BC_\",\"children\":[\"bcc\"]},\"children\":[]}]}]}]},{\"id\":\"ab\",\"name\":\"id: ab\",\"data\":{\"id\":\"ab\",\"parents\":[\"a\",\"bb\",\"aaa\"],\"data\":\"AB\",\"other_stuff\":\"_AB_\",\"children\":[\"ba\"]},\"children\":[{\"id\":\"ba\",\"name\":\"id: ba\",\"data\":{\"id\":\"ba\",\"parents\":[\"b\",\"ab\"],\"data\":\"BA\",\"other_stuff\":\"_BA_\",\"children\":[]},\"children\":[]}]},{\"id\":\"ac\",\"name\":\"id: ac\",\"data\":{\"id\":\"ac\",\"parents\":[\"a\"],\"data\":\"AC\",\"other_stuff\":\"_AC_\",\"children\":[]},\"children\":[]}]},{\"id\":\"aaa\",\"name\":\"id: aaa\",\"data\":{\"id\":\"aaa\",\"parents\":[\"aa\"],\"data\":\"AAA\",\"other_stuff\":\"_AAA_\",\"children\":[\"ab\",\"bbb\"]},\"children\":[{\"id\":\"ab\",\"name\":\"id: ab\",\"data\":{\"id\":\"ab\",\"parents\":[\"a\",\"bb\",\"aaa\"],\"data\":\"AB\",\"other_stuff\":\"_AB_\",\"children\":[\"ba\"]},\"children\":[{\"id\":\"ba\",\"name\":\"id: ba\",\"data\":{\"id\":\"ba\",\"parents\":[\"b\",\"ab\"],\"data\":\"BA\",\"other_stuff\":\"_BA_\",\"children\":[]},\"children\":[]}]},{\"id\":\"bbb\",\"name\":\"id: bbb\",\"data\":{\"id\":\"bbb\",\"parents\":[\"bb\",\"aaa\"],\"data\":\"BBB\",\"other_stuff\":\"_BBB_\",\"children\":[\"bc\"]},\"children\":[{\"id\":\"bc\",\"name\":\"id: bc\",\"data\":{\"id\":\"bc\",\"parents\":[\"b\",\"bbb\"],\"data\":\"BC\",\"other_stuff\":\"_BC_\",\"children\":[\"bcc\"]},\"children\":[{\"id\":\"bcc\",\"name\":\"id: bcc\",\"data\":{\"id\":\"bcc\",\"parents\":[\"bc\"],\"data\":\"BCC\",\"other_stuff\":\"_BCC_\",\"children\":[]},\"children\":[]}]}]}]}]}")
    
    jg = JsivtGrapher.new(@nodes)
    #a depth of 5 should fully traverse and include loops
    root_node = :aa
    depth = 5
    tree_json_str = jg.to_tree(root_node, depth)
    jg_tree = JSON.parse(tree_json_str)
    jg_tree.should == expected_result
  end
    
end
