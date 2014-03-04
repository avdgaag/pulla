shared_examples_for 'Commandable' do
  it 'records a command-line switch' do
    klass = Class.new
    klass.extend Pulla::Commandable
    obj = klass.new
    option_parser = double
    klass.desc '-f', '--foo', 'Description'
    klass.send(:define_method, :foo) {}
    expect(option_parser).to receive(:on).with('-f', '--foo', 'Description')
    klass.add_commands(option_parser, obj)
  end
end
