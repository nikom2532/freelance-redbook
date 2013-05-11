ActiveAdmin.register User, :as => "Researcher" do
    index do
        column :avatar do |user| 
            image_tag(user.avatar.url(:small), :alt => "user image")
        end
        column :username
        column :displayname
        column :rdomain_list
        column :email
        column :last_sign_in_ip
        column :last_sign_in_at
        default_actions
    end

    show :title => :displayname 

    show do |s|
        attributes_table do
            row("image") do 
                image_tag s.avatar.url(:medium)
            end
            row("role") do
                s.roles.each do |r|
                    r.name
                end
            end
            row :is_zombie
            row :username
            row :displayname
            row :email
            row :rdomain_list

            row :website
            row :facebook
            row :twitter
            row :linkedin

        end
    end


    form do |f|                         
        f.inputs "Researcher Details" do 
            f.input :is_zombie, :as => :radio
            f.input :username
            f.input :email
            f.input :firstname
            f.input :middlename
            f.input :lastname      
            if f.object.new_record?            
                f.input :password               
                f.input :password_confirmation  
            end
            f.input :rdomain_list
            f.input :website
            f.input :twitter
            f.input :facebook
        end                               
        f.actions                         
    end  

    controller do
        # This code is evaluated within the controller class

        
    end


end
