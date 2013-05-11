class InvitationMailer < ActionMailer::Base
  default from: "noreply@projectredbook.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invitation_mailer.beta_invitation.subject
  #
  def beta_invitation invitation
    @invitation = invitation
    @email = invitation.email
    @url  = root_url
    @greeting = "Hi"

    mail to: @invitation.email
  end
end
