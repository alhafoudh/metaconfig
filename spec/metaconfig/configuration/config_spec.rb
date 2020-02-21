RSpec.describe Metaconfig::Configuration::Config do
  let(:default_loader) { instance_double(Symbol) }
  let(:loaders) { { instance_double(Symbol) => double } }

  subject do
    Metaconfig::Configuration::Config.new(default_loader, loaders)
  end

  it 'should have default_loader' do
    expect(subject.default_loader).to eq default_loader
  end

  it 'should have loaders' do
    expect(subject.loaders).to eq loaders
  end
end