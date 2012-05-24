class UsersController < ApplicationController
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
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user

      respond_to do |format|
        format.html {redirect_to @user}
        format.json {@user.errors.full_messages.each 
          do |message|
            render :text => message
          end
        }
      end

      #render :text => 'success'##
    else
      respond_to do |format|
        format.html {render 'edit'}
        format.json {@user.errors.full_messages.each 
          do |message|
            render :text => message
          end
        }
      end
    end
  end

end