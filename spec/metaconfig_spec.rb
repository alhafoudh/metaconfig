RSpec.describe Metaconfig do
  it 'has a version number' do
    expect(Metaconfig::VERSION).not_to be nil
  end

  context '#configure' do
    let(:default_loader) do
      Metaconfig::Loaders::HashLoader.new({})
    end

    let(:other_loader) do
      Metaconfig::Loaders::HashLoader.new({})
    end

    let(:another_loader) do
      Metaconfig::Loaders::HashLoader.new({})
    end

    subject do
      the_default_loader = default_loader
      the_other_loader = other_loader
      the_another_loader = another_loader

      Metaconfig.configure do
        default_loader the_default_loader

        loader :other_loader, the_other_loader
        loader :another_loader, the_another_loader
      end
      Metaconfig.config
    end

    it 'should sets up default loader' do
      expect(subject.default_loader).to eq default_loader
    end

    it 'should sets up loaders' do
      expect(subject.loaders[:other_loader]).to eq other_loader
      expect(subject.loaders[:another_loader]).to eq another_loader
    end
  end

  context '#define' do
    let(:definition) do
      Metaconfig.define do
        setting :secret_key_base, :string, required: true
        setting :postmark_api_token, :string
        section :mail do
          setting :from, :email, required: true
          setting :override_to, :email
        end
      end
    end

    it 'should have name' do
      expect(definition.name).to eq :root
    end

    context 'secret_key_base setting' do
      let(:setting) do
        definition.settings[0]
      end

      it 'should exist' do
        expect(setting).not_to be_nil
      end

      it 'should have name' do
        expect(setting.name).to eq :secret_key_base
      end

      it 'should be of type string' do
        expect(setting.type).to eq :string
      end

      it 'should be required' do
        expect(setting.required).to eq true
      end
    end

    context 'postmark_api_token setting' do
      let(:setting) do
        definition.settings[1]
      end

      it 'should exist' do
        expect(setting).not_to be_nil
      end

      it 'should have name' do
        expect(setting.name).to eq :postmark_api_token
      end

      it 'should be of type string' do
        expect(setting.type).to eq :string
      end
    end

    context 'mail section' do
      let(:section) do
        definition.sections[0]
      end

      it 'should exist' do
        expect(section).not_to be_nil
      end

      it 'should have name' do
        expect(section.name).to eq :mail
      end

      context 'from setting' do
        let(:setting) do
          section.settings[0]
        end

        it 'should exist' do
          expect(setting).not_to be_nil
        end

        it 'should have name' do
          expect(setting.name).to eq :from
        end

        it 'should be of type email' do
          expect(setting.type).to eq :email
        end

        it 'should be required by proc' do
          expect(setting.required).to eq true
        end
      end

      context 'override_to setting' do
        let(:setting) do
          section.settings[1]
        end

        it 'should exist' do
          expect(setting).not_to be_nil
        end

        it 'should have name' do
          expect(setting.name).to eq :override_to
        end

        it 'should be of type email' do
          expect(setting.type).to eq :email
        end

        it 'should not be required by default' do
          expect(setting.required).to eq false
        end
      end
    end
  end

  context 'access settings' do
    before(:each) do
      data = {
          secret_key_base: 'xxx',
          mail: {
              from: 'yyy'
          }
      }

      Metaconfig.configure do
        default_loader Metaconfig::Loaders::HashLoader.new(data)
      end

      Metaconfig.define do
        setting :secret_key_base, :string, required: true
        setting :postmark_api_token, :string
        section :mail do
          setting :from, :email, required: true
          setting :override_to, :email
        end
      end
    end

    context 'root setting' do
      let(:value) do
        Metaconfig.secret_key_base
      end

      it 'should be accessible' do
        expect(value).to eq 'xxx'
      end
    end

    context 'nested setting' do
      let(:value) do
        Metaconfig.mail.from
      end

      it 'should be accessible' do
        expect(value).to eq 'yyy'
      end
    end

    context '#to_h' do
      subject do
        Metaconfig
      end

      it 'should be able to be converted to hash' do
        expected = a_hash_including(
            secret_key_base: anything,
            postmark_api_token: anything,
            mail: a_hash_including(
                from: anything,
                override_to: anything
            )
        )
        expect(subject.to_h).to expected
      end
    end
  end
end