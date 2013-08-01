package ractive;

/**
* Ractive v.0.3.3
*/

@:native("Ractive")
extern class Ractive
{
	@:overload(function(options : RactiveOptionsElJQuery) : Void {})
	@:overload(function(options : RactiveOptionsElElement) : Void {})
	public function new(options : RactiveOptionsElString) : Void;

	// TODO: replace Dynamic
	// TODO: check return type
	public function on(event : String, handler : Dynamic -> Void) : Void;

	// TODO: check options
	public function get(field : String) : Dynamic;

	// TODO: check options
	// TODO: check return type
	@:overload(function(values : {}) : Void {})

	// TODO: check options
	// TODO: check return type
	public function set(field : String, value : Dynamic) : Void;

	// TODO: check options
	// TODO: check return type
	public function fire(event : String, payload : Dynamic) : Void;
}

typedef RactiveOptions = {
	template : String,
	data : {},
	?noIntro : Bool
}

typedef RactiveOptionsElString = {>RactiveOptions,
	el : String
};

typedef RactiveOptionsElElement = {>RactiveOptions,
	el : js.html.Element
};

typedef RactiveOptionsElJQuery = {>RactiveOptions,
	el : js.JQuery
};