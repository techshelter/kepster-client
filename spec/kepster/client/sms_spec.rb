require File.expand_path('../../../spec_helper', __FILE__)

RSpec.describe Kepster::Client::SMS do
  describe "#register" do
    let(:subject) { described_class.new.register(**payload)}
    let(:payload) do
      {
        phone_number: Faker::PhoneNumber.phone_number,
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
          expect(response).to have_key("core_user_id")
          expect(response["message"]).to eq("link succesfully sent by e-mail")
          expect(response["success"]).to be_truthy
        end
      end
    end
  end
end