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
    
    if new_user.save
      flash[:success] = "Welcome, #{new_user.name}!"
      redirect_to user_path(new_user)
    else  
      flash[:error] = new_user.errors.full_messages.to_sentence
      redirect_to register_path
    end 
  end 

  private 

  def user_params 
    params.require(:user).permit(:name, :email, :password)
  end 
end 