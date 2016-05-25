package com.view.gameWindow.panel.panels.guideSystem
{
	import com.core.toArray;
	
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 * 蛋疼的感觉  收集可以交互的元素
	 * @author wqhk
	 * 2014-12-17
	 */
	public class InterObjCollector
	{
		private static var _impl2:InterObjCollector;
		private static var _impl1:InterObjCollector;
		
		public static function get instance():InterObjCollector
		{
			if(!_impl1)
			{
				_impl1 = new InterObjCollector();
			}
			
			return _impl1;
		}
		
		/**
		 * for 自动点击
		 */
		public static function get autoCollector():InterObjCollector
		{
			if(!_impl2)
			{
				_impl2 = new InterObjCollector();
			}
			
			return _impl2;
		}
		
		private var store:Dictionary;
		private var groupStore:Dictionary;
		private var pos:Dictionary;
		
		public function InterObjCollector()
		{
			store = new Dictionary(true);
			groupStore = new Dictionary();
			pos = new Dictionary(true);
		}
		
		/**
		 * @param groupId 如果用了该字段一定要记得清理:removeByGroupId
		 */
		public function add(item:InteractiveObject,groupId:String = "",plusPos:Point = null):void
		{
			if(!item)
			{
				trace("InterObjCollector::add error");
				return;
			}
			
			if(store[item])
			{
				return;
			}
			
			store[item] = true;
			pos[item] = plusPos ? plusPos : new Point(0,0);
			
			if(groupId)
			{
				if(!groupStore[groupId])
				{
					groupStore[groupId] = [];
				}
				
				groupStore[groupId].push(item);
			}
		}
		
		public function removeByGroupId(id:String):void
		{
			var list:Array = groupStore[id];
			if(list)
			{
				for each(var item:InteractiveObject in list)
				{
					remove(item);
				}
				
				delete groupStore[id];
			}
		}
		
		public function remove(item:InteractiveObject):void
		{
			delete store[item];
			delete pos[item];
		}
		
		/**
		 * mb 不知道为什么 flash中的文本和as程序写的文本 不一样 会有位置偏移
		 */
		public function getPlusPos(item:InteractiveObject):Point
		{
			return pos[item];
		}
		
		public function get list():Vector.<InteractiveObject>
		{
			var re:Vector.<InteractiveObject> = new Vector.<InteractiveObject>();
			
			for(var key:* in store)
			{
				re.push(key);
			}
			
			return re;
		}
	}
}