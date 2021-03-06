class UsersController < ApplicationController
  before_filter :signed_in_user,  
                only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :signed_out_user, only: [:new, :create]
  before_filter :correct_user,    only: [:edit, :update]
  before_filter :admin_user,      only: :destroy

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])

    respond_to do |format|
      format.html {render}
      format.json {render :json => @user}
    end
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user

      respond_to do |format|
        format.html {redirect_to @user}
        format.json {@user.errors.full_messages.each do |message|
            render :text => message
          end
        }
      end

    else
      respond_to do |format|
        format.html {render 'edit'}
        format.json {@user.errors.full_messages.each do |message|
            render :text => message
          end
        }
      end
    end
  end

  private

    def signed_out_user
      if signed_in?
        redirect_to root_path, 
          notice: "Please sign out first."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end