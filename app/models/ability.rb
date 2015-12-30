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
      if client
        if client.cards
          can :read, Card, client_id: client.id
          can :update, Card, client_id: client.id
        end
        if client.accounts
          can :read, Account, client_id: client.id
          can :update, Account, client_id: client.id
          can :show_account, Account, client_id: client.id
        end


        can :read, ClientCredit, client_id: client.id
        can :show_credit, ClientCredit, client_id: client.id

      end


    end

    if user.is? 'operator'
      can :manage, BankCredit
      can :manage, ClientCredit
      can :manage, Account
      can :show_credit, ClientCredit
      can :manage, @bank_credit_inputs
      can :manage, CreditApplication
      can :read, CreditGranting
      can :read, CreditGrantingType
      can :read, CreditWarrenty
      can :read, CreditWarrentyType
      can :manage, Timemachine
    end

    if user.is? 'cashier'
      can :manage, Account
    end

    if user.is? 'credit_admin'
      can :manage, Credit

    end

    if user.is? 'user_admin'
      can :manage, User
    end
  end
end
