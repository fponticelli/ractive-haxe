package ractive;

/**
* Ractive v.0.3.3
*/

@:native("Ractive")
extern class Ractive
{
	public var nodes(default, null) : Dynamic<js.html.Element>;
	public var partials(default, null) : Dynamic<String>;
	public var transitions(default, null) : Dynamic<RactiveTransitionFun>;
	public var data : {};

	@:overload(function(options : RactiveOptionsElJQuery) : Void {})
	@:overload(function(options : RactiveOptionsElString) : Void {})
	public function new(options : RactiveOptionsElElement) : Void;

	// TODO: handler in theory can have more than one argument
	public function on<T>(eventName : String, handler : T -> Void) : RactiveCancelObject;
	// TODO: check return type
	public function off<T>(?eventName : String, ?handler : T -> Void) : Ractive;

	public function get(?field : String) : Dynamic;

	@:overload(function(values : {}, ?complete : Void -> Void) : Ractive {})
	public function set(keypath : String, value : Dynamic, ?complete : Void -> Void) : Ractive;

	@:overload(function(values : {}, ?options : RactiveAnimateOptions) : RactiveStopObject {})
	public function animate(keypath : String, value : Dynamic, ?options : RactiveAnimateOptions) : RactiveStopObject;

	// TODO: check options
	// TODO: check return type
	public function fire(eventName : String, ?arg : Dynamic, ?arg1 : Dynamic, ?arg2 : Dynamic, ?arg3 : Dynamic) : Void;

	// TODO: check return type
	// TODO: complete is documented as "not yet implemented"
	public function update(?keypath : String, ?complete : Void -> Void) : Ractive;

	// TODO: check return type
	public function teardown(?complete : Void -> Void) : Ractive;

	@:overload(function(map : Dynamic<Dynamic -> Dynamic -> Void>, ?options : { ?init : Bool, ?context : Dynamic }) : RactiveCancelObject {})
	public function observe(keypath : String, complete : Dynamic -> Dynamic -> Void, ?options : { ?init : Bool, ?context : Dynamic }) : RactiveCancelObject;

	public function find(selector : String) : js.html.Element;

	// TODO: arrayaccess?
	public function findAll(selector : String) : ArrayAccess<js.html.Element>;
}

class RactiveEvents
{
	public static var teardown(default, null) : String = "teardown";
	public static var set(default, null) : String = "set";
	public static var update(default, null) : String = "update";
}

typedef RactiveOptions = {
	?template : String,
	data : {},
	?noIntro : Bool,
	?partials : {},
	?transitions : Dynamic<RactiveTransitionFun>,
	?complete : Void -> Void,
	?modifyArrays : Bool,
	?twoway : Bool,
	?lazy : Bool,
	?append : Bool,
	?preserveWhitespace : Bool,
	// TODO should be Boolean || Object
	?sanitize : Dynamic,
	// TODO array of ?
	?bindings : Array<Dynamic>
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

typedef RactiveTransitionFun = Dynamic -> (Void -> Void) -> ?{} -> ?{i : Int} -> ?Bool -> Void;

typedef RactiveAnimateOptions = {
	?duration : Int,
	// TODO String || Function
	?easing : Dynamic,
	?step : Float -> Float -> Void,
	?complete : ?Float -> ?Float -> Void
};

typedef RactiveStopObject = {
	stop : Void -> Void
};

typedef RactiveCancelObject = {
	cancel : Void -> Void
};

// TODO check what index is
typedef RactiveProxyEvent = {
	node : js.html.Element,
	original : js.html.Event,
	keypath : String,
	context : Dynamic,
	index : Dynamic
};