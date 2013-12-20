class App < Sinatra::Application
  put '/notepad/new' do
  	if Notepad.where(:parent => 0, :name => params[:name].capitalize).count > 0
  		status 409;
  		"notepad_exists";
  	else
      parent = Notepad.where(:parent => 0); # TODO: Refactor after
  		created = Time.now;
	  	notepad = Notepad.new;
	  	notepad.name = params[:name].capitalize;
	  	notepad.typeofnp = 1;
	  	notepad.order = Notepad.count() > 0 ? Notepad.maximum(:order) + 100 : 100;
      notepad.parent = parent.first.id;
	  	notepad.created_at = created;
	  	notepad.updated_at = created;
	  	if notepad.save
	  		status 200
        children = Notepad.where(:parent => parent.first.id);
        children.to_json;
	  	else
	  		status 500;
	  		"saving_error";
	  	end
  	end
  end

  put '/notepad/section/new' do
    created = Time.now;
    notepad = Notepad.new;
    notepad.name = params[:name].capitalize;
    notepad.typeofnp = 1;
    notepad.parent = params[:id];
    notepad.order = 110;
    notepad.created_at = created;
    notepad.updated_at = created;
    if notepad.save
      status 200;
      parent = Notepad.where(:parent => params[:id]);
      parent.each do |np|
        np.notes_count = np.notes.count();
      end
      parent.to_json;
    else
      status 500
      "saving_error"
    end
  end
end