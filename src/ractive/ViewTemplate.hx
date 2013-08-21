package ractive;

#if macro
import com.roxstudio.haxe.hxquery.XmlVisitor;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import thx.markup.html.Html;

using StringTools;
using thx.core.Ints;

class ViewTemplate
{
	public static function build() : Array<Field>
	{
		var cls    = Context.getLocalClass().get(),
			fields = haxe.macro.Context.getBuildFields();

		function findAndBind()
		{
			var rel = getTemplatePath(cls);
			for(cp in Context.getClassPath())
			{
				var path = '$cp$rel';
				if(sys.FileSystem.exists(path))
				{
					Context.registerModuleDependency(cls.module, path);
					return filterContent(sys.io.File.getContent(path), cls);
				}

			}
			return null;
		}
		var template = findAndBind();
		if(null != template)
		{
			return fields.concat((macro class {
				override function getTemplate() return $v{template}
			}).fields);

		}
		return fields;
	}

	static function filterContent(content : String, cls : ClassType)
	{
		var filters = collectFilters(cls);
		if(filters.length == 0)
			return content;

		var xml = Html.toXml(content);
		for(filter in filters)
			xml = filter.filter(xml, filter.argument);

		return Html.getFormatter(Html5).format(xml);
	}

	static function collectFilters(cls : ClassType)
	{
		var filters = [];
		var selector = extractStringParamFromMetadata(cls, ":selector");
		if(null != selector)
			filters.push({ filter : filterSelector, argument : selector });

		selector = extractStringParamFromMetadata(cls, ":discard");
		if(null != selector)
			filters.push({ filter : filterDiscardElements, argument : selector });

		return filters;
	}

	static function filterSelector(xml : Xml, selector : String)
	{
		var visitor = new XmlVisitor(),
			result  = visitor.createQuery([xml]).select(selector);
		if(result.elements.length == 0)
			throw 'no elements were found for the selector "$selector"';

		if(result.elements.length > 1)
			throw 'more than one element (${result.elements.length}) were found for the selector "$selector"';
		return result.elements[0];
	}

	static function filterDiscardElements(xml : Xml, selector : String)
	{
		var visitor = new XmlVisitor();
		visitor.createQuery([xml]).select(selector).remove();
		return xml;
	}

	static function getTemplatePath(cls : ClassType)
	{
		var path = getTemplatePathFromMetadata(cls);
		if(null != path)
			return path;
		return getTemplatePathFromClass(cls);
	}

	static function extractStringParamFromMetadata(cls : ClassType, name : String)
	{
		var metas = cls.meta.get();
		for(meta in metas)
		{
			if(meta.name != name)
				continue;
			return extractString(meta.params);
		}
		return null;
	}

	static function getTemplatePathFromMetadata(cls : ClassType)
	{
		var path = extractStringParamFromMetadata(cls, ":view");
		if(null == path)
			return null;
		return resolvePath(path, cls);
	}

	static function resolvePath(path : String, cls : ClassType)
	{
		if(path.substr(0, 1) == ".") {
			// relative path
			path = path.substr(1);
			return cls.pack.copy().concat([path]).join("/");
		}
		return path;
	}

	static function extractString(exprs : Array<Expr>)
	{
		for(expr in exprs)
		{
			switch (expr.expr) {
				case EConst(CString(s)): return s;
				case _: continue;
			}
		}
		return null;
	}

	static function getTemplatePathFromClass(cls : ClassType)
	{
		return cls.pack.concat([cls.name.toLowerCase() + ".html"]).join("/");
	}
}
#end