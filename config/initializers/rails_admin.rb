RailsAdmin.config do |config|

  ### Popular gems integration
  
  # == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :admin
  end
  config.current_user_method(&:current_admin)

  ## == Cancan ==
  config.authorize_with :cancan, AdminAbility

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User',
  #                   'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.main_app_name = ["GigBazaar", "Admin"]
  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
  config.model 'MailboxerConversation' do
   visible false
  end
  config.model 'MailboxerNotification' do
   visible false
  end
  config.model 'MailboxerReceipt' do
   visible false
  end
  config.model 'MusicianGenre' do
    visible false
  end
  config.excluded_models.concat([Mailboxer::Notification,
                                 Mailboxer::Receipt,
                                 Mailboxer::Conversation,
                                 Mailboxer::Message,
                                 Mailboxer::Conversation::OptOut])

  config.model 'Admin' do
    [list, show, edit, create].each do
      field :email
      field :password
      field :password_confirmation
      field :name do
        label 'Username'
      end
      field :role
      field :profile_picture
    end

    list do
      field :profile_picture do
        visible false
      end

      field :password do
        visible false
      end

      field :password_confirmation do
        visible false
      end
    end

    show do
      field :password do
        visible false
      end

      field :password_confirmation do
        visible false
      end
    end
  end

  config.model 'User' do
    label I18n.t "labels.accounts"
    [list, show, edit].each do
      field :name do
        help false
        label I18n.t "labels.account"
      end
      field :profiles do
        help false
        column_width 300
      end
      field :email do
        help false
      end
      field :reset_password do
        visible false
      end
      
      fields :phone_number,
             :banned do
        help ''
      end

      field :premium_account do
        help false
      end
      
      #field :bank_account
      field :billing_address
      field :services
      # user's details
      fields :sign_in_count,
             :current_sign_in_at,
             :last_sign_in_at,
             :current_sign_in_ip,
             :last_sign_in_ip,
             :confirmed_at,
             :confirmation_sent_at,
             :unconfirmed_email,
             :provider,
             :uid do
        read_only true
        help ''
      end
    end

    list do
      field :name do
        label I18n.t "labels.account"
        formatted_value do
          bindings[:view].link_to value, "/admin/user/#{bindings[:object].id}"
        end
      end
    end

    edit do
      configure :reset_password do
        partial 'reset_password'
        help ''
      end
    end
  end

  config.model 'Profile' do
    configure :History do
      pretty_value do
        util = bindings[:object]
        if util.profile_history.present?
          uu = User.where(:email => util.previous_account_mail).first
           a =  %{<div id="history">
                <p>#{util.stage_name} created by account <a href="/admin/user/#{uu.id}">#{uu.first_name} #{uu.last_name}</a> with email #{util.previous_account_mail} on #{util.created_at.strftime('%d/%m/%y')}</p>
                </div >}
           b = %{<div></div>}
           fb1 = %{<div></div>}
           twr1 = %{<div></div>} 
           d = %{<div id="append_history"></div>}      
          util.profile_history.each do |p|
            user_one = User.where(:email => p.new_user_email).first 
            c = %{<div id="history#{p.id}">
              <p>#{util.stage_name} migrated to account <a href="/admin/user/#{user_one.id}">#{user_one.first_name} #{user_one.last_name}</a> with email #{user_one.email} on #{p.migration_date.strftime('%d/%m/%y')}</p>
            </div >}
            b = b+c 
          end
          if util.fb_disconnect_time.present?
             fb2 = %{<p> Facebook connected by account <a href="/admin/user/#{util.id}">#{util.user.first_name} #{util.user.last_name}</a> with external account #{util.invite_friend_email} on #{util.fb_connect_time.strftime('%d/%m/%y')}</p> 
                    <p> Facebook disconnected by account <a href="/admin/user/#{util.id}">#{util.user.first_name} #{util.user.last_name}</a>  with external account #{util.invite_friend_email} on #{util.fb_disconnect_time.strftime('%d/%m/%y')}</p> }
             fb1 = fb1+fb2
          elsif util.fb_connect_time.present?
             fb2 = %{<p> Facebook connected by account <a href="/admin/user/#{util.id}">#{util.user.first_name} #{util.user.last_name}</a> with external account #{util.invite_friend_email} on #{util.fb_connect_time.strftime('%d/%m/%y')}</p> }
             fb1 = fb1+fb2   
          end

          if util.twitter_disconnect_time.present?
             twr2 = %{<p> Twitter connected by account <a href="/admin/user/#{util.id}">#{util.user.first_name} #{util.user.last_name}</a> with external account #{util.twitter_friend_email} on #{util.twitter_connect_time.strftime('%d/%m/%y')}</p>  
                    <p> Twitter disconnected by account <a href="/admin/user/#{util.id}">#{util.user.first_name} #{util.user.last_name}</a> with external account #{util.twitter_friend_email} on #{util.twitter_disconnect_time.strftime('%d/%m/%y')}</p> }
             twr1 = twr1+twr2
          elsif util.twitter_connect_time.present?
             twr2 = %{<p> Twitter connected by account <a href="/admin/user/#{util.id}">#{util.user.first_name} #{util.user.last_name}</a> with external account #{util.twitter_friend_email} on #{util.twitter_connect_time.strftime('%d/%m/%y')}</p> }
             twr1 = twr1+twr2   
          end    
            (a+b+d+fb1+twr1).html_safe  
           
        else
          a =  %{<div id="history">
            <p>#{util.stage_name} created by account <a href="/admin/user/#{util.user.id}">#{util.user.first_name} #{util.user.last_name}</a> with email #{util.user.email} on #{util.created_at.strftime('%d/%m/%y')}</p>
            </div ><div id="append_history"></div>}
          fb1 = %{<div></div>}
          twr1 = %{<div></div>}
          if util.fb_disconnect_time.present?
             fb2 = %{<p> Facebook connected by account <a href="/admin/user/#{util.id}">#{util.user.first_name} #{util.user.last_name}</a> with external account #{util.invite_friend_email} on #{util.fb_connect_time.strftime('%d/%m/%y')}</p> 
                    <p> Facebook disconnected by account <a href="/admin/user/#{util.id}">#{util.user.first_name} #{util.user.last_name}</a> with external account #{util.invite_friend_email} on #{util.fb_disconnect_time.strftime('%d/%m/%y')}</p> }
             fb1 = fb1+fb2
          elsif util.fb_connect_time.present?
             fb2 = %{<p> Facebook connected by account <a href="/admin/user/#{util.id}">#{util.user.first_name} #{util.user.last_name}</a> with external account #{util.invite_friend_email} on #{util.fb_connect_time.strftime('%d/%m/%y')}</p> }
             fb1 = fb1+fb2   
          end 
          if util.twitter_disconnect_time.present?
             twr2 = %{<p> Twitter connected by account <a href="/admin/user/#{util.id}">#{util.user.first_name} #{util.user.last_name}</a> with external account #{util.twitter_friend_email} on #{util.twitter_connect_time.strftime('%d/%m/%y')}</p>  
                    <p> Twitter disconnected by account <a href="/admin/user/#{util.id}">#{util.user.first_name} #{util.user.last_name}</a> with external account #{util.twitter_friend_email} on #{util.twitter_disconnect_time.strftime('%d/%m/%y')}</p> }
             twr1 = twr1+twr2
          elsif util.twitter_connect_time.present?
             twr2 = %{<p> Twitter connected by account <a href="/admin/user/#{util.id}">#{util.user.first_name} #{util.user.last_name}</a> with external account #{util.twitter_friend_email} on #{util.twitter_connect_time.strftime('%d/%m/%y')}</p> }
             twr1 = twr1+twr2   
          end 
          (a+fb1+twr1).html_safe    
        end  
      end
      children_fields [:stage_name] # will be used for searching/filtering, first field will be used for sorting
      read_only true # won't be editable in forms (alternatively, hide it in edit section)
    end
    configure :Migration do
      pretty_value do
        util = bindings[:object]
        %{<div class="blah">
            <div id="show_notice" style="margin-left:10px;color:green;font-size:14px;"></div>
            <form action="/profiles/user_email_change" method="post" id="email_change">
              <div class="form-group">
                Migrate profile to email account:
                <input type="text" name="email" id="user_email" required>
                <input type="hidden" name="profile_id" value="#{util.id}" id="profile_id">
                <input type="hidden" name="old_email" value="#{util.user.email}" id="old_email">
                <input type="button" value="Send" id="userchange" class="btn btn-sm btn-info">
              </div>  
            </form> 
            <p></p>
          </div >}.html_safe
      end
      children_fields [:stage_name] # will be used for searching/filtering, first field will be used for sorting
      read_only true # won't be editable in forms (alternatively, hide it in edit section)
    end
    object_label_method :virtual_name
    parent User
    [list, show, edit].each do
      field :virtual_name do
        help false
        label I18n.t "labels.virtual_name"
      end
      field :user do
        help false
        nested_form false
        inline_add false
        inline_edit false
        label I18n.t "labels.account"
      end
      field :location do
        help false
      end
      field :headline
      field :biography
      field :birthday do
        label I18n.t "labels.birthday"
      end
      field :instruments
      field :profile_picture
      field :additional_pictures
    end

    show do
      field :History do
      end
      field :Migration do
      end  
    end

    list do
      field :virtual_name do
        label label I18n.t "labels.virtual_name"
        formatted_value do
          bindings[:view].link_to value, "/admin/profile/#{bindings[:object].id}"
        end
      end
      field :profile_picture do
        visible false
      end
      field :additional_pictures do
        visible false
      end
    end

  end

  config.model 'Instrument' do
    [list, show, edit].each do
      field :id
      field :name
    end

    edit do
      field :id do
        visible false
      end
    end
  end

  config.model 'AdditionalPicture' do
    visible false
    edit do
      field :image
    end
  end

  config.model 'Service' do
    visible false
  end

  config.model 'BankAccount' do
    visible false
    edit do
      field :name do
        label 'Name of account holder'
      end
      field :bank_name do
        label 'Name of bank'
      end
      field :acc_number do
        label 'Bank account number '
      end
    end
  end

  config.model 'BillingAddress' do
    visible false
    edit do
      field :address1
      field :address2
      field :post_code do
        label 'Postcode'
      end
      field :city
      field :country
    end
  end

  config.model 'BookingRequest' do
    config.total_columns_width = 900
    [list, show, edit].each do
      field :id do
        label 'Ref. number'
        column_width 100
      end
      field :date do
        label 'Booking date'
        column_width 150
      end
      field :profile do
        label 'Requested by'
        column_width 150
      end
      field :service_proposer do
        column_width 150
      end
      field :status do
        column_width 100
      end
      field :confirmed_price do
        column_width 150
      end
      field :service do
        column_width 100
      end
      field :currency
      field :created_at
      field :updated_at
    end
  end
end
