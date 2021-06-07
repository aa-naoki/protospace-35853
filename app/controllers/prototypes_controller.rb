class PrototypesController < ApplicationController
  before_action :set_prototype, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit, :destroy]

  def index
    # @prototypes = Prototype.includes(:user).order("created_at DESC")
    query = "SELECT * FROM prototypes"
    @prototypes = Prototype.find_by_sql(query)
  end

  def new
    @prototype = Prototype.new
  end

  def create    
    @prototype = Prototype.create(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render :new
    end

  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end
  
  def edit
    unless current_user == user_signed_in?
      redirect_to action: :index
    end
  end

  def update
    if @prototype.update(prototype_params)
      redirect_to prototype_path(params[:id])
    else
      render :edit
    end 
  end

  def destroy
    prototype = @prototype
    prototype.destroy
    redirect_to root_path
  end

private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end
end
