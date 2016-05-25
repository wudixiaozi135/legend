package  com.view.gameWindow.util
{
	import flash.utils.Dictionary;

	/**
	 * 哈希图 
	 * @author xiaoyu
	 * 
	 */	
	public class HashMap  
	{
		private var _length:int;
		private var _content:Dictionary;
		private var _weakKeys:Boolean;
		
		/**
		 * 构造函数 
		 * @param weakKeys 是否是弱引用
		 * 
		 */		
		public function HashMap(weakKeys:Boolean = false)
		{
			_weakKeys = weakKeys;
			_length = 0;
			_content = new Dictionary(weakKeys);
		}
		
		public function get weakKeys():Boolean
		{
			return _weakKeys;
		}
		
		/**
		 * 当前HashMap的长度 
		 * @return 
		 * 
		 */		
		public function get length():int
		{
			return _length;
		}
		
		/**
		 * 当前HashMap是否为空
		 * @return 
		 * 
		 */		
		public function isEmpty():Boolean
		{
			return _length == 0;
		}
		
		/**
		 * 获取Key列表 
		 * @return 
		 * 
		 */		
		public function getKeys():Array
		{
			var temp:Array = new Array(_length);
			var index:int = 0;
			var i:*;
			for(i in _content)
			{
				temp[index] = i;
				index++;
			}
			return temp;
		}
		
		/**
		 * 获取Value列表
		 * @return 
		 * 
		 */		
		public function getValues():Array
		{
			var temp:Array = new Array(_length);
			var index:int = 0;
			var i:*;
			for each(i in _content)
			{
				temp[index] = i;
				index++;
			}
			return temp;
		}
		
		/**
		 * 对Key列表中的每一项执行函数
		 * @param func
		 * 
		 */		
		public function eachKey(func:Function):void
		{
			var i:*;
			for(i in _content)
			{
				func(i);
			}
		}
		
		/**
		 * 对Value列表中的每一项执行函数 
		 * @param func
		 * 
		 */		
		public function eachValue(func:Function):void
		{
			var i:*;
			for each(i in _content)
			{
				func(i);
			}
		}
		
		/**
		 * 对整个HashMap的每一项执行函数
		 * @param func 第一个参数是key,第二个参数是Value
		 * 
		 */		
		public function forEach(func:Function):void
		{
			var i:*;
			for(i in _content)
			{
				func(i,_content[i]);
			}
		}
		
		/**
		 * 当前HashMap是否有value
		 * @param value
		 * @return 
		 * 
		 */		
		public function containsValue(value:*):Boolean
		{
			var i:*;
			for each(i in _content)
			{
				if (i === value)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 对HashMap中的每一项执行测试函数，直到获得返回 true 的项。
		 * @param func 第一个参数是key,第二个参数是Value
		 * @return 如果所有项对于指定的函数都返回 true，则为布尔值 true，否则为 false。 
		 * 
		 */		
		public function some(func:Function):Boolean
		{
			var i:*;
			for(i in _content)
			{
				if(func(i,_content[i]))
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 对HashMap中的每一项执行测试函数，直到获得对指定的函数返回 false 的项
		 * @param func
		 * @return 如果所有项对指定的函数都返回 true，则为布尔值 true；否则为 false。 
		 * 
		 */		
		public function every(func:Function):Boolean
		{
			var i:*;
			for(i in _content)
			{
				if(!func(i,_content[i]))
				{
					return false;
				}
			}
			return true;
		}
		
		/**
		 * 对HashMap中的每一项执行测试函数，并构造一个新数组（值，不包含Key），其中的所有项都对指定的函数返回 true。 如果某项返回 false，则新数组中将不包含此项。 
		 * @param func 第一个参数是key,第二个参数是Value
		 * @return 
		 * 
		 */		
		public function filter(func:Function):Array
		{
			var arr:Array = [];
			var i:*;
			var v:*;
			for(i in _content)
			{
				v = _content[i];
				if(func(i,v))
				{
					arr.push(v);
				}
			}
			return arr;
		}
		
		/**
		 * 当前HashMap是否有Key
		 * @param key
		 * @return 
		 * 
		 */		
		public function containsKey(key:*):Boolean
		{
			if (key in _content)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 从指定的Key中获取 Value
		 * @param key
		 * @return 
		 * 
		 */		
		public function getValue(key:*):*
		{
			var value:* = _content[key];
			return value === undefined ? null : value;
		}
		
		
		public function setValue(key:*,data:*):Boolean
		{
			 if(containsKey(key))
			 {
				 _content[key] = data;
				 return true;
			 }
			return false;
		}
		
		/**
		 * 从指定的Value中获取Key
		 * @param value
		 * @return 
		 * 
		 */		
		public function getKey(value:*):*
		{
			var i:*;
			for(i in _content)
			{
				if(_content[i] == value)
				{
					return i;
				}
			}
			return null;
		}
		
		/**
		 * 添加key value，返回的是旧的key对应的value，如果没有则返回null
		 * @param key
		 * @param value
		 * @return
		 *
		 */
		public function add(key:*, value:*):*
		{
			if (key == null)
			{
				throw new ArgumentError("cannot put a value with undefined or null key!");
				return null;
			}
			if(value === undefined)
			{
				return null;
			}
			else
			{
				if (!(key in _content))
				{
					_length++;
				}
				var oldValue:* = getValue(key);
				_content[key] = value;
				return oldValue;
			}
		}

		/**
		 * 移除key value，返回的是旧的key对应的value，如果没有则返回null
		 * @param key
		 * @return
		 *
		 */
		public function remove(key:*):*
		{
			if (!(key in _content))
			{
				return null;
			}
			var temp:* = _content[key];
			delete _content[key];
			_length--;
			return temp;
		}
		
		/**
		 * 清空当前HashMap 
		 * 
		 */		
		public function clear():void
		{
			_length = 0;
			_content = new Dictionary(_weakKeys);
		}
		
		/**
		 * 克隆当前 HashMap
		 * @return 
		 * 
		 */		
		public function clone():HashMap
		{
			var temp:HashMap = new HashMap(_weakKeys);
			var i:*;
			for(i in _content)
			{
				temp.add(i, _content[i]);
			}
			return temp;
		}

		public function toString():String
		{
			var ks:Array = getKeys();
			var vs:Array = getValues();
			var len:int = ks.length;
			var temp:String = "HashMap Content:\n";
			var i:int;
			for(i = 0; i < len; i++)
			{
				temp += ks[i] + " -> " + vs[i] + "\n";
			}
			return temp;
		}
	}

}

