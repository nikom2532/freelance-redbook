ActiveAdmin.register AdminUser do     
    index do
        column :name                              
        column :email                     
        column :current_sign_in_at        
        column :last_sign_in_at           
        column :sign_in_count             
        default_actions                   
    end                                 

    filter :email, :as => :string                    

    form do |f|                         
        f.inputs "Admin Details" do  
            f.input :name     
            f.input :email                  
            f.input :password               
            f.input :password_confirmation  
        end                               
        f.actions                         
    end  

    controller do
        def update_resource(object, attributes)
            update_method = attributes.first[:password].present? ? :update_attributes : :update_without_password
            object.send(update_method, *attributes)
        end
    end                               
end                                   
