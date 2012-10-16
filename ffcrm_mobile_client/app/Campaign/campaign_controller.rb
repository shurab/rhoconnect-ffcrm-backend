require 'rho/rhocontroller'
require 'helpers/browser_helper'

class CampaignController < Rho::RhoController
  include BrowserHelper

  # GET /Campaign
  def index
    @campaigns = Campaign.find(:all)
    render :back => '/app'
  end

  # GET /Campaign/{1}
  def show
    @campaign = Campaign.find(@params['id'])
    if @campaign
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Campaign/new
  def new
    @campaign = Campaign.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Campaign/{1}/edit
  def edit
    @campaign = Campaign.find(@params['id'])
    if @campaign
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Campaign/create
  def create
    @campaign = Campaign.create(@params['campaign'])
    redirect :action => :index
  end

  # POST /Campaign/{1}/update
  def update
    @campaign = Campaign.find(@params['id'])
    @campaign.update_attributes(@params['campaign']) if @campaign
    redirect :action => :index
  end

  # POST /Campaign/{1}/delete
  def delete
    @campaign = Campaign.find(@params['id'])
    @campaign.destroy if @campaign
    redirect :action => :index  
  end
end
