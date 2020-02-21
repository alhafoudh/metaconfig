RSpec.describe Metaconfig::Definition::Section do
  let(:name) { instance_double(Symbol) }
  let(:settings) { [instance_double(Metaconfig::Definition::Setting)] }
  let(:sections) { [instance_double(Metaconfig::Definition::Section)] }
  let(:loader) { double }
  let(:options) { { foo: double } }

  context 'without name' do
    subject do
      Metaconfig::Definition::Section.new
    end

    it 'should initialize with default name' do
      expect(subject.name).to eq :root
    end
  end

  context 'initialize directly' do
    subject do
      Metaconfig::Definition::Section.new(name, settings: settings, sections: sections, loader: loader, **options)
    end

    it 'should have name' do
      expect(subject.name).to eq name
    end

    it 'should have settings' do
      expect(subject.settings).to eq settings
    end

    it 'should have sections' do
      expect(subject.sections).to eq sections
    end

    it 'should have loader' do
      expect(subject.loader).to eq loader
    end

    it 'should have options' do
      expect(subject.options).to eq options
    end
  end

  context 'initialize by block' do
    subject do
      Metaconfig::Definition::Section.new(name) do
        setting :foo, :bar, loader: :some_loader, baz: :jam

        section :bar, loader: :some_loader, foo: :baz
      end
    end

    context 'settings' do
      it 'should have one setting' do
        expect(subject.settings.size).to eq 1
      end

      it 'should have name' do
        expect(subject.settings[0].name).to eq :foo
      end

      it 'should have type' do
        expect(subject.settings[0].type).to eq :bar
      end

      it 'should have loader' do
        expect(subject.settings[0].loader).to eq :some_loader
      end

      it 'should have options' do
        expect(subject.settings[0].options).to eq({ baz: :jam })
      end
    end

    context 'sections' do
      it 'should have one section' do
        expect(subject.sections.size).to eq 1
      end

      it 'should have name' do
        expect(subject.sections[0].name).to eq :bar
      end

      it 'should have loader' do
        expect(subject.sections[0].loader).to eq :some_loader
      end

      it 'should have options' do
        expect(subject.sections[0].options).to eq({ foo: :baz })
      end
    end
  end

  context '#assign_default_loaders' do
    subject do
      Metaconfig::Definition::Section.new(name, loader: :parent_loader) do
        setting :foo
        setting :bar, loader: :some_loader

        section :baz
        section :jam, loader: :other_loader
      end.tap do |section|
        section.assign_default_loaders
      end
    end

    it 'should assign default loaders to settings' do
      expect(subject.settings[0].loader).to eq :parent_loader
      expect(subject.settings[1].loader).to eq :some_loader
    end

    it 'should assign default loaders to sections' do
      expect(subject.sections[0].loader).to eq :parent_loader
      expect(subject.sections[1].loader).to eq :other_loader
    end
  end
end