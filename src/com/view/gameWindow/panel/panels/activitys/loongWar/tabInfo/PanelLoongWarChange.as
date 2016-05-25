package com.view.gameWindow.panel.panels.activitys.loongWar.tabInfo
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	
	import flash.events.MouseEvent;
	
	/**
	 * 龙城争霸修改城名面板
	 * @author Administrator
	 */	
	public class PanelLoongWarChange extends PanelBase
	{
		public function PanelLoongWarChange()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McLoongWarChange = new McLoongWarChange();
			_skin = skin;
			addChild(_skin);
		}
		
		override protected function initData():void
		{
			ActivityDataManager.instance.loongWarDataManager.attach(this);
			//
			var skin:McLoongWarChange = _skin as McLoongWarChange;
			setTitleBar(skin.mcDrag);
			//
			skin.txtTitle.text = StringConst.LOONG_WAR_0057;
			skin.txtBtnTrue.text = StringConst.LOONG_WAR_0057;
			skin.txtBtnTrue.mouseEnabled = false;
			skin.txtInfo.text = StringConst.LOONG_WAR_0058;
			//
			skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var skin:McLoongWarChange = _skin as McLoongWarChange;
			switch(event.target)
			{
				case skin.btnClose:
					dealBtnClose();
					break;
				case skin.btnTrue:
					dealBtnTrue();
					break;
				default:
					break;
			}
		}
		
		private function dealBtnClose():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_LOONG_WAR_CHANGE);
		}
		
		private function dealBtnTrue():void
		{
			var skin:McLoongWarChange = _skin as McLoongWarChange;
			ActivityDataManager.instance.loongWarDataManager.cmChangeCityName(skin.txtInput.text);
		}
		
		override public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.CM_CHANGE_CITY_NAME)
			{
				dealBtnClose();
			}
		}
		
		override public function destroy():void
		{
			ActivityDataManager.instance.loongWarDataManager.detach(this);
			_skin.removeEventListener(MouseEvent.CLICK,onClick);
			super.destroy();
		}
	}
}