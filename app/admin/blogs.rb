ActiveAdmin.register Blog do

    form do |f|
        f.inputs "Blog" do
            f.input :topic
            f.input :content, :as => :text
        end
        f.buttons
    end
  
end
