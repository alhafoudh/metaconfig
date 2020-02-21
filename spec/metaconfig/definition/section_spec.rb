RSpec.describe Metaconfig::Definition::Section do
  let(:name) { instance_double(Symbol) }
  let(:options) { { foo: double } }
  let(:settings) { [instance_double(Metaconfig::Definition::Setting)] }
  let(:sections) { [instance_double(Metaconfig::Definition::Section)] }

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
      Metaconfig::Definition::Section.new(name, settings: settings, sections: sections, **options)
    end

    it 'should have name' do
      expect(subject.name).to eq name
    end

    it 'should have options' do
      expect(subject.options).to eq options
    end

    it 'should have settings' do
      expect(subject.settings).to eq settings
    end

    it 'should have sections' do
      expect(subject.sections).to eq sections
    end
  end

  context 'initialize by block' do
    subject do
      Metaconfig::Definition::Section.new(name) do
        setting :foo, :bar, baz: :jam

        section :bar, foo: :baz
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

      it 'should have options' do
        expect(subject.sections[0].options).to eq({ foo: :baz })
      end
    end
  end
end