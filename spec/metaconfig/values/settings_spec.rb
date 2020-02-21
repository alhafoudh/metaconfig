RSpec.describe Metaconfig::Values::Settings do
  context '#build_from' do
    let!(:parent_class) do
      Class.new
    end

    let(:setting1) do
      Metaconfig::Definition::Setting.new(:setting1, :string)
    end

    let(:setting2) do
      Metaconfig::Definition::Setting.new(:setting2, :string)
    end

    let(:section1) do
      Metaconfig::Definition::Section.new(:section1, settings: [setting1, setting2])
    end

    let(:definition) do
      Metaconfig::Definition::Section.new(
          :foo,
          settings: [
              setting1,
          ],
          sections: [
              section1
          ]
      )
    end

    subject do
      Metaconfig::Values::Settings.build_from(definition, parent_class)
    end

    it 'should build settings' do
      expect(subject.setting1).to eq nil
    end

    it 'should build sections' do
      expect(subject.section1.setting2).to eq nil
    end

    it 'should create new class on parent class' do
      expect(parent_class.const_defined?(:FooSettings)).to eq false
      subject
      expect(parent_class.const_defined?(:FooSettings)).to eq true
    end
  end
end