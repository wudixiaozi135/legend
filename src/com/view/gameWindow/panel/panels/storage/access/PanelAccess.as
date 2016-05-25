package com.view.gameWindow.panel.panels.storage.access
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.storage.McAccess;
	
	import flash.display.MovieClip;

	public class PanelAccess extends PanelBase
	{
		
		public var viewhandle:PanelAccessViewHandle;
		public function PanelAccess()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McAccess = new McAccess;
			_skin = skin;
			setTitleBar(_skin.mcTitleBar);
			addChild(_skin);
				 
		}
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McAccess =  _skin as McAccess; 
			rsrLoader.addCallBack(skin.depositBtn,function (mc:MovieClip):void
			{
				mc.selected = true;
			}
			);
			rsrLoader.addCallBack(skin.btn500,function (mc:MovieClip):void
			{
				mc.selected = true;
			}
			);
			
			viewhandle = new PanelAccessViewHandle(this);
		}
 		
		 
		override public function setPostion():void
		{
			isMount(true);
		}
		override public function destroy():void
		{
			viewhandle.destroy();
			viewhandle = null;
			super.destroy();
		}
		
	}
}