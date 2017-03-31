class UsersStatController < ApplicationController
  def index
    @users = User.paginate(page: params[:page]).per_page(10)
    @users_count = User.all.size
  end
  
  def show
    @user = User.find(params[:id])
    @articles = @user.articles.paginate(page: params[:page]).per_page(10)
    @articles_count = @articles.size
  end
  
  def destroy
    @user = User.find(params[:id])
    authorize! :destroy, @user
    @user.destroy
    redirect_to users_path
  end
end