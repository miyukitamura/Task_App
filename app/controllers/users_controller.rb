class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :logged_in_user, only: %i[index show edit update destroy]
  before_action :admin_user, only: %i[index destroy]
  before_action :correct_user, only: %i[edit update]
  before_action :admin_or_correct, only: %i[show]

  def index
    @users = User.paginate(page: params[:page], per_page: 20)
  end
  
  def show
  end
  
  def new
    if logged_in? && !current_user.admin? #管理者かつログインしている
      flash[:info] = 'すでにログインしてます。' 
      redirect_to current_user
    end
    @user = User.new
  end
 
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'ユーザーの新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit 
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)    #user_paramsメソッドは、Usersコントローラーの内部でのみ実行される。
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end
  end 
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end

  private
  
    def user_params
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end
  
    # paramsハッシュからユーザーを取得します。
    def set_user
      @user = User.find(params[:id])
    end  
end


  
  
  


  

  
