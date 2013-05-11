class GroupsController < ApplicationController

before_filter :authenticate_user!
load_and_authorize_resource
skip_authorize_resource :only => [:index,:labs,:companies,:lvuser]

  def user2mod
	group = Group.find(params[:id])
	user = User.find(params[:user_id])
	user.add_role :moderator, group
	redirect_to :back
  end
  
  def mod2user
	group = Group.find(params[:id])
	user = User.find(params[:user_id])
	user.remove_role :moderator, group
	redirect_to :back
  end

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups.universities.where(name: /#{params[:q]}/i) }
    end
    # asda
  end

  def universities
    @groups = Group.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups.universities.where(name: /#{params[:q]}/i) }
    end
    # asda
  end

  def institutes
    @groups = Group.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups.institutes.where(name: /#{params[:q]}/i)}
    end
    # asda
  end

  def about
    @group = Group.find(params[:group_id])
  end

  def member
    @group = Group.find(params[:group_id])
    @users = @group.users
  end

  def activity
    @group = Group.find(params[:group_id])
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:group_id])
    # asd
  end

  def relations
    @group = Group.find(params[:group_id])
  end

  def memberships
    @group = Group.find(params[:group_id])
    # asd
    
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(params[:group])

    respond_to do |format|
      if @group.save
        format.html { redirect_to :back, notice: 'Group was successfully created.' }
        format.json { render json: :back, status: :created, location: @group }
      else
        format.html { render action: "new" }
        format.json { redirect_to :back, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])
    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to action: "about", group_id: params[:id] , notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to :back }
        format.json { redirect_to :back, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end
  
  def labs
    @lab_group = Group.where(:kind => "Labs")
	if(params[:q] != "" && params[:q] != nil)
		@lab_group = @lab_group.full_text_search(params[:q])
	end
  end
  
  def companies
    @company_group = Group.where(:kind => "Company")
	if(params[:q] != "" && params[:q] != nil)
		@company_group = @company_group.full_text_search(params[:q])
	end
  end
  
  def sub
    @this_group = Group.find(params[:id])
    @groups = Group.all
  end
  
  def addsub
    @this_group = Group.find(params[:id])
    @sub = Group.find(params[:sid])
    #=============================
    # add block sub<->root code here
    #=============================
    @this_group.subgroups << @sub
    @sub.parentgroups = @this_group
    
    redirect_to :back , notice: 'Added SubGroup was successfully.'
  end
  
  def rmsub
    @this_group = Group.find(params[:id])
    @sub = Group.find(params[:sid])
    @this_group.subgroups.delete(@sub)
    @sub.parentgroups = nil
    
    redirect_to :back , notice: 'Removed SubGroup was successfully.'
  end
  
  def parent
    @this_group = Group.find(params[:id])
    @groups = Group.all
  end
  
  def addpar
    @this_group = Group.find(params[:id])
    @par = Group.find(params[:pid])
    if(@par == @this_group)
      redirect_to :back , :alert => 'Can\'t Add Self to Parent.'
	  elsif (@par.is_child(@this_group) == false)
  		#=============================
  		# add block parent<->root code here
  		#=============================
  		@this_group.parentgroups = @par
  		@par.subgroups << @this_group
  		redirect_to :back , notice: 'Added Parent Group was successfully.'
  	else
  		redirect_to :back , :alert => 'Can\'t Add Child of this Group to Parent.'
  	end
  end
  
  def rmpar
    @this_group = Group.find(params[:id])
    @par = Group.find(params[:pid])
    @this_group.parentgroups = nil
    @par.subgroups.delete(@this_group)
    
    redirect_to :back , notice: 'Removed Parent Group was successfully.'
  end
  
  def mem
    @this_group = Group.find(params[:id])
    @user = User.all
  end
  
  def adduser
    @this_group = Group.find(params[:id])
    @user = User.find(params[:uid])
    @this_group.users << @user
    
    redirect_to :back , notice: 'Added member was successfully.'
  end
  
  def rmuser
    @this_group = Group.find(params[:id])
    @user = User.find(params[:uid])
    @this_group.users.delete(@user)
    
    redirect_to :back , notice: 'Removed member was successfully.'
  end
  
  # member can leave group
  def lvuser
    @this_group = Group.find(params[:id])
    @user = User.find(params[:uid])
    if current_user == @user
        @user.groups.delete(@this_group)
        redirect_to groups_path , notice: 'Leaved Group was successfully.'
    else
        redirect_to :back
    end
  end
end
