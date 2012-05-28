class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user,   only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])

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

      #render :text => 'success'##
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

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

end