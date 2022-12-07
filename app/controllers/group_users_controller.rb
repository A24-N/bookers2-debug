class GroupUsersController < ApplicationController

  def join
    @group = Group.find(params[:group_id])
    @group_user = GroupUser.new
    @group_user.user_id = current_user.id
    @group_user.group_id = @group.id
    @group_user.save
    redirect_to request.referer
  end

  def destroy
    @group = Group.find(params[:group_id])
    @group_user = GroupUser.find_by(group_id: @group, user_id: current_user)
    @group_user.destroy
    redirect_to request.referer
  end

end
