class GroupsController < ApplicationController
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
  end

  def show
    @group = Group.find(params[:id])
  end

  def index
    @groups = Group.all
  end

  def destroy
    group = Group.find(params[:id])
    group.destroy

  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end
end
