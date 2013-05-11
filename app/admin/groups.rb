ActiveAdmin.register Group do

    index do
        column :logo do |group| 
            image_tag(group.logo.url(:small), :alt => "group image")
        end
        column :name
        column :kind
        column :rdomain_list
        column :country
        column :website 
        default_actions
        # link_to('View on site', {controller: "controller"})
    end

    form do |f|
        f.inputs "Group Details" do 
            f.input :logo,          as: :file
            f.input :name
            f.input :kind,          as: :select, collection: ["University", "Institute", "Company"]
            f.input :description,   as: :text
            f.input :phone_country, as: :number
            f.input :phone,         as: :number
            f.input :phone_extension,   as: :number     
            f.input :rdomain_list
            f.input :website
            f.input :twitter
            f.input :facebook
            f.input :verify_host
            f.input :group_moderator
        end                               
        f.actions    
    end


    controller do
        def add_mod
            @group = Group.find(params[:id])
            @user = User.find(params[:user_id])
            user.add_role :moderator, @group
            redirect_to :back
            # respond_to do |format|
            #     format.html
            #     format.json
            #     format.js
            # end
        end
        def remove_mod
            @group = Group.find(params[:id])
            @user = User.find(params[:user_id])
            user.remove_role :moderator, @gro.up
            redirect_to :back
            # respond_to do |format|
            #     format.html
            #     format.json
            #     format.js
            # end
        end
    end

end
