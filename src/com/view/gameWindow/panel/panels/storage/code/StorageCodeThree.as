package com.view.gameWindow.panel.panels.storage.code
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.storage.MCStorageCodeThree;
	import com.view.gameWindow.panel.panels.storage.StorageDataMannager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;

	public class StorageCodeThree extends TabBase
	{
		public function StorageCodeThree()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:MCStorageCodeThree = new MCStorageCodeThree;
			_skin = skin;
			addChild(_skin);
			initTxt();
		}
		
		private function initTxt():void
		{
			var skin:MCStorageCodeThree = _skin as MCStorageCodeThree; 
			var codeState:int = StorageDataMannager.instance.codeState;
			
			skin.newCodeTxt0.restrict = skin.newCodeTxt1.restrict = '0-9a-zA-Z';
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
			skin.codeStateTxt0.text =StringConst.STORAGE_009;
			skin.decTxt.text = StringConst.STORAGE_023;
			
			skin.oldCodeTxt0.text = StringConst.STORAGE_024;
			skin.oldCodeTxt.type = TextFieldType.INPUT;
			skin.newCodeTxt0.type = TextFieldType.INPUT;	
			skin.codeTxt0.text = StringConst.STORAGE_025;
			skin.codeTxt1.text = StringConst.STORAGE_026;
			skin.saveTxt.text =StringConst.STORAGE_027;
			skin.newCodeTxt.text = StringConst.STORAGE_028;
			skin.saveTxt.mouseEnabled = false;
			
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:MCStorageCodeThree = _skin as MCStorageCodeThree; 
			rsrLoader.addCallBack(skin.saveBtn,function (mc:MovieClip):void
			{
				mc.addEventListener(MouseEvent.CLICK,onSaveFun);
			}
			);
			StorageDataMannager.instance.getPassWordParam();
		}
		
		private function onSaveFun(e:MouseEvent):void
		{
			var skin:MCStorageCodeThree = _skin as MCStorageCodeThree; 
			
			if(skin.newCodeTxt0.text != skin.newCodeTxt1.text || skin.newCodeTxt0.text =="")
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.STORAGE_022);		
				return;
			}
			var oldstr:String = skin.oldCodeTxt.text;
			var newstr:String = skin.newCodeTxt0.text;
			StorageDataMannager.instance.savePassWord(oldstr,newstr);
		}	
		
		
		override public function refresh():void
		{
			
			
		}
		
		override public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.CM_RESTORE_LOCK || proc== GameServiceConstants.CM_DELETE_STORE_PASSWORD || proc ==GameServiceConstants.CM_SET_STORE_PASSWORD)
			{
				var codeState:int = StorageDataMannager.instance.codeState;
				var skin:MCStorageCodeThree = _skin as MCStorageCodeThree; 
				if(codeState == StorageDataMannager.codeStateThree)
				{
					skin.codeStateTxt.text =StringConst.STORAGE_010;
					
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
			_skin.saveBtn.removeEventListener(MouseEvent.CLICK,onSaveFun);
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