package com.view.gameWindow.panel.panels.boss.mapcream
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.boss.MCMapCreamBossItem;
	
	import flash.display.MovieClip;

	public class TabMapCreamItem
	{
		private var _parent:TabMapCreamBoss;
		private var _skin:MCMapCreamBossItem
		//private var _scrollRect:TabMapCreamItemScrollRect_none;
 		private var _items:Vector.<TabMapCreamItemTxtItem> = new Vector.<TabMapCreamItemTxtItem>;
		public function TabMapCreamItem(parent:TabMapCreamBoss,skin:MCMapCreamBossItem)
		{
			_parent = parent;
		 	_skin = skin;
			init();
			 
		}
		 
		public function get items():Vector.<TabMapCreamItemTxtItem>
		{
			return _items;
		}

		private function init():void
		{
			var temp:TabMapCreamItemTxtItem;
			for(var i:int = 0;i< 4;i++)
			{
				trace(" i _skin['item'+i]",_skin['item'+i],"|",i);
				temp = new TabMapCreamItemTxtItem(_parent,_skin['item'+i]);
				_items.push(temp);
			}
		}
		/*public function get scrollRect():TabMapCreamItemScrollRect_none
		{
			return _scrollRect;
		}*/

		public function get skin():MCMapCreamBossItem
		{
			return _skin;
		}
	 
		/*public function init(rsrLoader:RsrLoader):void
		{
			//_scrollRect = new TabMapCreamItemScrollRect_none(_parent,_skin,rsrLoader);
			   
			addCallBack(rsrLoader);
		}*/
		
	 
		/*private function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(skin.mcScrollBar,function (mc:MovieClip):void
			{
				initScrollBar(mc);
			});
		}  */
		/*internal function initScrollBar(mc:MovieClip):void
		{
			//_scrollRect.initScrollBar(mc);
		}*/
		
		public function refresh(data:MapCreamItemData):void
		{
			_skin.mapNameTxt.text = data.getMapName();	
			var len:int = data.items.length;
			for(var i:int = 0;i < _items.length;i++)
			{
				if(len > i)
				{
					_items[i].refresh(data.items[i]);
					_items[i].skin.visible = true;
				}
				else
				{
					_items[i].skin.visible = false;
				}		
			}
			//_scrollRect.refresh(data.items);
		}
		
		internal function destroy():void
		{ 		
			/*if(_scrollRect)
			{
				_scrollRect.destroy();
				_scrollRect = null;
			}*/
			_items.length = 0;
			_skin = null;	 
		}
	}
}