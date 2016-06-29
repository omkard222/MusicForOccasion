$ -> 
  $('.message-send-form').on 'submit', ->
    $(this).find('.btn-send').attr 'disabled', true

  $('.new_profile').on 'submit', ->
    $(this).find('.btn-block').attr 'disabled', true
  $('.new_user').on 'submit', ->
    $(this).find('.btn-block').attr 'disabled', true
