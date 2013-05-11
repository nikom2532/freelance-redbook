class AdminController < ApplicationController
  def list
  	@zombies = User.where(:is_zombie => true, :unconfirmed_emai => nil)
  	@users = User.where(:is_zombie => false, :unconfirmed_emai => nil)
  end

  def zombie2user
  	@user = User.find(params[:id])
  	@user.update_attribute(:is_zombie, false)
  	@user.save

  	redirect_to :back
  end
  
  def user2zombie
  	@user = User.find(params[:id])
  	@user.update_attribute(:is_zombie, true)
  	@user.save

  	redirect_to :back
  end

end