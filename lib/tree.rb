# frozen_string_literal: true

require_relative 'node'
# Class for creating balanced BSTs
class Tree
  def initialize(arr)
    @root = build_tree(arr.sort.uniq)
  end

  def pretty_print(node = @root, prefix = '', is_left: true)
    return unless node

    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", is_left: false)
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", is_left: true)
  end

  def include?(value, node = @root)
    return false if node.nil?
    return true if node.data == value
    return true if include?(value, value < node.data ? node.left : node.right)

    false
  end

  def insert(value, node = @root, previous = nil)
    return if value == node&.data

    if node.nil?
      if value < previous.data then previous.left = Node.new(value)
      else previous.right = Node.new(value)
      end
      return
    end
    insert(value, value < node.data ? node.left : node.right, node)
  end

  def delete(value)
    node = @root
    until node.data == value
      previous = node
      node = value < node.data ? node.left : node.right
      return nil if node.nil?
    end

    if node.left.nil? && node.right.nil? then delete_no_children(node, previous)
    elsif !node.left.nil? && !node.right.nil? then delete_two_children(node, previous)
    else delete_one_child(node, previous)
    end
  end

  # recursive version of level_order
  def level_order_recursive(queue = [@root], &block)
    return to_enum(:level_order) unless block_given?
    return self if queue.empty?

    node = queue.shift
    unless node.nil?
      queue << node.left
      queue << node.right
      yield node.data
    end
    level_order(queue, &block)
  end

  # iterative version of level_order
  def level_order
    return to_enum(:level_order) unless block_given?

    queue = [@root]
    until queue.empty?
      node = queue.shift
      next if node.nil?

      queue << node.left
      queue << node.right
      yield node.data
    end
    self
  end

  def inorder(node = @root, &block)
    return to_enum(:inorder) unless block_given?
    return self if node.nil?

    inorder(node.left, &block)
    yield node.data
    inorder(node.right, &block)
  end

  def preorder(node = @root, &block)
    return to_enum(:preorder) unless block_given?
    return self if node.nil?

    yield node.data
    preorder(node.left, &block)
    preorder(node.right, &block)
  end

  def postorder(node = @root, &block)
    return to_enum(:postorder) unless block_given?
    return if node.nil?

    postorder(node.left, &block)
    postorder(node.right, &block)
    yield node.data
    self
  end

  def height(target, node = @root, height_num = 0, target_found: false)
    until target_found
      return nil if node.nil?

      if node.data == target then target_found = true
      else node = target < node.data ? node.left : node.right
      end
    end
    return height_num if node.nil?

    [height(target, node.left, height_num + 1, target_found: true),
     height(target, node.right, height_num + 1, target_found: true)].max
  end

  def depth(target)
    node = @root
    node_depth = 0
    until node.data == target
      node = target < node.data ? node.left : node.right
      node_depth += 1
      return nil if node.nil?
    end
    node_depth
  end

  def balanced?(node = @root)
    return true if node.nil?

    left_height = node.left.nil? ? 0 : height(node.left.data)
    right_height = node.right.nil? ? 0 : height(node.right.data)
    return true if [-1, 0, 1].include?(left_height - right_height) &&
                   balanced?(node.left) &&
                   balanced?(node.right)

    false
  end

  def rebalance
    return nil if balanced?

    @root = build_tree(inorder.to_a)
  end

  private

  def delete_no_children(node, previous)
    return @root = nil if previous.nil?

    if node == previous.left
      previous.left = nil
    else
      previous.right = nil
    end
  end

  def delete_one_child(node, previous)
    return @root = node.left || node.right if previous.nil?

    if node == previous.left
      previous.left = node.left || node.right
    else
      previous.right = node.left || node.right
    end
  end

  def delete_two_children(node, previous)
    successor = fetch_successor(node.right, node)
    if node == previous&.left
      previous.left = successor
    elsif node == previous&.right
      previous.right = successor
    else
      @root = successor
    end
    successor.left = node.left
    successor.right = node.right
  end

  def fetch_successor(node, previous)
    if node.left.nil?
      previous.left = node&.right
      return node
    end
    fetch_successor(node.left, node)
  end

  def build_tree(arr)
    return if arr.empty?

    mid = arr.length / 2
    root = Node.new(arr[mid])
    root.left = build_tree(arr[0...mid])
    root.right = build_tree(arr[mid + 1..])
    root
  end
end
