package com.view.gameWindow.panel.panels.boss.classic
{
	import flash.display.MovieClip;
	import com.model.gameWindow.rsr.RsrLoader;

	public class TabClassBossPage
	{
		private var _view:TabClassicBossViewHandle;
		private var _skin:MovieClip;
		private var _items:Vector.<TabClassicItem>;	
		private var _rsrLoader:RsrLoader;
		public function TabClassBossPage(view:TabClassicBossViewHandle,rsrLoader:RsrLoader)
		{
			_view = view;
			_rsrLoader = rsrLoader;
		}
		
		public function init(skin:MovieClip):void
		{
			_skin = skin;
			_rsrLoader.loadItemRes(_skin.arrow0.mc);
			_rsrLoader.loadItemRes(_skin.arrow1.mc);
			_rsrLoader.loadItemRes(_skin.arrow2.mc);
			_rsrLoader.loadItemRes(_skin.arrow3.mc);
			
			var _itemMc:MovieClip,_item:TabClassicItem;
			_items = new Vector.<TabClassicItem>();
			for(var i:int =0;i < 5; i++)
			{
				_itemMc = _skin.getChildByName("boss"+i) as MovieClip;
				if(_itemMc)
				{
					_item = new TabClassicItem(_view,_itemMc,_rsrLoader);
					_items.push(_item);
				}
				
			}
			_view.skin.addChildAt(_skin,1);
		}
		
		public function refresh(data:Array):void
		{
			var len:int = data.length;
			for(var i:int = 0;i<_items.length; i++)
			{
				if(len>i)
				{
					_items[i].refresh(data[i]);
					_items[i].setVisible(true);
				}
				else
				{
					_items[i].setVisible(false);
				}			
			}
		}
		
		public function handleArrowMc(length:int):void
		{
			if(length == 1)
			{
				_skin.arrow0.visible = false;
				_skin.arrow1.visible = false;
				_skin.arrow2.visible = false;
				_skin.arrow3.visible = false;
			}
			else if(length == 2)
			{
				_skin.arrow0.visible = true;
				_skin.arrow1.visible = false;
				_skin.arrow2.visible = false;
				_skin.arrow3.visible = false;
			}
			else if(length == 3)
			{
				_skin.arrow0.visible = true;
				_skin.arrow1.visible = true;
				_skin.arrow2.visible = false;
				_skin.arrow3.visible = false;
			}
			else if(length == 4)
			{
				_skin.arrow0.visible = true;
				_skin.arrow1.visible = true;
				_skin.arrow2.visible = true;
				_skin.arrow3.visible = false;
			}
			else
			{
				_skin.arrow0.visible = true;
				_skin.arrow1.visible = true;
				_skin.arrow2.visible = true;
				_skin.arrow3.visible = true;
			}	
		}
		
		internal function destroy():void
		{ 
			if(_skin && _skin.parent)
			{
				_view.skin.removeChild(_skin);
			}
			for(var i:int = 0;i<_items.length; i++)
			{
				_items[i].destroy();
			}
			_items.length = 0; 
		}
	}
}