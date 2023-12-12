class UsersController <ApplicationController 
  def new 
    @user = User.new()
  end 

  def show 
    @user = User.find(params[:id])
  end 

  def create
    user = user_params
    user[:name] = user[:name].downcase
    new_user = User.new(user)
    session[:user_id] = new_user.id
    
    if user[:password] != user[:password_confirmation]
      flash[:error] = "Passwords do not match"
      redirect_to register_path
    elsif new_user.save
      flash[:success] = "Welcome, #{new_user.name}!"
      redirect_to user_path(new_user)
    else  
      flash[:error] = new_user.errors.full_messages.to_sentence
      redirect_to register_path
    end    
  end 

  def login_form
  end

  def login
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to root_path
    else
      flash[:error] = "Sorry, your credentials are bad."
      render :login_form
    end
  end
  
  def logout
    session[:user_id] = nil
    redirect_to root_path
  end

  private 

  def user_params 
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end 
end 
