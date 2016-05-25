package com.view.gameWindow.panel.panels.dragonTreasure.treasureReward
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.dragonTreasure.event.DragonTreasureEvent;

	import flash.display.MovieClip;

	/**
	 * Created by Administrator on 2014/12/1.
	 */
	public class PanelTreasureReward extends PanelBase
	{
		private var _mouseHandler:RewardMouseClick;
		private var _viewHandler:RewardViewHandler;

		public function PanelTreasureReward()
		{
			super();
		}

		override protected function initSkin():void
		{
			_skin = new McTreasureReward();
			addChild(_skin);
			setTitleBar(_skin.dragBox);

		}

		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McTreasureReward=_skin as McTreasureReward;
			var btnLeftLoaded:Boolean=false;
			var btnRightLoaded:Boolean=false;

			rsrLoader.addCallBack(skin.btnLeft,function(mc:MovieClip):void{
				btnLeftLoaded=true;
				if(btnLeftLoaded&&btnRightLoaded){
					DragonTreasureEvent.dispatchEvent(new DragonTreasureEvent(DragonTreasureEvent.VIEW_ALL_GOODS));
				}
			});
			rsrLoader.addCallBack(skin.btnRight,function(mc:MovieClip):void{
				btnRightLoaded=true;
				if(btnLeftLoaded&&btnRightLoaded){
					DragonTreasureEvent.dispatchEvent(new DragonTreasureEvent(DragonTreasureEvent.VIEW_ALL_GOODS));
				}
			});
		}

		override protected function initData():void
		{
			_viewHandler = new RewardViewHandler(this);
			_mouseHandler = new RewardMouseClick(this);
		}


		override public function destroy():void
		{
			if (_viewHandler) {
				_viewHandler.destroy();
				_viewHandler = null;
			}
			if (_mouseHandler) {
				_mouseHandler.destroy();
				_mouseHandler = null;
			}
			super.destroy();
		}

		public function get mouseHandler():RewardMouseClick
		{
			return _mouseHandler;
		}

		public function get viewHandler():RewardViewHandler
		{
			return _viewHandler;
		}
	}
}
