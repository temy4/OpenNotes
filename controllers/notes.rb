class App < Sinatra::Application
  get '/notes' do
    notes = Note.where(:notepad_id => params[:id]);
    notes.each do |note|
      if note.title.nil? || note.title.empty? 
        note.title = "Untitled Note (##{note.id})";
        note.note_text = note.note_text.length > 200 ? (Nokogiri::HTML(note.note_text).text[0...200] + '...') : note.note_text;
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
      status 200;
      entry.to_json;
    else
      status 500;
      "saving_error";
    end
  end
  
  post '/notes/edit' do
    entry = Note.find(params[:id]);
    entry.title = params[:title];
    entry.note_text = params[:text];
    entry.tags = params[:tags];
    if entry.save 
      status 200;
      entry.to_json;
    else
      status 500;
      "saving_error";
    end
  end
end