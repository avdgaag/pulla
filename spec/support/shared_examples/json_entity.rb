shared_examples_for 'JsonEntity' do
  context 'with two objects with equal attributes' do
    let(:object_a) { described_class.new(foo: 'bar') }
    let(:object_b) { described_class.new(foo: 'bar') }

    it 'considers two objects with same attributes equal' do
      expect(object_a).to eql(object_b)
    end

    it 'are considered equal as Hash keys' do
      hash = {}
      hash[object_a] = true
      expect(hash[object_b]).to be_true
    end
  end

  it 'can not be modified' do
    expect(described_class.new(foo: 'bar')).to be_frozen
  end

  describe 'property definitions' do
    before(:all) do
      @original_methods = described_class.instance_methods
    end

    before do
      (described_class.instance_methods - @original_methods).each do |new_method|
        described_class.send :remove_method, new_method
      end
    end

    it 'creates simple string properties' do
      described_class.property :foo
      obj = described_class.new('foo' => 'bar')
      expect(obj.foo).to eql('bar')
    end

    it 'creates string properties from a custom location' do
      described_class.property :foo, at: 'bla'
      obj = described_class.new('bla' => 'bar')
      expect(obj.foo).to eql('bar')
    end

    it 'creates string properties from a custom nested location' do
      described_class.property :foo, at: 'level1.bla'
      obj = described_class.new('level1' => { 'bla' => 'bar' })
      expect(obj.foo).to eql('bar')
    end

    it 'creates array properties from array values' do
      described_class.property :foo, Array, at: 'keys.foo'
      obj = described_class.new('keys' => [{ 'foo' => 'bar' }, { 'foo' => 'baz' }])
      expect(obj.foo).to eql(%w[bar baz])
    end

    it 'creates a time property by use Time.parse' do
      described_class.property :foo, Time
      obj = described_class.new('foo' => '2014-12-03 11:34')
      expect(obj.foo).to eql(Time.new(2014, 12, 3, 11, 34))
    end

    it 'creates boolean predicate methods for properties ending in a question mark' do
      described_class.property :foo?
      described_class.property :bar?
      obj = described_class.new('foo' => 'true', 'bar' => '123')
      expect(obj.foo?).to be_true
      expect(obj.bar?).to be_false
    end

    it 'creates a property using a conversion function' do
      described_class.property :foo, Integer
      obj = described_class.new('foo' => '12')
      expect(obj.foo).to eql(12)
    end

    it 'creates a property using a constructor function' do
      custom_class = double
      expect(custom_class).to receive(:new).with('12').and_return(:custom_class_object)
      stub_const('CustomClass', custom_class)
      described_class.property :foo, CustomClass
      obj = described_class.new('foo' => '12')
      expect(obj.foo).to eql(:custom_class_object)
    end
  end
end
