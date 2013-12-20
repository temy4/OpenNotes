var a = 0;

(function(jQuery){
	var CURRENT_ENTRY = 0;
	var CURRENT_NP = 0;
	var LOCK_QUERY = false;

	$('#addNotepad').on('hide.bs.modal', function () {
	  	$('#notepad-name').val('')
	})

	$('#addSection').on('hide.bs.modal', function () {
	  	$('#section-name').val('')
	  	$('#notepad-id').val('')
	})

	$('.addSectionLink').click(function () {
		var npid = $(this).data('notepad-id')

	  	$('#notepad-id').val(npid)
	  	$('#np-name').text('Notepad: ' + $('#notepad-' + npid).text())
	})

	$('#newnotepadclose').click(function(){
		$('#notepad-name').val('')
	})

	$('#newsectionclose').click(function(){
		$('#section-name').val('')
		$('#notepad-id').val('')
	})

	$('#createnotepad').click(function(){
		if(LOCK_QUERY){
			return false;
		}
		LOCK_QUERY = true;

		var name = $('#notepad-name').val();

		$.ajax({
			type: "PUT",
			dataType: 'json',
			url: "/notepad/new",
			data: { "name": name },
			success: function(response){
				$('#notepads').html('')
				$.each(response, function(k, v){
					$('#notepads').append('<span id="notepad-' + v.id + '" class="list-group-item list-heading">' + v.name + '</span>')
					$('#notepad-' + v.id).append(
						'<span class="pull-right">' + 
						'<a class="pull-right" data-placement="right", data-placement="right" href="#" title="Add Section" href="#addSection" class="addSectionLink" data-notepad-id="' + v.id + '" data-target="#addSection" data-toggle="modal">' + 
						'<span class=" glyphicon glyphicon-plus"></span></a>' + 
						'<span class="sections" data-notepad-id="' + v.id + '" "id" = "sections-' + v.id + '"'
					)
				})
				LOCK_QUERY = false;
			},
			error: function(response, status, error){
				switch(response.responseText){
					case 'notepad_exists':
						alert('Notepad "' + name + '" already exists')
					break
					case 'saving_error':
						alert('Saving error')
					break
					default:
						alert('Unknown error')
				}
				LOCK_QUERY = false;
			}
		})
	})
	function init(){
		$('#createsection').on("click", function(){
			if(LOCK_QUERY){
				return false;
			}
			LOCK_QUERY = true;

			var name = $('#section-name').val();
			var npid = $('#notepad-id').val();

			$.ajax({
				type: "PUT",
				dataType: 'json',
				url: "/notepad/section/new",
				data: { "id": npid, "name": name },
				success: function(response){
					$('#sections-' + npid).html('')
					$.each(response, function(k, v){
						var active_class = '';
						if (CURRENT_NP == v.id){
							active_class = ' active';
						}
						$('#sections-' + npid).append(
							'<a href="#" id="section-' + v.id + '" data-notepad-id="' + v.id + '" class="list-group-item np-section' + active_class + '" data-notepad-id="' + v.id + '" data-placement="right" data-toggle="tooltip">' +
							'<span class="badge pull-right">' +
							v.notes_count +
							'</span>' + v.name + '</a>'
						)
					})
					init ();
					$('#notepad-name').val('');
					LOCK_QUERY = false;
				},
				error: function(response, status, error){
					switch(response.responseText){
						case 'notepad_exists':
							alert('Notepad "' + name + '" already exists')
						break
						case 'saving_error':
							alert('Saving error')
						break
						default:
							alert('Unknown error')
					}
					$('#notepad-name').val('');
					LOCK_QUERY = false;
				}
			})
		})

		$('.np-section').on("click", function(){
			$('.np-section').removeClass('active');
			$(this).addClass('active');
			$('#editor-main').removeClass('hidden');

			reload_notes($(this).attr('data-notepad-id'));
		})
	}
	$('#note-title, #editor, .bootstrap-tagsinput').keyup(function(){
		var title = $('#note-title').val();
		var text = $('#editor').html();
		var tags = $('#tags').val();

		if ( ( title != '' || text != '' ) && CURRENT_NP > 0 ){
			if ( CURRENT_ENTRY == 0 ){
				save_note(title, text, tags, CURRENT_NP);
			}
			else{
				update_note(title, text, tags, CURRENT_ENTRY);
			}

			reload_notes(CURRENT_NP);
		}
	})

	function save_note(title, text, tags, notepad_id){
		if(LOCK_QUERY){
			return false;
		}
		LOCK_QUERY = true;

		$.ajax({
			type: "POST",
			dataType: 'json',
			url: "/notes/new",
			data: { "nid": notepad_id, "title": title, "text": text, "tags": tags },
			success: function(response){
				CURRENT_ENTRY = response.id;
				LOCK_QUERY = false;
				reload_notes(CURRENT_NP);
			},
			error: function(response, status, error){
				alert('Unknown error');
				LOCK_QUERY = false;
			}
		})
	}

	function update_note(title, text, tags, entry_id){
		if(LOCK_QUERY){
			return false;
		}
		LOCK_QUERY = true;

		$.ajax({
			type: "POST",
			dataType: 'json',
			url: "/notes/edit",
			data: { "id": entry_id, "title": title, "text": text, "tags": tags },
			success: function(response){
				CURRENT_ENTRY = response.id;
				LOCK_QUERY = false;
				reload_notes(CURRENT_NP);
			},
			error: function(response, status, error){
				alert('Unknown error');
				LOCK_QUERY = false;
			}
		})
	}

	function reload_notes(notepad_id){
        CURRENT_NP = notepad_id;
		$.ajax({
			type: "GET",
			dataType: 'json',
			url: "/notes",
			data: { "id": notepad_id },
			success: function(response){
				$('#notes-list').html('');

				$.each(response, function(k, v){
					var created_at = new Date(v.created_at);
					$('#notes-list').append(
						'<a href="#" id="note-' + v.id + '" class="list-group-item">' + 
						'<h4 class="list-group-item-heading">' +
						helpers.cutString(v.title, 80) +
						'<span class="label label-warning pull-right">&nbsp;&nbsp;</span></h4>' +
						'<p class="list-group-item-text">' +
						'<span class="badge">' + helpers.humanizeDate(v.created_at) + '</span>&nbsp;' +
						helpers.cutString(v.note_text, 100) +
						'</p>' +
						'</a>'
					)
				})
			},
			error: function(response, status, error){
				alert('Unknown error')
			}
		})
	}



	init();

})( jQuery );