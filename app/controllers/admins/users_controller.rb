class Admins::UsersController < Admins::ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  
  # GET /admin/users or /admin/users.json
  def index
    @users = User.all
  end
  
  # GET /admin/users/1 or /admin/users/1.json
  def show
  end
  
  # GET /admin/users/new
  def new
    @user = User.new
  end
  
  # GET /admin/users/1/edit
  def edit
  end
  
  # POST /admin/users or /admin/users.json
  def create
    @user = User.new(admin_user_params)
    
    respond_to do |format|
      if @user.save
        format.html { redirect_to admins_user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /admin/users/1 or /admin/users/1.json
  def update
    
    respond_to do |format|
      if @user.update(first_name: admin_user_params[:first_name], last_name: admin_user_params[:last_name], description: admin_user_params[:description], email: admin_user_params[:email], is_admin: admin_user_params[:is_admin])
        
        if admin_user_params[:password] != ""
          if !@user.update(password: admin_user_params[:password], password_confirmation: admin_user_params[:password_confirmation])
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end

        if admin_user_params[:avatar] != nil
          if !@user.update(avatar: admin_user_params[:avatar])
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end
        
        format.html { redirect_to admins_user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
        
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /admin/users/1 or /admin/users/1.json
  def destroy
    @user.destroy
    
    respond_to do |format|
      format.html { redirect_to admins_users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end
  
  # Only allow a list of trusted parameters through.
  def admin_user_params
    params.require(:user).permit(:email, :description, :first_name, :last_name, :avatar, :is_admin, :password, :password_confirmation)
  end
end
