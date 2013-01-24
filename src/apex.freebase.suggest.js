function attachListener(el_id, apikey, lang) {
  $(el_id).suggest({
    "key": apikey,
	"lang": lang
  });
}

function attachFilteredListener(el_id, apikey, lang, filter_string) {
  $(el_id ).suggest({
    "key": apikey,
	"lang": lang,
	"filter": filter_string
  });
}

function attachHandler(el_id) {
  $(el_id).bind("fb-select", function(e, data) {
     alert(data.name + ", " + data.id);
  });
}