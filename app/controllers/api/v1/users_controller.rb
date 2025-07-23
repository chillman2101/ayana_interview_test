module Api
  module V1
    class UsersController < BaseController
      before_action :set_user, only: [:show, :update, :destroy] 
      after_action :invalidate_cache_user, only: [:create, :update, :destroy]     

      # GET /api/v1/users
      def index
        key = "user:all"
        @users = CacheService.fetch_cache(key) do 
          users = User.all.includes(:jobs).to_a
        end
        render json: @users
      end

      # GET /api/v1/users/1
      def show
        render json: @user
      end

      # POST /api/v1/users
      def create
        @user = User.new(user_params)

        if @user.save          
          render json: @user, status: :created
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/users/1
      def update
        if @user.update(user_params)         
          render json: @user
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/users/1
      def destroy
        @user.destroy
        head :no_content
      end

      private

      def set_user
        key = "user:#{params[:id]}:jobs"
        @user = CacheService.fetch_cache(key) do 
          user = User.includes(:jobs).find(params[:id])
        end
      end

      def user_params
        params.require(:user).permit(:name, :email, :phone)
      end

      def invalidate_cache_user
         return unless @user #return if @user is nil
         # destroy cache if exist
         CacheService.invalidate("user:all")
         CacheService.invalidate("user:#{@user.id}:jobs")
      end

    end
  end
end
