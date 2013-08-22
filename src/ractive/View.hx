package ractive;

import js.html.Element;
import ractive.Ractive;
import Map;
import thx.core.AnonymousMap;

#if !display @:autoBuild(ractive.TemplateBuilder.build()) #end
class View<T>
{
	var ractive : Ractive;
	public function new(options : ViewOptions<T>)
	{
		if(null == options.template)
			options.template = getTemplate();

		ractive     = new Ractive(cast options);
		nodes       = new AnonymousMap(ractive.nodes);
		partials    = new AnonymousMap(ractive.partials);
		transitions = new AnonymousMap(ractive.transitions);
	}

	public var nodes(default, null) : IMap<String, Element>;
	public var partials(default, null) : IMap<String, String>;
	public var transitions(default, null) : IMap<String, RactiveTransitionFun>;
	public var data(get, set) : T;

	function getTemplate() : String
	{
		var name = Type.getClassName(Type.getClass(this)),
			path = (function() {
					var temp = name.split(".");
					temp[temp.length-1] = temp[temp.length-1].toLowerCase() + ".html";
					return temp.join(".");
				})();
		return throw 'no template for $name: create a file $path or add a @:view(path) metadata';
	}

	function get_data() : T
		return cast ractive.data;

	function set_data(v : T)
	{
		ractive.data = cast v;
		ractive.update();
		return v;
	}

	public function on<T>(eventName : String, handler : T -> Void) : RactiveCancelObject
		return ractive.on(eventName, handler);

	public function off<T>(?eventName : String, ?handler : T -> Void)
		ractive.off(eventName, handler);

	public function get<T>(field : String) : T
		return ractive.get(field);

	public function set<T>(keypath : String, value : T, ?complete : Void -> Void)
		ractive.set(keypath, value, complete);

	public function setMany(values : Dynamic, ?complete : Void -> Void)
		ractive.set(values, complete);

	public function animate(keypath : String, value : Dynamic, ?options : RactiveAnimateOptions)
		ractive.animate(keypath, value, options);

	public function animateMany(values : Dynamic, ?options : RactiveAnimateOptions)
		ractive.animate(values, options);

	public function fire<T>(eventName : String, payload : T)
		ractive.fire(eventName, payload);

	public function update(?keypath : String, ?complete : Void -> Void)
		ractive.update(keypath, complete);

	public function teardown(?complete : Void -> Void)
		ractive.teardown(complete);

	public function observe(keypath : String, complete : Dynamic -> Dynamic -> Void, ?options : { ?init : Bool, ?context : Dynamic }) : RactiveCancelObject
		return ractive.observe(keypath, complete, options);

	public function observeMany(map : Dynamic<Dynamic -> Dynamic -> Void>, ?options : { ?init : Bool, ?context : Dynamic }) : RactiveCancelObject
		return ractive.observe(map, options);

/*
	@:overload(function(options : RactiveOptionsElJQuery) : Void {})
	@:overload(function(options : RactiveOptionsElElement) : Void {})
	public function new(options : RactiveOptionsElString) : Void;
*/
}

typedef ViewOptions<T> = {
	?el : Element,
	?template : String,
	data : T,
	?noIntro : Bool,
	?partials : T,
	?transitions : Dynamic<RactiveTransitionFun>,
	?complete : Void -> Void,
	?modifyArrays : Bool,
	?twoway : Bool,
	?lazy : Bool,
	?append : Bool,
	?preserveWhitespace : Bool,
	?sanitize : Dynamic,
	?bindings : Array<Dynamic>
}