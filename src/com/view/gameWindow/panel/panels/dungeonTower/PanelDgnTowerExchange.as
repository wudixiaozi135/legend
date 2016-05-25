package com.view.gameWindow.panel.panels.dungeonTower
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * 塔防副本兑换面板类
	 * @author Administrator
	 */	
	public class PanelDgnTowerExchange extends PanelBase
	{
		internal var view:PanelDgnTowerExchangeView;
		
		public function PanelDgnTowerExchange()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McDgnTowerExchange = new McDgnTowerExchange();
			_skin = skin;
			addChild(_skin);
			setTitleBar(skin.mcDrag);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McDgnTowerExchange = _skin as McDgnTowerExchange;
			rsrLoader.addCallBack(skin.btnSelect,function (mc:MovieClip):void
			{
				view.initSelect();
			});
		}
		
		
		override protected function initData():void
		{
			view = new PanelDgnTowerExchangeView(this);
			_skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var skin:McDgnTowerExchange = _skin as McDgnTowerExchange;
			switch(event.target)
			{
				default:
					break;
				case skin.btnClose:
					dealBtnClose();
					break;
				case skin.btnSelect:
					dealBtnSelect();
					break;
				case skin.btnOne:
					dealBtn();
					break;
			}
		}
		
		private function dealBtnClose():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON_TOWER_EXCHANGE);
		}
		
		private function dealBtnSelect():void
		{
			var manager:DgnTowerDataManger = DgnTowerDataManger.instance;
			var exchange:int = manager.exchange;
			var boolean:Boolean = manager.isAutos[exchange] as Boolean;
			manager.isAutos[exchange] = !boolean;
		}
		
		private function dealBtn():void
		{
			DgnTowerDataManger.instance.cmDungeonShopBuy();
		}
		
		override public function destroy():void
		{
			view.destroy();
			super.destroy();
		}
	}
}