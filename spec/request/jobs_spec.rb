require 'rails_helper'

RSpec.describe "Jobs", type: :request do
    

  describe "GET /jobs" do
    it "return list of jobs" do 
      user = User.create!(name: "Adit Gustiana R", email: "adit@example.com", phone: "1234567890")    
      Job.create!(title: "Backend Engineer", description: "Backend engineer at AYANA", status: "pending", user: user)

      get "/api/v1/jobs"
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).length).to eq(1)
    end
  end

  describe "GET /jobs/:id" do
    it "returns a specific job" do
      user = User.create!(name: "Adit Gustiana R", email: "adit@example.com", phone: "1234567890")
      job = Job.create!(title: "Backend Engineer", description: "Backend engineer at AYANA", status: "pending", user: user)

      get "/api/v1/jobs/#{job.id}"
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["title"]).to eq("Backend Engineer")
    end
  end

  describe "POST /jobs" do
    it "creates a new job" do
     user = User.create!(name: "Adit Gustiana R", email: "adit@example.com", phone: "1234567890")
     job_params = {
         job: {
             title: "Backend Engineer", 
             description: "Backend engineer at AYANA", 
             status: "pending",
             user_id: user.id
            }
        }
        
        post "/api/v1/jobs", params: job_params
        expect(response).to have_http_status(:created)
        expect(Job.last.title).to eq("Backend Engineer")
    end
    
    it "fails to create if params invalid" do
        post "/api/v1/jobs", params: { job: { title: "", description: "", status: "", user: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
    end
end

  describe "PUT/PATCH /jobs/:id" do
    it "update a job" do
      user = User.create!(name: "Adit Gustiana R", email: "adit@example.com", phone: "1234567890")
      job = Job.create!(title: "Backend Engineer", description: "Backend engineer at AYANA", status: "pending", user: user)

      job_params = {
        job: {
          title: "Backend Developer", 
          description: "Backend Developer at AYANA", 
          status: "pending",
          user_id: user.id
        }
      }

      put "/api/v1/jobs/#{job.id}", params: job_params
      expect(response).to have_http_status(:ok)
      expect(Job.last.title).to eq("Backend Developer")
    end

    it "fails to update if id not found" do
      post "/api/v1/jobs/999", params: { job: { title: "Backend Engineer", description: "Backend engineer at AYANA", status: "pending" } }
      expect(response).to have_http_status(:not_found)
    end

   end

   describe "DELETE /jobs/:id" do
    it "delete a job" do
      user = User.create!(name: "Adit Gustiana R", email: "adit@example.com", phone: "1234567890")
      job = Job.create!(title: "Backend Engineer", description: "Backend engineer at AYANA", status: "pending", user: user)      

      delete "/api/v1/jobs/#{job.id}"
      expect(response).to have_http_status(:no_content)
    end

    it "fails to delete if id not found" do
      delete "/api/v1/jobs/999"
      expect(response).to have_http_status(:not_found)
    end

   end
end