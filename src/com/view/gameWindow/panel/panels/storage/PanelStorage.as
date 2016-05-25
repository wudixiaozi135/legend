package com.view.gameWindow.panel.panels.storage
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;

	public class PanelStorage extends PanelBase
	{
		public var viewHandle:PanelStorageViewHandle;
		public var mouseHandle:PanelStorageMouseHandle;
		public function PanelStorage()
		{
			StorageDataMannager.instance.attach(this);
		 
		}
 
		override protected function initSkin():void
		{
			var skin:McStaorge = new McStaorge;
			setTitleBar(skin.mcTitleBar);
			skin.txtName.text = StringConst.STORAGE_007;
			_skin = skin;
			addChild(skin);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			mouseHandle = new PanelStorageMouseHandle(this);
			viewHandle = new PanelStorageViewHandle(this);
			refreshLock();
			viewHandle.init(rsrLoader);
			mouseHandle.init(rsrLoader);
			//StorageDataMannager.instance.queryStoreitems(0);
			
		}
 		
		
		override public function update(proc:int=0):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_STORE_ITEMS:
				{
					viewHandle.refreshMoney();
					viewHandle.refresh();
					break;
				} 
				case GameServiceConstants.SM_STORE_GOLD_COIN:
				{
					viewHandle.refreshMoney();
					break;
				}
				case GameServiceConstants.CM_DELETE_STORE_PASSWORD:
					refreshLock();
					break;
					
			}
		}
		
		public function refreshLock():void
		{
			var codeState:int = StorageDataMannager.instance.codeState;
					
			if(codeState == StorageDataMannager.codeStateZero)
			{
				mouseHandle.showLockBtn(false);
			}
			else
			{
				mouseHandle.showLockBtn(true);
			}
		}
		override public function setPostion():void
		{
			PanelMediator.instance.openPanel(PanelConst.TYPE_BAG,true);
			mouseHandle.showPage(0);
			isMount(true);
		}
		
		override public function destroy():void
		{
			StorageDataMannager.instance.detach(this); 
			StorageDataMannager.instance.storageId = 0;
			mouseHandle.destroy();
			viewHandle.destroy();
			viewHandle = null;
			mouseHandle = null;
			super.destroy();
		}
	}
}