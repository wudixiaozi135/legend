package com.view.gameWindow.panel.panels.storage.code
{
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.storage.MCStorageCodeFive;
	import com.view.gameWindow.panel.panels.storage.StorageDataMannager;
	import com.view.gameWindow.util.tabsSwitch.TabBase;

	public class StorageCodeFive extends TabBase
	{
		public function StorageCodeFive()
		{
			
			super();
		}
		
		
		override protected function initSkin():void
		{
			var skin:MCStorageCodeFive = new MCStorageCodeFive;
			_skin = skin;
			addChild(_skin);
			initTxt();
		}
		
		private function initTxt():void
		{
			var skin:MCStorageCodeFive = _skin as MCStorageCodeFive;
			skin.decTxt0.text = StringConst.STORAGE_039;
			skin.decTxt1.text = StringConst.STORAGE_038;
			skin.decTxt2.text = StringConst.STORAGE_037;
			skin.decTxt3.text = StringConst.STORAGE_036;
			skin.decTxt4.text = StringConst.STORAGE_035;
			skin.decTxt5.text = StringConst.STORAGE_034;
			skin.decTxt6.text = StringConst.STORAGE_033;
			skin.decTxt7.text = StringConst.STORAGE_032;
			skin.decTxt8.text = StringConst.STORAGE_031;
			skin.codeStateTxt0.text = StringConst.STORAGE_009;
			
			var codeState:int = StorageDataMannager.instance.codeState;
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
 
		override public function destroy():void
		{
			
			super.destroy();
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			// TODO Auto Generated method stub
			super.addCallBack(rsrLoader);
		}
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			super.detach();
		}
		
	}
}