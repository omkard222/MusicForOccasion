# Landing page controller
class HomeController < ApplicationController
  include ApplicationHelper
  def index
    @profiles = Profile.musician_has_services
    @profiles = priority_ordering(@profiles, 6)
  end

  def new_visitor
    session[:is_musician] = false
    redirect_to new_user_registration_path
  end

  def new_visitor_try_book
    session[:is_musician] = false
    session[:try_book] = params[:profile_id]
    redirect_to new_user_registration_path
  end

  def old_visitor_try_book
    session[:try_book] = params[:profile_id]
    redirect_to new_user_session_path
  end

  def new_musician
    session[:is_musician] = true
    redirect_to new_user_registration_path
  end

  def preferred_currency
    if params[:currency]
      session[:preferred_currency] = params[:currency]
    else
      session[:preferred_currency] = "USD"
    end
    redirect_to :back
  end

  def privacy_policy
  end

  def terms_and_conditions
  end

  def faq
  end

  def cancellation_policies
  end

  def about
  end

  def how_it_works
  end

  def become_a_partner
  end

  def submit_become_a_partner
    AdminMessageMailer.new_partner(params[:name], params[:email], params[:subject], params[:message]).deliver_later
    redirect_to :become_a_partner, notice: 'Thank you, we will be in touch.'
  end

  def browse_musicians
    if params[:back] == "ok"
      if session[:stage_name].present? || session[:location].present? || session[:genres].present? || session[:instruments].present?
        params[:stage_name] = session[:stage_name] 
        params[:location] = session[:location] 
        params[:genres]= session[:genres]
        params[:instruments] = session[:instruments]
        @select2_form = {
          instrument_id: [['', Instrument.order(:name).all.map { |i| ["#{i.name}", i.id] }]],
          genre_id: [['', Genre.order(:name).all.map { |g| ["#{g.name}", g.id] }]]
        }
        @profiles = Profile.musician_has_services.joins(:user, :musician_genres)
        @profiles = stage_name_filter(@profiles, params[:stage_name]) if params[:stage_name].present?
        @profiles = genres_filter(@profiles, params[:genres]) if params[:genres].present?
        @profiles = instruments_filter(@profiles, params[:instruments]) if params[:instruments].present?
        @search_term = params[:location]
        @profiles = location_filter(@profiles, @search_term) if @search_term.present?
        @profiles = priority_ordering(@profiles, 50)
        @stage_name = params[:stage_name]
        @location = params[:location]
        @genres = params[:genres].split(",") if params[:genres].present?
        @instruments = params[:instruments].split(",") if params[:instruments].present?
        # session[:stage_name] = ""
        # session[:location] = ""
        # session[:genres] = ""
        # session[:instruments] = ""
        # session[:stage_name] = nil 
        # session[:location] = nil 
        # session[:genres] = nil 
        # session[:instruments] = nil
      end    
    else
      @profiles = Profile.musician_has_services
      @select2_form = {
        instrument_id: [['', Instrument.order(:name).all.map { |i| ["#{i.name}", i.id] }]],
        genre_id: [['', Genre.order(:name).all.map { |g| ["#{g.name}", g.id] }]]
      }
      @search_term = params[:location]
      @profiles = location_filter(@profiles, @search_term) if @search_term.present?
      @profiles = priority_ordering(@profiles, 50)
    end  
  end

  def search_musicians
    session[:stage_name] = params[:stage_name]
    session[:location] = params[:location]
    session[:genres] = params[:genres]
    session[:instruments] = params[:instruments]
    @profiles = Profile.musician_has_services.joins(:user, :musician_genres)
    @profiles = stage_name_filter(@profiles, params[:stage_name]) if params[:stage_name].present?
    @profiles = genres_filter(@profiles, params[:genres]) if params[:genres].present?
    @profiles = instruments_filter(@profiles, params[:instruments]) if params[:instruments].present?
    @search_term = params[:location]
    @profiles = location_filter(@profiles, @search_term) if @search_term.present?
    @profiles = priority_ordering(@profiles, 50)
    render partial: 'home/list_musicians'
  end

  def contact
  end

  def submit_contact_us
    AdminMessageMailer.contact_us(params[:name], params[:email], params[:subject], params[:message]).deliver_later
    redirect_to :contact, notice: 'Thank you, we will be in touch.'
  end

  def help
  end

  private

  def location_filter(profiles, location)
    profiles.near(@search_term, ENV['DEFAULT_LOCATION_RADIUS']).order('distance')
  end

  def stage_name_filter(profiles, stage_name)
    profiles.where("lower(profiles.stage_name) like '%#{stage_name.downcase}%'")
  end

  def genres_filter(profiles, genres)
    profiles.joins(:musician_genres).where(musician_genres: { genre_id: genres.split(',') })
  end

  def instruments_filter(profiles, instruments)
    profiles.joins(:instruments).where(instruments: { id: instruments.split(',') })
  end

  def priority_ordering(profiles, amount)
    profiles.order('position_priority DESC').first(amount)
  end
end
