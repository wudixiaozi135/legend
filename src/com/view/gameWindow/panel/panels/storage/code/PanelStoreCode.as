package com.view.gameWindow.panel.panels.storage.code
{
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.storage.MCStorageCode;
	import com.view.gameWindow.panel.panels.storage.StorageDataMannager;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class PanelStoreCode extends PanelBase
	{
		public var viewhandle:PanelStoreCodeViewHandle;
	
		public function PanelStoreCode()
		{
			super();
		}
 
		override protected function initSkin():void
		{
			 var skin:MCStorageCode = new MCStorageCode;
			 setTitleBar(skin.mcTitleBar);
			 _skin = skin;
			 addChild(_skin);
			 
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			viewhandle = new PanelStoreCodeViewHandle(this);
			var a:int = 0,b:int = 5;
			for(;a < b; a++)
			{
				rsrLoader.addCallBack(_skin["btnTab"+String(a)],getFun(a));

			}
		}
 		private function getFun(index:int):Function
		{
			var func:Function = function(mc:MovieClip):void
			{
				var selectTab:int = StorageDataMannager.instance.codeSelectTab;
				var textField:TextField = mc.txt as TextField;
				textField.text = StringConst["STORAGE_PANEL_TAB_000"+String(1+index)];
				if(selectTab == index)
				{
					mc.selected = true;
					mc.mouseEnabled = false;
					viewhandle.lastBtn = mc;
					textField.textColor = 0xffe1aa;
				}
				else
				{
					textField.textColor = 0xd4a460;
				}
			}
			return func;
		}
		override public function update(proc:int=0):void
		{
			 
			 
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