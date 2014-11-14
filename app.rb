# coding: utf-8
require 'sinatra'
require 'sinatra/activerecord'
require 'json'
# require 'nokogiri', '~> 1.5.6'
# Models
require './config/environments'
require './models/notepad'
require './models/note'
# Controllers
require './controllers/notepads'
require './controllers/notes'

class App < Sinatra::Application

  before do
    content_type :html, 'charset' => 'utf-8';
  end

  get '/' do
    haml :index;
  end

  get '/mynotes' do
  	@notepads = Notepad.where(:parent => 1, :typeofnp => 1).order(:order);
    #@categories = Category.all;
    haml :notes;
  end

end