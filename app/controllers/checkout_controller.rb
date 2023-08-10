class CheckoutController < ApplicationController
  before_action :already_participate?
  
    def create
        @total = params[:total].to_d
        if current_user.attendances.last.stripe_customer_id == nil
          @session = Stripe::Checkout::Session.create(
            metadata: {
              event_id: params[:event_id],
            },
            payment_method_types: ['card'],
            customer_creation: "always", 
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
            success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}',
            cancel_url: checkout_cancel_url + '?session_id={CHECKOUT_SESSION_ID}'
          )

        else

          @session = Stripe::Checkout::Session.create(
            payment_method_types: ['card'],
            metadata: {
              event_id: params[:event_id],
            },
            customer: current_user.attendances.last.stripe_customer_id,
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
            success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}',
            cancel_url: checkout_cancel_url + '?session_id={CHECKOUT_SESSION_ID}'
          )
        end


      
        redirect_to @session.url, allow_other_host: true
      end
    
      def success
        @session = Stripe::Checkout::Session.retrieve(params[:session_id])
        @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)

        flash[:success] = "Payement Effectué - vous êtes inscrit"

        Attendance.create(event_id: @session.metadata.event_id, user: current_user, stripe_customer_id: @session.customer)
        @event = Event.find(@session.metadata.event_id)
      end
    
      def cancel
        flash[:warning] = "Payement Effectué - vous êtes inscrit"

        @session = Stripe::Checkout::Session.retrieve(params[:session_id])
        @event = Event.find(@session.metadata.event_id)
      end

end
