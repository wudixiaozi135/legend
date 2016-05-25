package com.view.gameWindow.panel.panels.storage.code
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.storage.MCStorageCodeFour;
	import com.view.gameWindow.panel.panels.storage.StorageDataMannager;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class StorageCodeFour extends TabBase
	{
		public function StorageCodeFour()
		{
			super();
		}
		
		
		override protected function initSkin():void
		{
			var skin:MCStorageCodeFour = new MCStorageCodeFour;
			_skin = skin;
			addChild(_skin);
			
		}
		
		private function initTxt():void
		{
			var codeState:int = StorageDataMannager.instance.codeState;
			var skin:MCStorageCodeFour = _skin as MCStorageCodeFour;
			skin.codeStateTxt0.text = StringConst.STORAGE_009;
			skin.decTxt.text = StringConst.STORAGE_029;
			skin.codeTxt0.text = StringConst.STORAGE_014;
			skin.cancelTxt.text = StringConst.STORAGE_030;
			skin.codeTxt.restrict = "0-9a-zA-Z";
			skin.cancelTxt.mouseEnabled = false;	
			if(codeState == StorageDataMannager.codeStateThree)
			{
				skin.codeStateTxt.text = StringConst.STORAGE_010;
				
			}
			else if(codeState == StorageDataMannager.codeStateTwo)
			{
				skin.codeStateTxt.text = StringConst.STORAGE_011;
				
			}
			else
			{
				skin.codeStateTxt.text = StringConst.STORAGE_012;
			}
        			
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:MCStorageCodeFour = _skin as MCStorageCodeFour;
			rsrLoader.addCallBack(skin.cancelBtn,function(mc:MovieClip):void
			{
				mc.addEventListener(MouseEvent.CLICK,onCancleFun);	
			}
			);
			StorageDataMannager.instance.getPassWordParam();
			initTxt();
		}
		
		private function onCancleFun(e:MouseEvent):void
		{
			var skin:MCStorageCodeFour = _skin as MCStorageCodeFour;
			var str:String = skin.codeTxt.text;
			if(str == "")
			  return;
			StorageDataMannager.instance.cancleProtect(str);
		}
		override public function refresh():void
		{
			
			
		}
		
		override public function update(proc:int=0):void
		{
			if(proc== GameServiceConstants.CM_DELETE_STORE_PASSWORD)
			{
				var codeState:int = StorageDataMannager.instance.codeState;
				var skin:MCStorageCodeFour = _skin as MCStorageCodeFour; 
				if(codeState == StorageDataMannager.codeStateThree)
				{
					skin.codeStateTxt.text = StringConst.STORAGE_010;
					
				}
				else if(codeState == StorageDataMannager.codeStateTwo)
				{
					skin.codeStateTxt.text = StringConst.STORAGE_011;
					
				}
				else
				{
					skin.codeStateTxt.text = StringConst.STORAGE_012;
				}
			}  
			
		}
		
		override public function destroy():void
		{
			_skin.cancelBtn.removeEventListener(MouseEvent.CLICK,onCancleFun);
			super.destroy();
		}
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			StorageDataMannager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			StorageDataMannager.instance.detach(this);
			super.detach();
		}
		
	}
}