module ClientAccount
  class CardsController < ApplicationController
    load_and_authorize_resource

    def show
      flash[:notice] = nil
      @current_page = params[:client_cards].to_i
      cur_date = Timemachine.get_current_date+ 1.day

      where_str = "date_created <= '#{cur_date}' and is_active = true"

      @cards = current_client.cards.where(where_str).page(params[:client_cards].to_i)

      puts json: @cards
    end

    def update

      sms_ids = params[:sms_ids]
      emails_ids = params[:emails_ids]
      @current_page = params[:client_cards].to_i
      @cards = current_client.cards.page(params[:client_cards].to_i)

      @cards.each do |card|
        if sms_ids
          if sms_ids.index(card.id.to_s)
            card.is_sms = true
          else
            card.is_sms = false
          end
        else
          card.is_sms = false
        end

        if emails_ids
          if emails_ids.index(card.id.to_s)
            card.is_email = true
          else
            card.is_email = false
          end
        else
          card.is_email = false
        end

        card.save
      end

      flash[:notice] = 'Изменения сохранены'
      render 'client_account/cards/show'
    end
  end
end


