require 'rails_helper'

RSpec.describe User, type: :model do    
        subject { User.new(name:"Chillman", email:"chillman@gmail.com", phone:"089609742223") }        

        describe 'validations' do
            it 'all attributes are valid' do
                expect(subject).to be_valid
            end

            it 'invalid without name' do
                subject.name = nil
                expect(subject).not_to be_valid
            end

            it 'invalid without email' do 
                subject.email = nil
                expect(subject).not_to be_valid
            end

            it 'invalid without phone' do 
                subject.phone = nil
                expect(subject).not_to be_valid
            end

            it 'invalid email already exist' do
                User.create!(name: "Chillman", email: subject.email, phone: "089609742223")
                expect(subject).not_to be_valid
            end

            it 'invalid email format' do 
                subject.email = "invalid_email"
                expect(subject).not_to be_valid
            end
        end

        context "associations" do
            it "has many jobs" do
            assoc = described_class.reflect_on_association(:jobs)
            expect(assoc.macro).to eq(:has_many)
            end
        end
end