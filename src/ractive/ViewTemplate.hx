package ractive;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

class ViewTemplate
{
	public static function build() : Array<Field>
	{
		var cls = Context.getLocalClass().get(),
			fields = haxe.macro.Context.getBuildFields();

		function findAndBind()
		{
			var rel = getTemplatePathFromClass(cls);
			for(cp in Context.getClassPath())
			{
				var path = '$cp$rel';
				if(sys.FileSystem.exists(path))
				{
					Context.registerModuleDependency(cls.module, path);
					return sys.io.File.getContent(path);
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

	static function getTemplatePathFromClass(cls : ClassType)
	{
		return cls.pack.concat([cls.name.toLowerCase() + ".html"]).join("/");
	}
}