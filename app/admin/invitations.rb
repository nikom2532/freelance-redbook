ActiveAdmin.register Invitation do

    batch_action :send_invite_to do |selection|
        Invitation.find(selection).each do |invitation|
            invitation.update_attribute(:sent, true)
            InvitationMailer.beta_invitation(invitation).deliver
        end
        redirect_to collection_path, :notice => "Sent Invitations!"
    end
  
end
