class Invitation
    include Mongoid::Document
    field :fullname,            type: String
    field :email,               type: String
    field :institution,         type: String
    field :invitation_token,    type: String

    field :sent,                type: Boolean, default: false

    attr_accessible :fullname, :email, :institution, :invitation_token, :sent

    before_save :generate_invitation_token

    def generate_invitation_token
        self.invitation_token = loop do
            random_token = Digest::SHA1.hexdigest([Time.now, rand].join)
            break random_token unless Invitation.where(invitation_token: random_token).exists?
        end
    end
end
