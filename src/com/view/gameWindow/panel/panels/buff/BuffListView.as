package com.view.gameWindow.panel.panels.buff
{
	import flash.display.Sprite;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	
	/**
	 * @author wqhk
	 * 2014-9-15
	 */
	public class BuffListView extends Sprite
	{
		public static function broadcastFilter(item:BuffData):Boolean
		{
			return item.cfg.broadcast == 1;
		}
		
		private var _data:BuffListData;
		private var _list:Array;
		private var _size:Number;
		private var _gap:int = 3;
		private var _timeId:int = 0;
		private var _buffFilter:Function;
		
		/**
		 * @param buffFilter 过滤用
		 */
		public function BuffListView(size:Number = 40,buffFilter:Function = null)
		{
			super();
			_list = [];
			_size = size;
			_buffFilter = buffFilter;
		}
		
		public function get size():Number
		{
			return _size;
		}

		public function set data(value:BuffListData):void
		{
			_data = value;
			
			var index:int = 0;
			if(_data)
			{
				for each(var item:BuffData in value.list)
				{
					if(_buffFilter != null)
					{
						if(!_buffFilter(item))
						{
							continue;
						}
					}
					
					var view:BuffView;
					if(index>=_list.length)
					{
						view = new BuffView(_size);
						view.data = item;
						
						addChild(view);
						_list.push(view);
					}
					else
					{
						view = _list[index];
						view.data = item;
					}
					
					++index;
				}
				
				startTime();
			}
			else
			{
				stopTime();
			}
			
			//删除多余的
			var num:int = _list.length - index;
			while(num>0)
			{
				var del:BuffView = _list.pop();
				destroyBuff(del);
				--num;
			}
			
			updateTime();
			
			resetPos();
		}
		
		private function resetPos():void
		{
			var index:int = 0;
			for(var i:int = 0; i < _list.length; ++i)
			{
				var view:BuffView = _list[i] as BuffView;
				
//				TweenLite.to(view,0.5,{x:i*(_size+_gap)});
				
				if(view.visible)
				{
					var pos:int = index*(_size+_gap);
					view.x = pos;
					++index
				}
			}
		}
		
		public function destroy():void
		{
			stopTime();
			data = null;
		}
		
		private function destroyBuff(view:BuffView):void
		{
			if(view.parent)
			{
				view.parent.removeChild(view);
			}
			
			view.destroy();
		}
		
		public function startTime():void
		{
			if(!_timeId)
			{
				_timeId = setInterval(updateTime,500);
			}
		}
		
		public function stopTime():void
		{
			if(_timeId)
			{
				clearInterval(_timeId);
				_timeId = 0;
			}
		}
		
		public function updateTime():void
		{
			var index:int = 0;
			var isChange:Boolean = false;
			var deleteList:Array = [];
			for each(var item:BuffView in _list)
			{
				item.updateTime();
				
				if(item.isWaitingDestroy)
				{
					isChange = true;
					deleteList.push(index);
				}
					
				++index;
			}
			
			for(index=deleteList.length-1; index >= 0; --index)
			{
				var deleteIndex:int = deleteList[index];
				var deleteItem:BuffView = _list[deleteIndex];
				
				_data.deleteBuff(deleteItem.data.id); //这里其实挺不好 直接操作数据了
				destroyBuff(deleteItem);
				_list.splice(deleteIndex,1);
			}
			
			if(_list.length == 0)
			{
				stopTime();
			}
			
			if(isChange)
			{
				resetPos();
			}
		}
	}
}