package com.view.gameWindow.panel.panels.dungeon
{
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class DungeonPanelMouseEvent
	{
		private var _mc:McDungeonPanelChoice;
		private var _vector:Vector.<TextField> = new Vector.<TextField>();
		public function DungeonPanelMouseEvent()
		{
		}
		
		public function addEvent(mc:McDungeonPanelChoice,vector:Vector.<TextField>):void
		{
			_mc = mc;
			_vector = vector;
			_mc.addEventListener(MouseEvent.CLICK,clickHandle);
			_mc.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandle);
			_mc.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandle);
		}
		
		private function mouseOverHandle(evt:MouseEvent):void
		{
			if(evt.target is TextField)
			{
				for(var i:int = 0;i<_vector.length;i++)
				{
					if((evt.target as TextField)  == _vector[i])
					{
						TextFormatManager.instance.setTextFormat( evt.target as TextField,0xff0000,true,false);
					}
				}
			}
		}
		
		private function mouseOutHandle(evt:MouseEvent):void
		{
			if(evt.target is TextField)
			{
				for(var i:int = 0;i<_vector.length;i++)
				{
					if((evt.target as TextField)  == _vector[i])
					{
						TextFormatManager.instance.setTextFormat( evt.target as TextField,0x00ff00,false,false);
					}
				}
			}
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			switch(evt.target)
			{
				case _mc.closeBtn:
					PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON);
					break;
			}
			if(evt.target is TextField)
			{
				var dungeonPanel:DungeonPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_DUNGEON) as DungeonPanel;
				var i:int,l:int = dungeonPanel.vector.length;
				for(i=0;i<l;i++)
				{
					if((evt.target as TextField) == _vector[i])
					{
						dungeonPanel.id = dungeonPanel.vector[i];
						PanelMediator.instance.switchPanel(PanelConst.TYPE_DUNGEON_IN);
						PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON);
						break;
					}
				}
			}
		}
		
		public function destoryEvent():void
		{
			if(_mc)
			{
				_mc.removeEventListener(MouseEvent.CLICK,clickHandle);
				_mc.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandle);
				_mc.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandle);
			}
			_mc = null;
			_vector = null;
		}
	}
}