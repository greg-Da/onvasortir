class CheckoutController < ApplicationController
  before_action :already_participate?
  
    def create
        @total = params[:total].to_d
        @session = Stripe::Checkout::Session.create(
          payment_method_types: ['card'],
          line_items: [
            {
              price_data: {
                currency: 'eur',
                unit_amount: (@total*100).to_i,
                product_data: {
                  name: 'Rails Stripe Checkout',
                },
              },
              quantity: 1
            },
          ],
          mode: 'payment',
          success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}' + "&event_id=#{params[:event_id]}",
          cancel_url: checkout_cancel_url + "?event_id=#{params[:event_id]}"
        )
        redirect_to @session.url, allow_other_host: true
      end
    
      def success
        @session = Stripe::Checkout::Session.retrieve(params[:session_id])
        @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)

        flash[:success] = "Payement Effectué - vous êtes inscrit"

        Attendance.create(event_id: params[:event_id], user: current_user)
        @event = Event.find(params[:event_id])
      end
    
      def cancel
        flash[:warning] = "Payement Effectué - vous êtes inscrit"

        @event = Event.find(params[:event_id])
      end

end
