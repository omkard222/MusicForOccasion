$ ->
  $('#delete_profile_btn').click ->
    bootbox.dialog({
      title: $('#alert_title').text(),
      message: $('#alert_message').text(),
    })

  if $('.edit-profile').length > 0
    class ProfileFormDecorator
      toggleIntrumentsBySolo = ($radio)->
        $instrumentsSelect = $('#profile_instrument_ids')
        isSolo = $radio.attr('id') == 'profile_category_solo' && $radio.prop('checked')
        $('#profile_instruments_input').toggleClass('hidden', !isSolo)
        $instrumentsSelect.prop 'required', isSolo
        $instrumentsSelect.prop 'disabled', !isSolo

      constructor: ->
        @initCategory()
        @initImage()
        @initGenresAndInstruments()
        @initSocialNetworks()

      initCategory: ->
        $('#profile_category_input input[type="radio"]').change ->
          toggleIntrumentsBySolo($(@))
        toggleIntrumentsBySolo($('input#profile_category_solo[type="radio"]'))

      initImage: ->
        preview = $('#image_profile')
        $('#fileUpload').on 'click', -> $('#file').click()
        $('#file').on 'change', (event) ->
          if $('#file').val() != ''
            $('#fileUploadName').html 'Upload file : ' + $('#file').val().replace(/.*(\/|\\)/, '')
            input = $(event.currentTarget)
            file = input[0].files[0]
            reader = new FileReader()
            reader.onload = (e) ->
              image_base64 = e.target.result
              $('.cropbox').attr 'src', image_base64
              $('.cropbox1').attr 'src', image_base64
              $('#profile_crop_x').val("0")
              $('#profile_crop_y').val("0")
              $('#profile_crop_w').val($('#cropbox')[0].naturalWidth)
              $('#profile_crop_h').val($('#cropbox')[0].naturalHeight)
            reader.readAsDataURL file
          else
            $('#fileUploadName').html $('Add File').val()

      initGenresAndInstruments: ->
        select2Params =
          width: $('#profile_genre_ids').css('width')
        $('#profile_instrument_ids').select2(select2Params)
        $('#profile_genre_ids').select2(select2Params)
      initSocialNetworks: ->
        $('#disconnect_facebook').click ->
          facebook_disconnect_path = $(this).data 'url'
          bootbox.dialog
            title: i18n.t('profiles.edit.disconnect_facebook.title')
            message: "<a class='btn btn_modal_confirm' href='#{facebook_disconnect_path}' data-method='post' style='width:90px;'>#{i18n[window.current_locale]['true']}</a> <button type='button' class='btn btn_modal_confirm btn-default' data-dismiss='modal' aria-hidden='true'>#{i18n[window.current_locale]['false']}</button>"
        $('#disconnect_youtube').click ->
          youtube_disconnect_path = $(this).data 'url'
          bootbox.dialog
            title: i18n.t('profiles.edit.disconnect_youtube.title')
            message: "<a class='btn btn_modal_confirm' href='#{youtube_disconnect_path}' data-method='post' style='width:90px;'>#{i18n[window.current_locale]['true']}</a> <button type='button' class='btn btn_modal_confirm btn-default' data-dismiss='modal' aria-hidden='true'>#{i18n[window.current_locale]['false']}</button>"
        $('#disconnect_twitter').click ->
          twitter_disconnect_path = $(this).data 'url'
          bootbox.dialog
            title: i18n.t('profiles.edit.disconnect_twitter.title')
            message: "<a class='btn btn_modal_confirm' href='#{twitter_disconnect_path}' data-method='post' style='width:90px;'>#{i18n[window.current_locale]['true']}</a> <button type='button' class='btn btn_modal_confirm btn-default' data-dismiss='modal' aria-hidden='true'>#{i18n[window.current_locale]['false']}</button>"
        $('#disconnect_soundcloud').click ->
          soundcloud_disconnect_path = $(this).data 'url'
          bootbox.dialog
            title: i18n.t('profiles.edit.disconnect_soundcloud.title')
            message: "<a class='btn btn_modal_confirm' href='#{soundcloud_disconnect_path}' data-method='post' style='width:90px;'>#{i18n[window.current_locale]['true']}</a> <button type='button' class='btn btn_modal_confirm btn-default' data-dismiss='modal' aria-hidden='true'>#{i18n[window.current_locale]['false']}</button>"
        $('#remove_paypal_email_confirmation').click ->
          paypal_remove_confirmation_path = $(this).data 'url'
          bootbox.dialog
            title: i18n.t('profiles.edit.remove_paypal_confirmation.title')
            message: "<a class='btn btn_modal_confirm' href='#{paypal_remove_confirmation_path}' data-method='post' style='width:90px;'>#{i18n[window.current_locale]['true']}</a> <button type='button' class='btn btn_modal_confirm btn-default' data-dismiss='modal' aria-hidden='true'>#{i18n[window.current_locale]['false']}</button>"
        $('#confirm_paypal_email').click ->
          paypal_confirm_path = $(this).data 'url'
          email = $('#profile_paypal_account_email').val()
          if email.length > 0
            title = i18n.t('profiles.edit.confirm_paypal_account.title_with_email')
            message = "<a class='btn btn_modal_confirm' href='#{paypal_confirm_path}?email=#{email}' data-method='post' style='width:90px;'>#{i18n[window.current_locale]['true']}</a> <button type='button' class='btn btn_modal_confirm btn-default' data-dismiss='modal' aria-hidden='true'>#{i18n[window.current_locale]['false']}</button>"
          else
            title = i18n.t('profiles.edit.confirm_paypal_account.title_without_email')
            message = "<button type='button' class='btn btn_modal_confirm btn-default' data-dismiss='modal' aria-hidden='true'>#{i18n[window.current_locale]['ok']}</button>"
          bootbox.dialog
            title: title
            message: message

    new ProfileFormDecorator()

  if $('#existing_profile_tech_rider').text().length == 0
    $('#delete_profile_tech_rider').hide()
  else
    $('#upload_tech_rider').hide()

  $('#upload_tech_rider').on 'click', ->
    $('#profile_tech_rider').trigger('click')

  $('#profile_tech_rider').on 'change', ->
    tech_rider_func()

  $('#delete_profile_tech_rider').on 'click', ->
    $('#existing_profile_tech_rider').hide()
    $('#delete_profile_tech_rider').hide()
    $('#upload_tech_rider').show()
    $('#profile_remove_tech_rider').prop('checked', true)
    $('#profile_tech_rider').replaceWith($('#profile_tech_rider').clone())
    $('#profile_tech_rider').on 'change', ->
      tech_rider_func()

  window.tech_rider_func = () ->
    $('#existing_profile_tech_rider').show()
    $('#delete_profile_tech_rider').show()
    $('#upload_tech_rider').hide()
    $('#profile_remove_tech_rider').prop('checked', false)
    $('#existing_profile_tech_rider').removeClass('hidden_field')
    $('#existing_profile_tech_rider').text($('#profile_tech_rider').val().replace(/.+[\\\/]/, ""))




  if $('#existing_profile_site_logo').text().length == 0
    $('#delete_profile_site_logo').hide()
  else
    $('#upload_site_logo').hide()

  $('#upload_site_logo').on 'click', ->
    $('#profile_site_logo').trigger('click')

  $('#profile_site_logo').on 'change', ->
    site_logo_func()

  $('#delete_profile_site_logo').on 'click', ->
    $('#existing_profile_site_logo').hide()
    $('#delete_profile_site_logo').hide()
    $('#upload_site_logo').show()
    $('#profile_remove_site_logo').prop('checked', true)
    $('#profile_site_logo').replaceWith($('#profile_site_logo').clone())
    $('#profile_site_logo').on 'change', ->
      site_logo_func()

  window.site_logo_func = () ->
    $('#existing_profile_site_logo').show()
    $('#delete_profile_site_logo').show()
    $('#upload_site_logo').hide()
    $('#profile_remove_site_logo').prop('checked', false)
    $('#existing_profile_site_logo').removeClass('hidden_field')
    $('#existing_profile_site_logo').text($('#profile_site_logo').val().replace(/.+[\\\/]/, ""))
  
  # new AvatarCropper()
# 
# class AvatarCropper
  # constructor: ->
    # $('#cropbox').Jcrop
      # aspectRatio: 1
      # setSelect: [0, 0, 600, 600]
      # onSelect: @update
      # onChange: @update
#   
  # update: (coords) =>
    # $('#user_crop_x').val($('#cropbox')[0].naturalWidth/ $('#cropbox').width() * coords.x)
    # $('#user_crop_y').val($('#cropbox')[0].naturalHeight/ $('#cropbox').height() * coords.y)
    # $('#user_crop_w').val($('#cropbox')[0].naturalWidth/ $('#cropbox').width() * coords.w)
    # $('#user_crop_h').val($('#cropbox')[0].naturalHeight/ $('#cropbox').height() * coords.h)
    # @updatePreview(coords)
# 
  # updatePreview: (coords) =>
          # $('#preview').css
                  # width: Math.round(100/coords.w * $('#cropbox').width()) + 'px'
                  # height: Math.round(100/coords.h * $('#cropbox').height()) + 'px'
                  # marginLeft: '-' + Math.round(100/coords.w * coords.x) + 'px'
                  # marginTop: '-' + Math.round(100/coords.h * coords.y) + 'px'

$('#pop').on 'click', ->
  $('.imagepreview').attr 'src', $('#imageresource').attr('src')
  $('#imagemodal').modal 'show'
  
return