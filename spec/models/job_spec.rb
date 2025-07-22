require 'rails_helper'

RSpec.describe Job, type: :model do   
    let(:user) { User.create(name: "Adit Gustiana R", email: "adit@example.com", phone: "1234567890") }
    subject { Job.new(title: "Backend Engineer", description: "Backend engineer at AYANA", status: "pending", user: user)}

    describe "validations" do
        it 'all attributes are valid' do
            expect(subject).to be_valid
        end

        it 'invalid without title' do
            subject.title = nil
            expect(subject).not_to be_valid
        end 

        it 'invalid without description' do
            subject.description = nil
            expect(subject).not_to be_valid
        end

        it 'invalid without status' do
            subject.status = nil
            expect(subject).not_to be_valid
        end

        it 'invalid without user' do
            subject.user = nil
            expect(subject).not_to be_valid
        end

        it 'invalid status name' do 
            subject.status = "invalid_status"
            expect(subject).not_to be_valid
        end
    end

    context "associations" do
        it "belongs to user" do
        assoc = described_class.reflect_on_association(:user)
        expect(assoc.macro).to eq(:belongs_to)
        end
    end
end