package com.view.gameWindow.mainUi.subuis.monsterhp.dropList
{
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.cell.ThingsData;
	
	import flash.display.Sprite;
	
	public class DropListView extends Sprite
	{	
		private var _data:String;
		private var _size:Number = 24;
		private var _gap:int = 3;
		private var _timeId:int = 0;
		public var _listView:Array;
		
		
		public function DropListView()
		{
			super();
			
			_listView=[];
		}
		
		
		private function resetPos():void
		{
			var index:int = 0;
			for(var i:int = 0; i < _listView.length; ++i)
			{
				var view:DropView = _listView[i] as DropView;			
				if(view.visible)
				{
					var pos:int = index*(_size+_gap);
					view.x = pos;
					++index
				}
			}
		}
		
		public function set data(value:String):void
		{
			if(_data=="")return;
			if(_data==value)return;
			_data = value;
			var items:Vector.<ThingsData>=UtilItemParse.getThingsDatas(value);
			clearListView();
			
			for (var i:int = 0;i<items.length;i++)
			{
				if(i>=5)break;
				var view:DropView;
				view = new DropView();
				view.data = items[i];	
				addChild(view);
				_listView.push(view);
			}
			resetPos();
		}
		
		private function clearListView():void
		{
			while(_listView.length>0)
			{
				var drop:DropView = _listView.shift() as DropView;
				drop.parent&&drop.parent.removeChild(drop);
				drop.destroy();
				drop=null;
			}
		}
	}
}