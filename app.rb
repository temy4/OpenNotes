# coding: utf-8
require 'sinatra'
require 'sinatra/activerecord'
#require "sinatra-authentication"
require './config/environments'
require './models/notepad'
require './models/note'

# use Rack::Session::Cookie, :secret => 'Y0ur s3cret se$$ion key'

class App < Sinatra::Application

  before do
    content_type :html, 'charset' => 'utf-8'
  end

  get '/' do
    haml :index
  end

  get '/mynotes' do
  	@notepads = Notepad.where(:parent => 0, :typeofnp => 1).order(:order)
    haml :notes
  end

  put '/notepad/new' do
  	if Notepad.where(:parent => 0, :name => params[:name].capitalize).count > 0
  		status 409
  		"notepad_exists"
  	else
  		created = Time.now
	  	notepad = Notepad.new
	  	notepad.name = params[:name].capitalize
	  	notepad.typeofnp = 1
	  	notepad.order = Notepad.count() > 0 ? Notepad.maximum(:order) + 100 : 100;
	  	notepad.created_at = created
	  	notepad.updated_at = created
	  	if notepad.save
	  		status 200
	  		parents = Notepad.where(:parent => 0).order(:order)
	  	else
	  		status 500
	  		"saving_error"
	  	end
  	end
  end

  put '/notepad/section/new' do
    created = Time.now
    notepad = Notepad.new
    notepad.name = params[:name].capitalize
    notepad.typeofnp = 1
    notepad.parent = params[:id]
    notepad.order = 110;
    notepad.created_at = created
    notepad.updated_at = created
    if notepad.save
      status 200
      Notepad.all.order(:order).to_json
    else
      status 500
      "saving_error"
    end
  end

end