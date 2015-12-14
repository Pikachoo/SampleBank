module Operator
  class UsersController < ApplicationController
    def index
      @users = User.where(role_id: 1)
    end
  end
end
