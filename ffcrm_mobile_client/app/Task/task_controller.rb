require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TaskController < Rho::RhoController
  include BrowserHelper

  # GET /Task
  def index
    @tasks = Task.find(:all)
    render :back => '/app'
  end

  # GET /Task/{1}
  def show
    @task = Task.find(@params['id'])
    if @task
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Task/new
  def new
    @task = Task.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Task/{1}/edit
  def edit
    @task = Task.find(@params['id'])
    if @task
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Task/create
  def create
    @task = Task.create(@params['task'])
    redirect :action => :index
  end

  # POST /Task/{1}/update
  def update
    @task = Task.find(@params['id'])
    @task.update_attributes(@params['task']) if @task
    redirect :action => :index
  end

  # POST /Task/{1}/delete
  def delete
    @task = Task.find(@params['id'])
    @task.destroy if @task
    redirect :action => :index  
  end
end
