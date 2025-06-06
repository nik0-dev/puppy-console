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
		return "{ name: %s, doc: %s, params: %s, return %s }" % [_name, _doc_comment, _parameters, _return]


@warning_ignore("shadowed_variable")
func _init(data: Script) -> void:
	self.data = data

func get_method_info(method_name: String) -> ScriptParserMethodResult:
	var regex := RegEx.new()
	var DOC := r"(?:#{2,} +(?<doc>.+)\s+)?"
	var NAME := r"func +(?<name>%s)" % method_name
	var PARAMS := r"\((?<params>.*)\)"
	var RETURN := r"(?: *-> *(?<return>[^ ]+))? *:"
	var regex_str := DOC + NAME + PARAMS + RETURN
	regex.compile(regex_str)
	
	var res := ScriptParserMethodResult.new()
	var regex_match = regex.search(data.source_code)
	
	if regex_match != null:
		res._name = regex_match.get_string("name")
		res._doc_comment = regex_match.get_string("doc")
		res._parameters = regex_match.get_string("params")
		res._return = regex_match.get_string("return")
		
		res._is_ok = true
		
	return res 
