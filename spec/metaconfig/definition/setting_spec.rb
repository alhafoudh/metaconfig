RSpec.describe Metaconfig::Definition::Setting do
  let(:name) { instance_double(Symbol) }
  let(:type) { instance_double(Symbol) }
  let(:loader) { double }
  let(:foo_option) { double }
  let(:options) { { foo: foo_option } }

  subject do
    Metaconfig::Definition::Setting.new(name, type, loader: loader, **options)
  end

  it 'should have name' do
    expect(subject.name).to eq name
  end

  it 'should have type' do
    expect(subject.type).to eq type
  end

  context 'without specifying type' do
    subject do
      Metaconfig::Definition::Setting.new(name, **options)
    end

    it 'should have default type' do
      expect(subject.type).to eq :string
    end
  end

  it 'should have loader' do
    expect(subject.loader).to eq loader
  end

  it 'should have options' do
    expect(subject.options).to eq options
  end
end