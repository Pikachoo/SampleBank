module Operator
  class CreditsController < ApplicationController
    load_and_authorize_resource
    def index
      @credits = Credit.all
    end
    def new

    end
    def create

    end
    def edit

    end


  end
end
