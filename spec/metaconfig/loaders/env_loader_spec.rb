RSpec.describe Metaconfig::Loaders::EnvLoader do
  subject do
    Metaconfig::Loaders::EnvLoader.new({
        'FOO' => 'abc',
        'BAR_BAZ' => 'def',
        'SOMETHING_VERY_DEEPLY_NESTED' => 'xxx'
    })
  end

  context 'defined key' do
    it 'should return value for root setting' do
      expect(subject.read([:foo])).to eq 'abc'
    end

    it 'should return value for nested setting' do
      expect(subject.read([:bar, :baz])).to eq 'def'
    end

    it 'should return value for nested setting with underscores in name' do
      expect(subject.read([:something, :very_deeply, :nested])).to eq 'xxx'
    end
  end

  context 'undefined key' do
    it 'should raise exception for undefined root key' do
      expect { subject.read([:notexist]) }.to raise_error(KeyError) do |error|
        expect(error.receiver).to eq subject
        expect(error.key).to eq 'NOTEXIST'
      end
    end

    it 'should raise exception for undefined nested key' do
      expect { subject.read([:bar, :notexist]) }.to raise_error(KeyError) do |error|
        expect(error.receiver).to eq subject
        expect(error.key).to eq 'BAR_NOTEXIST'
      end
    end
  end
end