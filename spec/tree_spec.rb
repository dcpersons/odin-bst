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

    it 'does not change the tree if given value already exists' do
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

    it 'does nothing if given value is not in tree' do
      before = []
      after = []
      before = tree.level_order { |n| before << n }
      tree.delete(69)
      after = tree.level_order { |n| after << n }
      expect(before).to eq(after)
    end
  end

  describe '#level_order' do
    it 'accepts a block that it yields to every element, breadth-first' do
      result = []
      tree.level_order { |n| result << n }
      expect(result).to eq([4, 2, 74, 1, 3, 5, 86])
    end

    it 'returns itself if a block is given' do
      expect(tree.level_order {}).to eq(tree)
    end

    it 'returns an enumerator if no block is given' do
      expect(tree.level_order).to be_a Enumerator
    end
  end
end
