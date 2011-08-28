require 'json'

class JsivtGrapher
  def initialize(jit_nodes, structure = {})
    #unclear if digraph is needed, doesn't seem to be needed yet
    #but i think it may be for some yet to be dtermined operations
    #@dg = rgl_digraph
    @name_key = structure[:name_key] || :label
    @children_key = structure[:children] || :children
    @data_key = structure[:data] || :data
    jit_keys = [@name_key, @children_key, @data_key] 
    @nodes = {}
    jit_nodes.each do |id,full_data|
      jit_data = full_data.select{|k,v| jit_keys.include? k}
      @nodes[id] = jit_data
      @nodes[id][:data] = full_data || "no data"#repeats jit data, but that's ok
    end
    #ok puts "2"; p @nodes['tags'][:data]; STOPHERE

  end
    
  #nodelist identifying children
  #self must be a graph type
  def to_adj
    full_jsivt= []
    @nodes.each do |id, node_data|
      name = node_data[@name_key]
      data = node_data[:data]
      adjacencies = node_data[@children_key]
      jsivt = {}
      jsivt["id"] = id
      jsivt["name"] = name || "id: #{id}" #if no name show id
      jsivt["data"] = data
      jsivt["adjacencies"] = adjacencies
      full_jsivt << jsivt
    end  
    full_jsivt.to_json  
  end
  
  def to_tree(top_node, depth)
    
    puts 'jsivt'
    p @nodes
    p top_node
    p @nodes[top_node]
    #raise "Can't find node: #{top_node.inspect} in the tree" unless @nodes[top_node] 
    return {}.to_json unless @nodes[top_node]
    #puts "Tree Init, top node data: #{@nodes[top_node].inspect}"
    tree = jsivt_tree(top_node, depth)
    tree.to_json
  end
  
  def jsivt_tree(node_id, depth)
    return nil if depth < 0
    jsivt = {}
    
    jsivt['id'] = node_id
    jsivt['name'] = @nodes[node_id][@name_key] || "id: #{node_id}" #use id if no name exists
    jsivt['data'] = @nodes[node_id][:data]
    jsivt['children'] = @nodes[node_id][@children_key].map{|ch|
      jsivt_tree(ch, depth-1)}.compact
    #puts "current depth: #{depth}"
    #puts "End of tree recurs"
    jsivt
  end

end
