class HomeController < ApplicationController
  def index
    @users = User.all
  end

  def dashboard
    @users = User.all.order_by(:created_at => :desc).page(params[:user_page]).per(8)
    @groups = Group.all
    @projects = Project.all.order_by(:created_at => :desc).page(params[:project_page]).per(8)

    @companies = Group.where(kind: "Company").order_by(:created_at => :desc).page(params[:company_page]).per(8)
    @institutes = Group.where(kind: "Institute").order_by(:created_at => :desc).page(params[:institute_page]).per(8)
    @universities = Group.where(kind: "University").order_by(:created_at => :desc).page(params[:university_page]).per(8)

    respond_to do |format|
      format.html 
      format.json 
      format.js
    end

  end

  def api
  end

  def lip
  end

  def what
  end

  def help
  end

  def about
  end

  def terms
  end

  def privacy
  end

  def cookie
  end
  
end
