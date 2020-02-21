RSpec.describe Metaconfig::Configuration::DSL do
  let(:default_loader) { instance_double(Symbol) }
  let(:loaders) { { instance_double(Symbol) => double } }

  let(:config) do
    Metaconfig::Configuration::Config.new
  end

  subject do
    Metaconfig::Configuration::DSL.new(config) do
      default_loader :some_loader_impl

      loader :other_loader, :other_loader_impl
      loader :another_loader, :another_loader_impl
    end
  end

  it 'should configure using DSL' do
    expect(config.default_loader).to be_nil
    expect(config.loaders).to eq({})

    subject

    expect(config.default_loader).to eq :some_loader_impl
    expect(config.loaders.keys).to eq [:other_loader, :another_loader]
    expect(config.loaders[:other_loader]).to eq :other_loader_impl
    expect(config.loaders[:another_loader]).to eq :another_loader_impl
  end
end