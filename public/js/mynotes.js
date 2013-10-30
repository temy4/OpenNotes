var a = 0;

(function(jQuery){
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
						'<span class=" glyphicon glyphicon-plus"></span></a>'
					)
				})
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
			}
		})
	})

	$('#createsection').click(function(){
		var name = $('#section-name').val();
		var npid = $('#notepad-id').val();

		$.ajax({
			type: "PUT",
			dataType: 'json',
			url: "/notepad/section/new",
			data: { "id": npid, "name": name },
			success: function(response){
				$('#notepads').html('')
				$.each(response, function(k, v){
					$('#notepads').append('<span id="notepad-' + v.id + '" class="list-group-item list-heading">' + v.name + '</span>')
					$('#notepad-' + v.id).append(
						'<span class="pull-right">' + 
						'<a class="pull-right" data-placement="right" data-toggle="tooltip">' + 
						'<span class=" glyphicon glyphicon-plus"></span></a>'
					)
				})
				$('#notepad-name').val('')
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
				$('#notepad-name').val('')
			}
		})
	})
})( jQuery );