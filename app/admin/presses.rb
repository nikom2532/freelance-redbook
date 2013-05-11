ActiveAdmin.register Press do
    form do |f|
        f.inputs "Press" do
            f.input :topic
            f.input :content, :as => :text
        end
        f.buttons
    end
end
