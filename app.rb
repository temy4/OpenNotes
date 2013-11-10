# coding: utf-8
require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'nokogiri'
#require "sinatra-authentication"
require './config/environments'
require './models/notepad'
require './models/note'
require './models/category'

# use Rack::Session::Cookie, :secret => 'Y0ur s3cret se$$ion key'

class App < Sinatra::Application

  before do
    content_type :html, 'charset' => 'utf-8'
  end

  get '/' do
    haml :index
  end

  get '/mynotes' do
  	@notepads = Notepad.where(:parent => 1, :typeofnp => 1).order(:order);
    @categories = Category.all;
    haml :notes;
  end

  get '/notes' do
    notes = Note.where(:notepad_id => params[:id]);
    notes.each do |note|
      if note.title.nil? || note.title.empty? 
        note.title = "Untitled Note (##{note.id})";
        note.note_text = note.note_text.length > 200 ? (Nokogiri::HTML(note.note_text).text[0...200] + '...') : note.note_text
      end
    end
    notes.to_json;
  end

  post '/notes/new' do
    entry = Note.new;
    entry.title = params[:title];
    entry.note_text = params[:text];
    entry.tags = params[:tags];
    entry.notepad_id = params[:nid];
    if entry.save 
      status 200
      entry.to_json
    else
      status 500
      "saving_error"
    end
  end
  
  post '/notes/edit' do
    entry = Note.find(params[:id]);
    entry.title = params[:title];
    entry.note_text = params[:text];
    entry.tags = params[:tags];
    if entry.save 
      status 200
      entry.to_json
    else
      status 500
      "saving_error"
    end
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
	  		parent = Notepad.where(:parent => 0);
        children = Notepad.where(:parent => parent.first.id);
        children.to_json;
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
      parent = Notepad.where(:parent => params[:id]);
      parent.each do |np|
        np.notes_count = np.notes.count()
      end
      parent.to_json;
    else
      status 500
      "saving_error"
    end
  end

end