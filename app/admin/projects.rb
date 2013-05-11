ActiveAdmin.register Project do
    index do
        column :name
        column :kind
        column :rdomain_list
        column :deadline
        column :budget 
        default_actions
    end
  
end
