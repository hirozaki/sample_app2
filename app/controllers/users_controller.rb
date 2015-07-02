class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
 

	def show 
		@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
	end
  
  def method
    @method ||= check_method(env["rack.methodoverride.original_method"] || env['REQUEST_METHOD'])  
  end
    
    def new
      if signed_in? 
        redirect_to root_path 
        flash[:notify] = "You need to log out before signing up"
        else
        @user = User.new
      end
    end

    def create
      if signed_in?
        redirect_to root_path
        flash[:notify] = "Oops please log out to create a new user"
          else
          @user = User.new(user_params)
          if @user.save
            sign_in @user
            flash[:success] = "Welcome to the Sample App2!"
            redirect_to @user
            else
            render 'new'
          end
      end
    end

  def edit 
  end

  def update 
    if @user.update_attributes(user_params)
        flash[:success] = "Profile updated"
        redirect_to @user 
      else
        render 'edit'
      end
    end

     def index
      @users = User.paginate(page: params[:page])
     end

    def destroy
      user = User.find(params[:id])
      if current_user? user
         redirect_to(root_path)
         flash[:error] = "Can't delete administratar" 
      else     
      user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
      end
    end

  	private 

  	 def user_params 
  	 	params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	 	end
      
      # Before actions 
      
      # Deleted these codes when signed_in_user was created in app/helpers/sessions_helper.rb. 
     # def signed_in_user
  

      def correct_user 
        @user = User.find(params[:id])
        redirect_to(root_path) unless current_user?(@user)
    end 

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end








