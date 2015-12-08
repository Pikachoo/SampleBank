class Ability
  include CanCan::Ability

  def initialize(user)
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    # Handle the case where we don't have a current_user i.e. the user is a guest
    user ||= User.new
    client ||= Client.find_by(user_id: user.id)

    # # Define a few sample abilities
    if user.is? 'client'
      can :read, Card, client_id: client.id
      can :update, Card, client_id: client.id
      can :read, Account, client_id: client.id
      can :update, Account, client_id: client.id
    end

    if user.is? 'operator'
      can :manage, Credit
    end
  end
end
