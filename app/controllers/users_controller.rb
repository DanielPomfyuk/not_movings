
class UsersController < ApplicationController
  # before_action :require_no_authentication, :only => [ :new, :create ]
  #before_action :authenticate_user!
  def index
  end
  def new
    @user = User.new
  end
  def create
    puts "I AM IN CREATE"
    new_params = params['forma'].permit(:email, :password, :first_name, :last_name ).to_hash
    @user = User.new(new_params)
    puts "HERE IS THIS GUY \n #{@user.object_to_hash}"
    @user.save
  end

  def show
    @user = User.find(1)
  end

  def edit
  end

  def user_params

  end
end