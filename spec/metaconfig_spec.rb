RSpec.describe Metaconfig do
  it 'has a version number' do
    expect(Metaconfig::VERSION).not_to be nil
  end

  context 'with definition' do
    let!(:definition) do
      Metaconfig.define do
        setting :secret_key_base, :string, required: true
        setting :postmark_api_token, :string, required: -> { false }
        section :mail do
          setting :from, :email, required: true
          setting :override_to, :email
        end
      end
    end

    context '#define' do
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

        it 'should not be required by proc' do
          expect(setting.required).to be_a(Proc)
        end
      end

      context 'mail section' do
        let(:section) do
          definition.section[0]
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
      context 'secret_key_base setting' do
        let(:value) do
          Metaconfig.secret_key_base
        end

        it 'should be accessible' do
          value
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
end