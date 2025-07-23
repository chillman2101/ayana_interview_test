require 'rails_helper'

RSpec.describe "Users", type: :request do
    

  describe "GET /users" do
    it "return list of users" do      
      User.create!(name: "Chillman", email: "chillman@example.com", phone: "089609742223")
      get "/api/v1/users"
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).length).to eq(1)
    end
  end

  describe "GET /users/:id" do
    it "returns a specific user" do
      user = User.create!(name: "Chillman", email: "chillman@example.com", phone: "089609742223")
      get "/api/v1/users/#{user.id}"
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq("Chillman")
    end
  end

  describe "POST /users" do
    it "creates a new user" do
      user_params = {
        user: {
          name: "Chillman",
          email: "chillman@example.com",
          phone: "089609742223"
        }
      }

      post "/api/v1/users", params: user_params
      expect(response).to have_http_status(:created)
      expect(User.last.name).to eq("Chillman")
    end

    it "fails to create if params invalid" do
      post "/api/v1/users", params: { user: { name: "", email: "", phone: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
   end

   describe "PUT/PATCH /users/:id" do
    it "update a user" do
      user = User.create!(name: "Chillman", email: "chillman@example.com", phone: "089609742223")
      user_params = {
        user: {
          name: "Chillman 2",
          email: "chillman@example.com",
          phone: "089609742223"
        }
      }

      put "/api/v1/users/#{user.id}", params: user_params
      expect(response).to have_http_status(:ok)
      expect(User.last.name).to eq("Chillman 2")
    end

    it "fails to update if id not found" do
      post "/api/v1/users/999", params: { user: { name: "Chillman 2", email: "chillman@example.com", phone: "089609742223" } }
      expect(response).to have_http_status(:not_found)
    end

   end

   describe "DELETE /users/:id" do
    it "delete a user" do
      user = User.create!(name: "Chillman", email: "chillman@example.com", phone: "089609742223")     

      delete "/api/v1/users/#{user.id}"
      expect(response).to have_http_status(:no_content)
    end

    it "fails to delete if id not found" do
      delete "/api/v1/users/999"
      expect(response).to have_http_status(:not_found)
    end

   end
end