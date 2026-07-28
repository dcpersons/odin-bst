# frozen_string_literal: true

require_relative '../lib/tree'

describe Tree do
  subject(:tree) { described_class.new([5, 1, 3, 74, 2, 86, 4]) }

  describe '#include?' do
    it 'returns true if given value is in the tree' do
      expect(tree.include?(5)).to be true
    end

    it 'returns false if given value is not in the tree' do
      expect(tree.include?(69)).to be false
    end
  end

  describe '#insert' do
    it 'adds value to the tree if it does not already exist' do
      tree.insert(69)
      expect(tree.include?(69)).to be true
    end

    it 'does not change the tree if given value already exists' do # rubocop:disable RSpec/ExampleLength
      before = []
      after = []
      before = tree.level_order { |n| before << n }
      tree.insert(5)
      after = tree.level_order { |n| after << n }
      expect(before).to eq(after)
    end
  end

  describe '#delete' do
    it 'removes given value from the tree' do
      tree.delete(5)
      expect(tree.include?(5)).to be false
    end

    it 'does nothing if given value is not in tree' do # rubocop:disable RSpec/ExampleLength
      before = []
      after = []
      before = tree.level_order { |n| before << n }
      tree.delete(69)
      after = tree.level_order { |n| after << n }
      expect(before).to eq(after)
    end
  end

  describe '#level_order' do
    context 'when a block is given' do
      it 'yields to every element in the tree, breadth-first' do
        result = []
        tree.level_order { |n| result << n }
        expect(result).to eq([4, 2, 74, 1, 3, 5, 86])
      end

      it 'returns itself' do
        expect(tree.level_order {}).to eq(tree)
      end
    end

    context 'when no block is given' do
      it 'returns an enumerator' do
        expect(tree.level_order).to be_a Enumerator
      end

      it 'contains all elements of the tree' do
        expect(tree.level_order.to_a).to eq([4, 2, 74, 1, 3, 5, 86])
      end
    end
  end

  describe '#inorder' do
    context 'when a block is given' do
      it 'yields to every element of the tree, depth-first in-order' do
        result = []
        tree.inorder { |n| result << n }
        expect(result).to eq([1, 2, 3, 4, 5, 74, 86])
      end

      it 'returns iself' do
        expect(tree.inorder {}).to eq(tree)
      end
    end

    context 'when no block is given' do
      it 'returns an enumerator' do
        expect(tree.inorder).to be_a Enumerator
      end

      it 'contains all elements of the tree' do
        expect(tree.inorder.to_a).to eq([1, 2, 3, 4, 5, 74, 86])
      end
    end
  end

  describe '#preorder' do
    context 'when a block is given' do
      it 'yields it to every element of the tree, depth-first pre-ordered' do
        result = []
        tree.preorder { |n| result << n }
        expect(result).to eq([4, 2, 1, 3, 74, 5, 86])
      end

      it 'returns itself' do
        expect(tree.preorder {}).to eq(tree)
      end
    end

    context 'when no block is given' do
      it 'returns an enumerator' do
        expect(tree.preorder).to be_a Enumerator
      end

      it 'contains all elements of the tree' do
        expect(tree.preorder.to_a).to eq([4, 2, 1, 3, 74, 5, 86])
      end
    end
  end

  describe '#postorder' do
    context 'when a block is given' do
      it 'yields it to every element of the tree, depth-first post-ordered' do
        result = []
        tree.postorder { |n| result << n }
        expect(result).to eq([1, 3, 2, 5, 86, 74, 4])
      end

      it 'returns itself' do
        expect(tree.postorder {}).to eq(tree)
      end
    end

    context 'when no block is given' do
      it 'returns an enumerator' do
        expect(tree.postorder).to be_a Enumerator
      end

      it 'contains all elements of the tree' do
        expect(tree.postorder.to_a).to eq([1, 3, 2, 5, 86, 74, 4])
      end
    end
  end

  describe '#height' do
    it 'accepts a value and returns the height of the node containing that value' do
      aggregate_failures do
        expect(tree.height(4)).to eq(3)
        expect(tree.height(5)).to eq(1)
      end
    end

    it 'returns the largest possible height of given node value' do
      3.times { |n| tree.insert(6 + n) }
      expect(tree.height(4)).to eq(6)
    end

    it 'returns nil if given value is not in the tree' do
      expect(tree.height(6)).to be_nil
    end

    it 'returns nil if any value is given to an empty tree' do
      contents = [5, 1, 3, 74, 2, 86, 4]
      contents.each { |n| tree.delete(n) }
      expect(tree.height(1)).to be_nil
    end
  end

  describe '#depth' do
    it 'accepts a value and returns the depth of the node containing that value' do
      expect(tree.depth(2)).to eq(1)
    end

    it 'returns nil if given value is not in the tree' do
      expect(tree.depth(6)).to be_nil
    end
  end

  describe '#balanced?' do
    it 'returns true if tree and all subtrees are the same height' do
      expect(tree.balanced?).to be true
    end

    it 'returns true if tree and all subtrees are within 1 difference in height' do
      tree.insert(6)
      expect(tree.balanced?).to be true
    end

    it 'returns false if tree is not balanced' do
      tree.insert(6)
      tree.insert(7)
      expect(tree.balanced?).to be false
    end
  end

  describe '#rebalance' do
    context 'when a tree is unbalanced' do
      it 'builds a new, balanced tree containing all elements' do
        tree.insert(6)
        tree.insert(7)
        tree.rebalance
        expect(tree.balanced?).to be true
      end
    end

    context 'when a tree is balanced' do
      it 'does nothing' do
        before = tree.preorder.to_a
        tree.rebalance
        after = tree.preorder.to_a
        expect(after).to eq(before)
      end
    end
  end
end
