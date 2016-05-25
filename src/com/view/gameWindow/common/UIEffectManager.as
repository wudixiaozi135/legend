package com.view.gameWindow.common
{
	import com.view.gameWindow.scene.effect.item.EffectBase;
	
	/**
	 * @author wqhk
	 * 2015-1-19
	 */
	public class UIEffectManager
	{
		private static var _instance:UIEffectManager;
		public static function get instance():UIEffectManager
		{
			if(!_instance)
			{
				_instance = new UIEffectManager();
			}
			
			return _instance;
		}
		
		public function UIEffectManager()
		{
			_store = [];
		}
		
		private var _store:Array;
		
		public function add(item:EffectBase):void
		{
			_store.push(item);
		}
		
		public function remove(item:EffectBase):void
		{
			var index:int = _store.indexOf(item);
			
			_store.splice(index,1);
		}
		
		public function update(timeDiff:int):void
		{
			for each(var item:EffectBase in _store)
			{
				item.updateFrame(timeDiff);
			}
		}
	}
}