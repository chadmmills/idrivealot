jQuery ->
  new FastClick(document.body)
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  subscription.setupForm()
  console.log("Form is set up for stripe")

subscription =
  setupForm: ->
    $('.cc_form').submit ->
      $('input[type=submit]').attr('disabled', true)
      if $('#card_number').length
        subscription.processCard()
        false
      else
        true

  processCard: ->
    card =
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken(card, subscription.handleStripeResponse)
                  
  handleStripeResponse: (status, response) ->
    if status == 200
      $('#user_stripe_card_token').val(response.id)
      $('.cc_form')[0].submit()
    else
      $('#stripe_error').html("<div class='alert alert-alert stripe-alert'>" + response.error.message + "</div>")
      $('input[type=submit]').attr('disabled', false)
