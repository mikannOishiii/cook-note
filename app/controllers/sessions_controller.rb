class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: session_params[:email].downcase)
    if user && user.authenticate(session_params[:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to root_url, notice: "ログインしました"
    else
      flash.now[:danger] = "メールアドレスまたはパスワードが違います" 
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, notice: "ログアウトしました"
  end
  
  def session_params
    params.require(:session).permit(:email, :password)
  end
end
