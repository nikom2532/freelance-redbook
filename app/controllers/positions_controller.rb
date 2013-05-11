class PositionsController < InheritedResources::Base
    before_filter :authenticate_user!

    def index
        @positions = current_user.positions
    end

    def create
        @position = Position.new(params[:position])
        @position.user = current_user
        create!
    end
end
