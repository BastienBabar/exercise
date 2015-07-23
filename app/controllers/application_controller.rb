class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_filter :find_groupevent, only: [:show, :update]
  before_filter :parse_request

  before_filter only: :create do
    unless @json.has_key?('groupevent') && @json['groupevent']['name']
      render nothing: true, status: :bad_request
    end
  end

  before_filter only: :update do
    unless @json.has_key?('groupevent')
      render nothing: true, status: :bad_request
    end
  end

  before_filter only: :create do
    @groupevent = Groupevent.find_by_name(@json['groupevent']['name'])
  end

  def show
    render json: @groupevent
  end

  def create
    if @groupevent.present?
      render nothing: true, status: :conflict
    else
      @groupevent = Groupevent.new
      @groupevent.assign_attributes(@json['groupevent'])
      if @groupevent.save
        render json: @groupevent
      else
        render nothing: true, status: :bad_request
      end
    end
  end

  def update
    @groupevent.assign_attributes(@json['groupevent'])
    if @groupevent.save
      render json: @groupevent
    else
      render nothing: true, status: :bad_request
    end
  end

  private
  def find_groupevent
    @groupevent = Groupevent.find_by_name(params[:name])
    render nothing: true, status: :not_found unless @groupevent.present?
  end

  def parse_request
    @json = JSON.parse(request.body.read)
  end
end
