package com.view.gameWindow.panel.panels.storage.code
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.storage.MCStorageCodeTwo;
	import com.view.gameWindow.panel.panels.storage.StorageDataMannager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class StorageCodeTwo extends TabBase
	{
		public function StorageCodeTwo()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:MCStorageCodeTwo = new MCStorageCodeTwo;
			_skin = skin;
			addChild(_skin);	
			
		}
		
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:MCStorageCodeTwo = _skin as MCStorageCodeTwo; 
			var codeState:int = StorageDataMannager.instance.codeState;
			rsrLoader.addCallBack(skin.shezhiOrhuifuBtn,function(mc:MovieClip):void
			{
				mc.addEventListener(MouseEvent.CLICK,onCLick);
			}
			);
			rsrLoader.addCallBack(skin.newCodebg0,function(mc:MovieClip):void
			{
				if(codeState == StorageDataMannager.codeStateThree)
				{		 
					mc.visible = false; 
				}
				else if(codeState == StorageDataMannager.codeStateTwo)
				{ 
					mc.visible  = true;
				}
				else
				{ 
					mc.visible  = true; 
				}
			}
			);
			rsrLoader.addCallBack(skin.newCodebg1,function(mc:MovieClip):void
			{
				 
				if(codeState == StorageDataMannager.codeStateThree)
				{		 
					mc.visible = false; 
				}
				else if(codeState == StorageDataMannager.codeStateTwo)
				{ 
					mc.visible  = true;
				}
				else
				{ 
					mc.visible  = true; 
				}
			}
			);
			initTxt();
		}
		public function initTxt():void
		{
			var skin:MCStorageCodeTwo = _skin as MCStorageCodeTwo; 
			skin.codeStateTxt0.text =  StringConst.STORAGE_009;
			var codeState:int = StorageDataMannager.instance.codeState;
			skin.newCodeTxt0.restrict = skin.newCodeTxt1.restrict = '0-9a-zA-Z';
			skin.codeTxt0.text = StringConst.STORAGE_016;
			skin.codeTxt1.text = StringConst.STORAGE_017;
			if(codeState == StorageDataMannager.codeStateThree)
			{
				skin.codeStateTxt.text = StringConst.STORAGE_010;
				skin.codeTxt0.visible = skin.codeTxt1.visible = skin.newCodeTxt0.visible = skin.newCodeTxt1.visible = false;
				skin.shezhiOrhuifuTxt.text = StringConst.STORAGE_018;
			}
			else if(codeState == StorageDataMannager.codeStateTwo)
			{
				skin.codeStateTxt.text = StringConst.STORAGE_019;
				skin.codeTxt0.visible = skin.codeTxt1.visible = skin.newCodeTxt0.visible = skin.newCodeTxt1.visible = true;
				skin.shezhiOrhuifuTxt.text = StringConst.STORAGE_020;
				
			}
			else
			{
				skin.codeStateTxt.text = StringConst.STORAGE_012;
				skin.codeTxt0.visible = skin.codeTxt1.visible = skin.newCodeTxt0.visible = skin.newCodeTxt1.visible = true;
				skin.shezhiOrhuifuTxt.text = StringConst.STORAGE_020;
			}
			skin.shezhiOrhuifuTxt.mouseEnabled = false;
			
			skin.decTxt.htmlText =StringConst.STORAGE_021;
			 
		}
		
		private function onCLick(e:MouseEvent):void
		{
			var codeState:int = StorageDataMannager.instance.codeState;
			var skin:MCStorageCodeTwo = _skin as MCStorageCodeTwo; 
			if(codeState == StorageDataMannager.codeStateThree)
			{
				StorageDataMannager.instance.recoverProtect();
			}
			else if(codeState == StorageDataMannager.codeStateTwo || codeState == StorageDataMannager.codeStateZero || codeState==StorageDataMannager.codeStateOne)
			{
				if(skin.newCodeTxt0.text == skin.newCodeTxt1.text && skin.newCodeTxt1.text!="")
				{
					StorageDataMannager.instance.setStorePassWord(skin.newCodeTxt1.text);
				}
				else
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.STORAGE_022);	
				}
			}
		}
		override public function refresh():void
		{
			
			
		}
		
		override public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.CM_RESTORE_LOCK||proc ==GameServiceConstants.CM_SET_STORE_PASSWORD)
			{
				var codeState:int = StorageDataMannager.instance.codeState;
				var skin:MCStorageCodeTwo = _skin as MCStorageCodeTwo; 
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
			_skin.shezhiOrhuifuBtn.removeEventListener(MouseEvent.CLICK,onCLick);
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