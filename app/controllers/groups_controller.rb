class GroupsController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :edit, :destroy]


  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      @group_user = GroupUser.new
      @group_user.user_id = current_user.id
      @group_user.group_id = @group.id
      @group_user.save
      redirect_to groups_path
    else
      render "new"
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    if @group.update(group_params)
      redirect_to group_path(@group)
    else
      render "edit"
    end
  end

  def show
    @group = Group.find(params[:id])
    @group_users = GroupUser.where(group_id: @group)
  end

  def index
    @groups = Group.all
    @group_users = GroupUser.all
  end

  def destroy
    group = Group.find(params[:id])
    group.destroy
  end
  
  def new_mail
    @group = Group.find(params[:group_id])
  end
  
  def send_mail
    @group = Group.find(params[:group_id])
    group_users = @group.users
    @mail_title = params[:mail_title]
    @mail_content = params[:mail_content]
    EventMailer.send_mail(@mail_title, @mail_content, group_users).deliver
  end


  private

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end
