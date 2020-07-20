RSpec.describe Metaconfig::Loaders::HashLoader do
  subject do
    Metaconfig::Loaders::HashLoader.new({
        foo: 'bar',
        bar: {
            baz: 3
        }
    })
  end

  context 'defined key' do
    it 'should return value for root setting' do
      expect(subject.read([:foo])).to eq 'bar'
    end

    it 'should return value for nested setting' do
      expect(subject.read([:bar, :baz])).to eq 3
    end
  end

  context 'undefined key' do
    it 'should raise exception for undefined root key' do
      expect { subject.read([:not_exist]) }.to raise_error(KeyError) do |error|
        expect(error.receiver).to eq subject
        expect(error.key).to eq [:not_exist]
      end
    end

    it 'should raise exception for undefined nested key' do
      expect { subject.read([:bar, :not_exist]) }.to raise_error(KeyError) do |error|
        expect(error.receiver).to eq subject
        expect(error.key).to eq [:bar, :not_exist]
      end
    end
  end
end