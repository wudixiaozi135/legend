package com.view.gameWindow.mainUi.subuis.herohead
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.consts.ConstHeroMode;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.mainUi.subclass.McHeroHead;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.bag.menu.ConstBagCellMenu;
    import com.view.gameWindow.panel.panels.hero.HeroDataManager;
    import com.view.gameWindow.panel.panels.menus.others.MenuRoundBg;
    import com.view.gameWindow.tips.toolTip.TipVO;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.ServerTime;
    
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    import mx.utils.StringUtil;

    public class HeroHeadMouseEvent
	{
		private var _mc:McHeroHead;
		private var initMouseX :int;
		private var initMouseY :int;
		private var isMoved:Boolean = false;//移动时不打开英雄面板
		private var barNum:int;
		private var tipVO:TipVO;
		private var _heroHead:HeroHead;
        public var lastX:int;
        public var lastY:int;
		
		private var _menuRoundBg:MenuRoundBg;
		
		public function HeroHeadMouseEvent(heroHead:HeroHead)
		{
			_heroHead = heroHead;
			_mc = heroHead.mcHeroHead;
			_mc.txt.mouseEnabled = false;
			_mc.addEventListener(MouseEvent.CLICK,clickHandle);
			_mc.iconBtn.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandle);
			_mc.forBar.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownBarFunc);
			_mc.forBar.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveBarFunc);
			//
			isMoved = false;
			//
			tipVO = new TipVO();
			tipVO.tipType = ToolTipConst.TEXT_TIP;
			ToolTipManager.getInstance().hashTipInfo(_mc.forBar,tipVO);
			ToolTipManager.getInstance().attach(_mc.forBar,false);
			_mc.forBar.alpha=0.6;
			//
			var list:Vector.<int> = new <int>[ConstBagCellMenu.TYPE_INITIATIVE,ConstBagCellMenu.TYPE_FOLLOW,ConstBagCellMenu.TYPE_STAND];
			var tips:Vector.<String> = new <String>[StringConst.HERO_HEAD_TIP_0001,StringConst.HERO_HEAD_TIP_0002,StringConst.HERO_HEAD_TIP_0003];
			_menuRoundBg = new MenuRoundBg(_mc,list,pickUpMenuHandler,tips);
			_menuRoundBg.x = _mc.btnHero.x + (_mc.btnHero.width - _menuRoundBg.width)*.5;
			_menuRoundBg.y = _mc.btnHero.y - _menuRoundBg.height;
		}
		
		private function pickUpMenuHandler(index:int):void
		{
			if(index>=0)
			{
				var manager:HeroDataManager = HeroDataManager.instance;
				if(index == 0 && manager.mode != ConstHeroMode.HM_ACTIVE)
				{
//					_mc.txts.text = StringConst.HERO_HEAD_0001;
					manager.mode = ConstHeroMode.HM_ACTIVE;
					sendMessage(ConstHeroMode.HM_ACTIVE);
				}
				else if(index == 1 && manager.mode != ConstHeroMode.HM_HOLD)
				{
//					_mc.txts.text = StringConst.HERO_HEAD_0002;
					manager.mode = ConstHeroMode.HM_HOLD;
					sendMessage(ConstHeroMode.HM_HOLD);
				}
				else if(index == 2 && manager.mode != ConstHeroMode.HM_IDLE)
				{
//					_mc.txts.text = StringConst.HERO_HEAD_0003;
					manager.mode = ConstHeroMode.HM_IDLE;
					sendMessage(ConstHeroMode.HM_IDLE);
				}
			}
		}
		
		private function mouseDownBarFunc(evt:MouseEvent):void
		{
			if(evt.localX>77||evt.localX<0)return;
			_mc.forBar.addEventListener(MouseEvent.MOUSE_UP,onBarUPFunc);
			_mc.forBar.addEventListener(MouseEvent.MOUSE_OUT,mouseOutBarFunc);	
			_mc.forBar.btnForBar.startDrag(false,new Rectangle(-_mc.forBar.btnForBar.width*0.5,0,77,0));
			_mc.forBar.alpha=1;
			_mc.forBar.btnForBar.x=evt.localX-(_mc.forBar.btnForBar.width*0.5);
		}	
		
		private function onBarUPFunc(e:MouseEvent):void
		{
			_mc.forBar.btnForBar.stopDrag();
			_mc.forBar.alpha=0.6;
			_mc.forBar.removeEventListener(MouseEvent.MOUSE_UP,onBarUPFunc);
			_mc.forBar.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutBarFunc);
			HeroDataManager.instance.saleHP=getBarNum();
			sendHeroHPAuto(HeroDataManager.instance.saleHP);
		}
		
		private function mouseMoveBarFunc(e:MouseEvent):void
		{
			if(e.localX>77||e.localX<0)return;
			var x:Number=e.localX;
			var barN:int=x/76*100;
			if(e.buttonDown)barN=getBarNum();
			tipVO.tipData =HtmlUtils.createHtmlStr(0xffffff,barN+"%");
		}
		
		private function getBarNum():int
		{
			var barx:Number=_mc.forBar.btnForBar.x+_mc.forBar.btnForBar.width*0.5;
			var barw:Number=76;
			return barx/barw*100;
		}
		
		private function mouseOutBarFunc(e:MouseEvent):void
		{
			_mc.forBar.alpha=0.6;
			_mc.forBar.btnForBar.stopDrag();
			_mc.forBar.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutBarFunc);
			_mc.forBar.removeEventListener(MouseEvent.MOUSE_UP,onBarUPFunc);
			HeroDataManager.instance.saleHP=getBarNum();
			sendHeroHPAuto(HeroDataManager.instance.saleHP);
		}
		
		private function sendHeroHPAuto(hp:int):void
		{
            if (hp < 100)
            {
                var bt:ByteArray = new ByteArray();
                bt.endian = Endian.LITTLE_ENDIAN;
                bt.writeShort(hp);
                ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_HERO_AUTO_HP, bt);
            }
		}
		
		private function mouseDownHandle(evt:MouseEvent):void
		{
			initMouseX = evt.stageX - _mc.parent.x;
			initMouseY = evt.stageY - _mc.parent.y;
			_mc.parent.stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandle);
			_mc.parent.stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandle);
		}
		
		private function mouseMoveHandle(evt:MouseEvent):void
		{
			var newX:Number = evt.stageX - initMouseX;
			var newY:Number = evt.stageY - initMouseY;

			if(Math.abs(newX - _mc.parent.x) > 1 || Math.abs(newY - _mc.parent.y) > 1)
			{
				isMoved = true;
			}
            if (_heroHead)
            {
                _heroHead.resetPosition(newX, newY);
            }
		}

		private function mouseUpHandle(evt:MouseEvent):void
		{
			initMouseX = 0;
			initMouseY = 0;
			_mc.parent.stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandle);
			_mc.parent.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandle);
            if (isMoved)
            {
                sendHeroIconPosition(_mc.parent.x, _mc.parent.y, _mc.parent.stage.stageWidth, _mc.parent.stage.stageHeight);
                lastX = _mc.parent.x;
                lastY = _mc.parent.y;
            }
		}
		
		private function clickHandle(event:MouseEvent):void
		{			
			if(event.target == _mc.fightBtn)
			{
				var manager:HeroDataManager = HeroDataManager.instance;
				if(_heroHead.sectorMaskEffect && _heroHead.sectorMaskEffect.isPlaying)
				{
					var lastHideTime:int = manager.lastHideTime;
					var lastDeadTime:int = manager.lastDeadTime;
					var serveTime:int = ServerTime.time;
					_mc.fightBtn.selected = false;
					Alert.warning(StringUtil.substitute(StringConst.HERO_HEAD_0004, _heroHead._isDead?60 -(serveTime - lastDeadTime):30 -(serveTime - lastHideTime)));
					return;
				}
				if(_mc.fightBtn.selected == true)
				{
					if(manager.mode == ConstHeroMode.HM_HIDE_HOLD)
					{
						sendMessage(ConstHeroMode.HM_HOLD);
					}
					else
					{
						sendMessage(ConstHeroMode.HM_ACTIVE);
					}
				}
				else
				{	
					sendMessage(manager.modeOpposite);
				}
			}
			if(event.target == _mc.iconBtn)
			{
				if(!isMoved)
				{
					HeroDataManager.instance.isExchange = false;
					PanelMediator.instance.switchPanel(PanelConst.TYPE_HERO);
				}
				isMoved = false;
			}
//			if(event.target == _mc.btnHero)
//			{
//				_menuRoundBg.setListVisible(event);
//			}
			if(event.target==_mc.btnHero.btn1)
			{
				pickUpMenuHandler(0);
			}else if(event.target==_mc.btnHero.btn2)
			{
				pickUpMenuHandler(1);
			}
			else if(event.target==_mc.btnHero.btn3)
			{
				pickUpMenuHandler(2);
			}
			_mc.dragMc.width = _mc.heroBottom.width;
		}
		
		private function sendMessage(mode:int):void
		{
			HeroDataManager.instance.requestChangeHeroMode(mode);
		}

        private function sendHeroIconPosition(posX:int, posY:int, scaleW:int, scaleH:int):void
        {
            var byte:ByteArray = new ByteArray();
            byte.endian = Endian.LITTLE_ENDIAN;
            byte.writeInt(posX);
            byte.writeInt(posY);
            byte.writeInt(scaleW);
            byte.writeInt(scaleH);
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_HERO_ICON_INFO, byte);
            byte = null;
        }
    }
}