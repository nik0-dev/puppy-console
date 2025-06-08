class_name ScriptParser 

var data : Script

class ScriptParserMethodResult:
	var _name : String = ""
	var _doc_comment : String = "" 
	var _parameters : String = ""
	var _is_ok : bool = false
	var _required : int = 0
	var _argc : int = 0
	var _return : String = ""
	
	func get_name(): return _name
	func get_doc_comment(): return _doc_comment
	func get_parameters(): return _parameters
	func get_return(): return _return
	
	func is_ok(): return _is_ok
	
	func _to_string() -> String:
		return "{ name: \"%s\", doc: \"%s\", params: %s, return \"%s\" }" % [_name, _doc_comment, _parameters, _return]

@warning_ignore("shadowed_variable")
func _init(data: Script) -> void:
	self.data = data

func get_method_info(method_name: String) -> ScriptParserMethodResult:
	var regex := RegEx.new()
	regex.compile(r"(?:#{2,} (?<doc>.+)\s+)?func +(?<name>%s)\((?<params>.+)?\) *(?:-> *(?<return>.+\b) *)?" % method_name)
	
	var res := ScriptParserMethodResult.new()
	var regex_match = regex.search(data.source_code)
	
	## (.+?(?:\[.*,.*\])?)(?:,\s*|$) -- comma separated regex
	
	if regex_match != null:
		res._name = regex_match.get_string("name")
		res._doc_comment = regex_match.get_string("doc")
		regex.compile(r"(.+?(?:\[.*,.*\])?)(?:,\s*|$)")
		res._parameters = str(regex.search_all(regex_match.get_string("params")).map(func(m: RegExMatch): return m.get_string(1)))
		res._return = regex_match.get_string("return")
		
		res._is_ok = true
		
	return res 
