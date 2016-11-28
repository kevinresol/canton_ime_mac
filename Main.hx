package;

import sys.io.File;
import sys.io.Process;
import sys.FileSystem;

class Main
{
	static function main() 
	{
		var file = File.getContent('canton_original.txt');
		var lines = file.split('\n').slice(1); // skip first line
		
		var map = new Map();
		
		function push(key, value)
		{
			if(!map.exists(key)) map[key] = [];
			map[key].push(value);
		}
		
		for(line in lines) if(line.length != 0)
		{
			var c = line.split(' ').filter(function(c) return c != '');
			var key = c[0];
			var value = c[1];
			push(key, value);
		}
		
		var buf = new StringBuf();
		
		var keys = [for(key in map.keys()) key];
		keys.sort(function(s1, s2) return Reflect.compare(s1, s2));
		
		for(key in keys)
		{
			buf.add(key);
			buf.add(' ');
			buf.add(map[key].join(','));
			buf.add('\n');
		}
		
		var template = new haxe.Template(File.getContent('template.inputplugin'));
		File.saveContent('temp.txt', template.execute({chars: buf.toString()}));
		var proc = new Process('iconv', ['-f', 'UTF-8', '-t', 'UTF-16', 'temp.txt']);
		File.saveBytes('廣東.inputplugin', proc.stdout.readAll());
		FileSystem.deleteFile('temp.txt');
	}
}