RSpec.describe Metaconfig::Definition::Setting do
  let(:name) { instance_double(Symbol) }
  let(:type) { instance_double(Symbol) }
  let(:loader) { instance_double(Metaconfig::Loaders::BaseLoader) }
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

  context 'loader' do
    subject do
      Metaconfig::Definition::Setting.new(:foo, type, loader: loader)
    end

    it 'should reads value from loader' do
      expect(subject.loader).to receive(:read).with([:foo]).and_return('bar')
      expect(subject.value).to eq 'bar'
    end

    context 'not required value' do
      subject do
        Metaconfig::Definition::Setting.new(:foo, type, loader: loader)
      end

      it 'should handles non-existing value from loader' do
        expect(loader).to receive(:read).with([:foo]).and_raise(Metaconfig::Loaders::Errors::MissingKeyValueError, receiver: loader, key: [:foo])
        expect(subject.value).to be_nil
      end
    end

    context 'required value' do
      subject do
        Metaconfig::Definition::Setting.new(:foo, type, loader: loader, required: true)
      end

      it 'should handles non-existing value from loader' do
        expect(loader).to receive(:read).with([:foo]).and_raise(Metaconfig::Loaders::Errors::MissingKeyValueError, receiver: loader, key: [:foo])
        expect { subject.value }.to raise_error(Metaconfig::Errors::MissingSettingValueError) do |error|
          expect(error.receiver).to eq subject
          expect(error.key).to eq [:foo]
        end
      end
    end
  end

  context 'default value' do
    context 'with default value defined' do
      subject do
        Metaconfig::Definition::Setting.new(:foo, type, loader: loader, default: 123)
      end

      it 'should fall back to default value' do
        expect(loader).to receive(:read).with([:foo]).and_raise(Metaconfig::Loaders::Errors::MissingKeyValueError, receiver: loader, key: [:foo])
        expect(subject.value).to eq 123
      end
    end

    context 'without default value defined' do
      subject do
        Metaconfig::Definition::Setting.new(:foo, type, loader: loader)
      end

      it 'should fall back to default value' do
        expect(loader).to receive(:read).with([:foo]).and_raise(Metaconfig::Loaders::Errors::MissingKeyValueError, receiver: loader, key: [:foo])
        expect(subject.value).to be_nil
      end
    end
  end
end