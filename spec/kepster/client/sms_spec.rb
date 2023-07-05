require File.expand_path('../../../spec_helper', __FILE__)

RSpec.describe Kepster::Client::SMS do
  describe "#register" do
    let(:subject) { described_class.new.register(**payload)}
    let(:payload) do
      {
        phone_number: Faker::PhoneNumber.cell_phone_in_e164,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        core_group_id: group_id,
      }
    end

    context "registration is not allowed" do
      let(:group_id) { ENV['KEPSTER_SMS_NO_REGISTER_GROUP_ID'] }

      it 'raise an error' do
        VCR.use_cassette('sms/register/registration_not_allowed') do
          expect { subject }.to raise_error(Kepster::Errors::RegistrationNotAllowed, "Registration not allowed")
        end
      end
    end

    context "when registration is allowed" do
      let(:group_id) { ENV['KEPSTER_SMS_REGISTER_GROUP_ID'] }

      it 'successfully registers the user' do
        VCR.use_cassette('sms/register/registration_allowed') do
          response = subject
          expect(response["message"]["message"]).to eq("registration created and code succesfully sent by sms")
          expect(response["message"]["success"]).to be_truthy
          expect(response["message"]["code"]).to have_key("code")
        end
      end
    end
  end

  describe 'validate registration code sent' do
    let(:subject) { described_class.new.validate_registration_otp(**payload) }
    let(:payload) do
      {
        phone_number:,
        group_id:,
        otp_sended:
      }
    end

    context 'when phone_number is not valid' do
      let(:phone_number) { Faker::PhoneNumber.cell_phone_in_e164 }
      let(:group_id) { ENV['KEPSTER_SMS_REGISTER_GROUP_ID'] }
      let(:otp_sended) { '123456'}

      it 'return failure' do
        VCR.use_cassette('sms/verification/invalid_phone_number') do
          response = subject
          expect(response["message"]).to eq("Failure : verification fail, Registration not found")
        end
      end

    end

    context 'when otp code is invalid' do
      let(:phone_number) { Faker::PhoneNumber.cell_phone_in_e164 }
      let(:group_id) { ENV['KEPSTER_SMS_REGISTER_GROUP_ID'] }
      let(:otp_sended) { '123456'}

      before do
        payloads = {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          phone_number:,
          core_group_id: group_id
        }
        described_class.new.register(**payloads)
      end

      it 'bad otp' do
        VCR.use_cassette('sms/verification/invalid_otp') do
          response = subject
          expect(response["message"]).to eq("Failure : verification fail, Otp not valid")
        end
      end

    end

    context 'when phone_number and otp_sended are valid' do
      let(:phone_number) { Faker::PhoneNumber.cell_phone_in_e164 }
      let(:group_id) { ENV['KEPSTER_SMS_REGISTER_GROUP_ID'] }
      let(:otp_sended) { @register["message"]["code"]["code"] }

      before do
        payload = {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          phone_number:,
          core_group_id: group_id
        }
        @register = described_class.new.register(**payload)
      end

      it 'return token' do
        VCR.use_cassette('sms/verification/valid_otp') do
          sleep 10
          response = subject
          expect(response["message"]["tokens"]).to have_key("access_token")
          expect(response["message"]["tokens"]).to have_key("refresh_token")
        end
      end

    end
  end

  describe 'authenticate' do
    let(:subject) { described_class.new.authenticate(**payload)}
    let(:payload) do
      {
        phone_number:,
        group_id:
      }
    end

    context 'when user does not exist' do
      let(:phone_number) { '+3853851584495' }
      let(:group_id) {ENV['KEPSTER_SMS_NO_REGISTER_GROUP_ID'] }

      it 'return user not found' do
        VCR.use_cassette('sms/authenticate/phone_number_does_not_exist') do
          response = subject
          expect(response["message"]["message"]).to eq("Auth user not found")
        end
      end
    end

    context 'when user exists' do
      let(:phone_number) { Faker::PhoneNumber.cell_phone_in_e164 }
      let(:group_id) { ENV['KEPSTER_SMS_REGISTER_GROUP_ID'] }

      before do
        sleep 2
        payload = {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          phone_number:,
          core_group_id: group_id
        }
        puts payload
        @register = described_class.new.register(**payload)
        puts @register

        sleep 12
        verif_payload = {
          phone_number:,
          group_id: group_id,
          otp_sended: @register["message"]["code"]["code"]
        }
        puts verif_payload
        @verif = described_class.new.validate_registration_otp(**verif_payload)
        puts @verif
      end

      it 'successfully code sent' do
        VCR.use_cassette('sms/authenticate/valid_data') do
          response = subject
          expect(response["message"]["message"]).to eq("code de verification envoyé")
        end
      end
    end

  end

  describe 'validate authentication code sent' do
    let(:subject) { described_class.new.validate_auth_otp(**payload) }
    let(:payload) do
      {
        phone_number:,
        group_id:,
        otp_sended:
      }
    end

    context "when phone_number is not valid" do
      let(:phone_number) { Faker::PhoneNumber.cell_phone_in_e164 }
      let(:group_id) { ENV['KEPSTER_SMS_REGISTER_GROUP_ID'] }
      let(:otp_sended) { '123456'}

      it 'return failure' do
        VCR.use_cassette('sms/auth/token/invalid_phone_number') do
          response = subject
          expect(response["message"]).to eq("Failure : verification fail, Auth user not found")
        end
      end
    end

    context 'when otp code is invalid' do
      let(:phone_number) { Faker::PhoneNumber.cell_phone_in_e164 }
      let(:group_id) { ENV['KEPSTER_SMS_REGISTER_GROUP_ID'] }
      let(:otp_sended) { '123456'}

      before do
        sleep 2
        payload = {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          phone_number:,
          core_group_id: group_id
        }
        puts payload
        @register = described_class.new.register(**payload)
        puts @register

        sleep 12
        verif_payload = {
          phone_number:,
          group_id: group_id,
          otp_sended: @register["message"]["code"]["code"]
        }
        puts verif_payload
        @verif = described_class.new.validate_registration_otp(**verif_payload)
        puts @verif
      end


      it 'bad otp' do
        VCR.use_cassette('sms/auth/token/invalid_otp') do
          response = subject
          expect(response["message"]).to eq("Failure : Otp not valid, Does not generate jwt")
        end
      end

    end

    context "when phone_number and otp_sended are valid" do
      let(:phone_number) { Faker::PhoneNumber.cell_phone_in_e164 }
      let(:group_id) { ENV['KEPSTER_SMS_REGISTER_GROUP_ID'] }
      let(:otp_sended) { @auth["message"]["code"] }

      before do
        sleep 3
        payload = {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          phone_number:,
          core_group_id: group_id
        }
        puts payload
        @register = described_class.new.register(**payload)
        puts @register

        sleep 15
        verif_payload = {
          phone_number:,
          group_id: group_id,
          otp_sended: @register["message"]["code"]["code"]
        }
        puts verif_payload
        @verif = described_class.new.validate_registration_otp(**verif_payload)
        puts @verif

        sleep 10
        auth_payload = {
          phone_number:,
          group_id: group_id,
        }
        puts auth_payload
        @auth = described_class.new.authenticate(**auth_payload)
        puts @auth
        puts @auth["message"]["code"]

      end

      it "return token and refresh token " do
        VCR.use_cassette('sms/auth/token/valid_data') do
          sleep 10
          response = subject
          expect(response["message"]["tokens"]).to have_key("access_token")
          expect(response["message"]["tokens"]).to have_key("refresh_token")
        end
      end

    end

  end
end