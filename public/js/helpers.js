var helpers = {
	cutString: function (str, limit) {
		if (str.length > limit) {
			str = str.substr(0, limit) + '...';
		}
		return str;
	},
	humanizeDate: function (date_string){
		var today = new Date();
		var o_date = new Date(date_string);
		if ( today.getMonth() == o_date.getMonth() && today.getYear() == o_date.getYear() ){
			if (today.getDay() == o_date.getDay()){
				return 'Today at ' + o_date.toLocaleTimeString()
			}
			else if (today.getDay() == o_date.getDay() + 1){
				return 'Yesterday';
			}
			else{
				return o_date.toLocaleTimeString();
			}
		}
		else{
			return o_date.toLocaleTimeString();
		}
	}
};