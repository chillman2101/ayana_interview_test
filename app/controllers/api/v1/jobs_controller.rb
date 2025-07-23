module Api
  module V1
    class JobsController < BaseController
      before_action :set_job, only: [:show, :update, :destroy]

      # GET /api/v1/jobs
      def index
        key =  params[:user_id] ? "user:#{params[:user_id]}:jobs" : "jobs:all"
        @jobs = CacheService.fetch_cache(key) do 
            jobs = if params[:user_id]
              Job.where(user_id: params[:user_id]).includes(:user).to_a
            else
              Job.all.includes(:user).to_a
            end
        end

        render json: @jobs
      end

      # GET /api/v1/jobs/1
      def show
        render json: @job
      end

      # POST /api/v1/jobs
      def create
        @job = Job.new(job_params)

        if @job.save           
          render json: @job, status: :created
        else
          render json: { errors: @job.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/jobs/1
      def update
        if @job.update(job_params)          
          render json: @job
        else
          render json: { errors: @job.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/jobs/1
      def destroy        
        @job.destroy
        head :no_content
      end

      private

      def set_job
        key = "user:#{params[:id]}:jobs"         
        @job = CacheService.fetch_cache(key) do 
          job = Job.includes(:user).find(params[:id])
        end
      end

      def job_params
        params.require(:job).permit(:title, :description, :status, :user_id)
      end

      def invalidate_cache_jobs
        return unless @job #return if @job is nil
        # destroy cache if exist
        CacheService.invalidate("jobs:all")
        CacheService.invalidate("user:#{@job.user_id}:jobs")
      end
    end
  end
end
