class GroupUsersController < ApplicationController

  def create
    @group = Group.find(params[:group_id])
    group_user = current_user.favorites.new(group_id @group.id)
    group_user.save
  end

end
