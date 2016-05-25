package com.view.gameWindow.panel.panels.storage.code
{
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.storage.MCStorageCodeOne;
	import com.view.gameWindow.panel.panels.storage.StorageDataMannager;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class StorageCodeOne extends TabBase
	{
		public function StorageCodeOne()
		{
			super();
		}
		override protected function initSkin():void
		{ 
			var skin:MCStorageCodeOne = new MCStorageCodeOne;
			_skin = skin;
			addChild(_skin);
			initTxt();
		}
		
		private function initTxt():void
		{
			var skin:MCStorageCodeOne = _skin as MCStorageCodeOne; 
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
			skin.decTxt.htmlText =StringConst.STORAGE_013;
			skin.shurumisuoTxt.text = StringConst.STORAGE_014;
			skin.quedingjiesuoTxt.text = StringConst.STORAGE_015;
			skin.quedingjiesuoTxt.mouseEnabled = false;
			skin.misuoTxt.restrict = "0-9a-zA-Z";
			
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:MCStorageCodeOne = _skin as MCStorageCodeOne; 
			rsrLoader.addCallBack(skin.jieSuoBtn,function (mc:MovieClip):void
			{
				mc.addEventListener(MouseEvent.CLICK,jiechuFun)	
			}
			);
			
			StorageDataMannager.instance.getPassWordParam();
		}
		
		private function jiechuFun(e:MouseEvent):void
		{
			var skin:MCStorageCodeOne = _skin as MCStorageCodeOne; 
			var str:String = skin.misuoTxt.text;
			if(str=="")
				return;
			StorageDataMannager.instance.JieChuMiSuo(str);
		}
		
		override public function refresh():void
		{
			 
		 	
		}
		
		override public function update(proc:int=0):void
		{
			
			/*if(proc == GameServiceConstants.CM_UNLOCK_STORE)
			{
				var codeState:int = StorageDataMannager.instance.codeState;
				var skin:MCStorageCodeOne = _skin as MCStorageCodeOne; 
				if(codeState == StorageDataMannager.codeStateThree)
				{
					skin.codeStateTxt.text = "临时解锁";
					
				}
				else if(codeState == StorageDataMannager.codeStateTwo)
				{
					skin.codeStateTxt.text = "已锁定";					
				}
				else
				{
					skin.codeStateTxt.text = "未锁定";
				}
			} */
 
		}
		
		
		override public function destroy():void
		{
			_skin.jieSuoBtn.removeEventListener(MouseEvent.CLICK,jiechuFun);
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