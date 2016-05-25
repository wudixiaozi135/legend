package com.view.gameWindow.panel.panels.dungeonTower
{
    import com.greensock.TweenLite;
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
    import com.view.newMir.NewMirMediator;
    
    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    /**
	 * 塔防副本信息面板类
	 * @author Administrator
	 */	
	public class PanelDgnTowerInfo extends PanelBase
	{
		private var _view:PanelDgnTowerInfoView;
		
		private var _isSelect:Boolean;
		private var _tweenLite:TweenLite;
		private var _duration:Number = .4;
		private var _xTo:int;
		
		public function PanelDgnTowerInfo()
		{
			super();
            canEscExit = false;
			DgnTowerDataManger.instance.attach(this);
		}
		
		override protected function initSkin():void
		{
			var skin:McDgnTowerInfo = new McDgnTowerInfo();
			_skin = skin;
			addChild(_skin);
			_xTo = skin.width;
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McDgnTowerInfo = _skin as McDgnTowerInfo;
			rsrLoader.addCallBack(skin.btn,function (mc:MovieClip):void
			{
				_view.assign.assignTxtInBtn();
				InterObjCollector.instance.add(mc);
				InterObjCollector.autoCollector.add(mc);
			});
			rsrLoader.addCallBack(skin.btnFold,function (mc:MovieClip):void
			{
				_skin.parent.addChild(mc);
			});
		}
		
		override protected function initData():void
		{
			_view = new PanelDgnTowerInfoView(this);
			addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var skin:McDgnTowerInfo = _skin as McDgnTowerInfo;
			switch(event.target)
			{
				default:
					break;
				case skin.btn:
                    dealBtn();
					break;
				case skin.btnFold:
					dealBtnFold();
					break;
				case skin.txtBuy:
					dealTxtBuy();
					break;
			}
		}
		
		private function dealTxtBuy():void
		{
			/*RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0007);*/
			/*var skillOpen:OpenPanelAction = new OpenPanelAction(PanelConst.TYPE_MALL,ShopShelfType.TYPE_HOT_SELL);
			skillOpen.act();*/
			PanelMediator.instance.switchPanel(PanelConst.TYPE_DUNGEON_TOWER_BUY);
		}
		
		private function dealBtn():void
		{
			var manager:DgnTowerDataManger = DgnTowerDataManger.instance;
			if(!manager.isStart)
			{
				manager.cmSendDungeonEvnet();
			}
			else
			{
				if(manager.isInMainDgnTower)
				{
					Alert.warning(StringConst.DGN_TOWER_0049);
					return;
				}
				manager.cmLeaveDungeon();
			}
		}
		
		private function dealBtnFold():void
		{
			if(!_tweenLite)
			{
				_tweenLite = new TweenLite(skin,_duration,{x:_xTo});
			}
			if(!_isSelect)
			{
				_tweenLite.play();
			}
			else
			{
				_tweenLite.reverse();
			}
			_isSelect = !_isSelect;
		}
		
		override public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_TOWER_DUNGEON_STEP_PROGRESS)
			{
				_view.refresh();
			}
		}
		
		override public function setPostion():void
		{
			/*super.setPostion();*/
			x = NewMirMediator.getInstance().width - _skin.width;
			y = (NewMirMediator.getInstance().height - _skin.height)/2;
		}
		
		override public function destroy():void
		{
			if(_tweenLite)
			{
				_tweenLite.kill();
				_tweenLite = null;
			}
			InterObjCollector.instance.remove(_skin.btn);
			InterObjCollector.autoCollector.remove(_skin.btn);
			DgnTowerDataManger.instance.detach(this);
			removeEventListener(MouseEvent.CLICK,onClick);
			if(_view)
			{
				_view.destroy();
				_view = null;
			}
			super.destroy();
		}
	}
}