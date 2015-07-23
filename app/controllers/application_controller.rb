class ApplicationController < ActionController::Base
  before_filter :parse_request
  before_filter :find_groupevent, only: [:show, :update, :destroy]

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
    render json: @groupevent, :except => [:id, :created_at, :updated_at]
  end

  def create
    if @groupevent.present?
      render nothing: true, status: :conflict
    else
      @groupevent = Groupevent.create(name: @name, startdate: @startdate, enddate: @enddate,
                                   description: @description, location: @location, status: @status)
      if @groupevent.save
        render json: @groupevent, :except => [:id, :created_at, :updated_at]
      else
        render nothing: true, status: :bad_request
      end
    end
  end

  def update
    @groupevent.name = @name
    @groupevent.startdate = @startdate
    @groupevent.enddate = @enddate
    @groupevent.description = @description
    @groupevent.location = @location
    @groupevent.status = @status
    if @groupevent.save
      render json: @groupevent, :except => [:id, :created_at, :updated_at]
    else
      render nothing: true, status: :bad_request
    end
  end

  def destroy
    @groupevent.status = -1
    if @groupevent.save
      render json: @groupevent, :except => [:id, :created_at, :updated_at]
    else
      render nothing: true, status: :bad_request
    end
  end

  private
  def find_groupevent
    @groupevent = Groupevent.find_by_name(@json['groupevent']['name'])
    render nothing: true, status: :not_found unless @groupevent.present?
  end

  def parse_request
    @json = JSON.parse(request.body.read)
    @name = @json['groupevent']['name']
    @startdate = @json['groupevent']['startdate']
    @enddate = @json['groupevent']['enddate']
    @description = @json['groupevent']['description']
    @location = @json['groupevent']['location']
    @status = @json['groupevent']['status']
  end
end
