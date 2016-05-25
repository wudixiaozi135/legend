package  com.view.gameWindow.common
{
	import flash.utils.Dictionary;
	
	/**
	 *  也许有点用吧……
	 * 
	 * @author wqhk
	 * 2014-9-5
	 * 
	 *
	 */
	public class PropertyOrganizer
	{
		private var _host:Object;
		private var _store:Dictionary;
		public function PropertyOrganizer(host:Object)
		{
			_host = host;
			_store = new Dictionary(true);
		}
		
		public function destroy():void
		{
			_host = null;
			_store = null;
		}
		
		public function register(name:String,propertys:String,setter:Function = null,getter:Function = null):void
		{
			if(!_store)
			{
				return;
			}
			
			var unit:Unit = new Unit();
			unit.name = name;
			unit.propertys = propertys ? propertys.split(".") : [];
			unit.getter = getter;
			unit.setter = setter;
			_store[name] = unit;
		}
		
		public function update(name:String):void
		{
			if(!_store)
			{
				return;
			}
			
			var unit:Unit = _store[name];
			
			if(!unit)
			{
				trace("PropertyOrganizer.update(name) "+_host+":"+name+"error");
			}
			
			setProperty(_host,unit.propertys,unit.setter);
			getProperty(_host,unit.propertys,unit.getter);
			
		}
		
		private function getProperty(host:Object,propertys:Array,getter:Function):void
		{
			if(getter == null)
			{
				return;
			}
			
			var obj:Object = host;
			for(var i:int = 0; i < propertys.length; ++i)
			{
				obj = obj[propertys[i]];
			}
			
			getter(obj);
		}
		
		private function setProperty(host:Object,propertys:Array,setter:Function):void
		{
			if(setter == null)
			{
				return;
			}
			
			var obj:Object = host;
			for(var i:int = 0; i < propertys.length - 1; ++i)
			{
				obj = obj[propertys[i]];
			}
			
			obj[propertys[propertys.length-1]] = setter();
		}
	}
}

class Unit
{
	public var name:String;
	public var propertys:Array;
	public var getter:Function;
	public var setter:Function;
}