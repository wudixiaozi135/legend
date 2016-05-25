package com.view.gameWindow.panel.panels.boss.dungeonindividualboss
{
    import com.greensock.TweenLite;
    import com.model.configData.cfgdata.NpcShopCfgData;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.boss.MCIndividualBossDgn;
    import com.view.gameWindow.panel.panels.buyitemconfirm.PanelBuyItemConfirmData;
    import com.view.gameWindow.panel.panels.dungeon.DgnGoalsDataManager;
    import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
    import com.view.newMir.NewMirMediator;
    
    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class PanelIndividualBoss extends PanelBase
	{
		public var viewHandle:PanelIndividualBossViewHandle;
		public var mouseHandle:MouseHandle;
		
		public function PanelIndividualBoss()
		{
			super();
            canEscExit = false;
		}
		
		override protected function initSkin():void
		{
			var skin:MCIndividualBossDgn = new MCIndividualBossDgn;
			_skin = skin;
			addChild(_skin);		
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(_skin.btn,function(mc:MovieClip):void
			{
				InterObjCollector.instance.add(mc);
				InterObjCollector.autoCollector.add(mc);
			});
			rsrLoader.addCallBack(_skin.btnFold,function():void
			{
				addChild(_skin.btnFold);
				resetPosInParent();
			});
		}
		
		override protected function initData():void
		{
			viewHandle = new PanelIndividualBossViewHandle(this);
			viewHandle.initialize();
			mouseHandle = new MouseHandle(this);
			mouseHandle.initialize();
		}
		
		override public function setPostion():void
		{
			x = NewMirMediator.getInstance().width - _skin.width;
			y = (NewMirMediator.getInstance().height - _skin.height)/2;
		}
		
		override public function destroy():void
		{
			InterObjCollector.instance.remove(_skin.btn);
			InterObjCollector.autoCollector.remove(_skin.btn);
			
			if(viewHandle)
			{
				viewHandle.destroy(); 
				viewHandle = null;
			}
			if(mouseHandle)
			{
				mouseHandle.destroy();
				mouseHandle = null;
			}
			super.destroy();
		}
	}
}
import com.greensock.TweenLite;
import com.model.configData.cfgdata.NpcShopCfgData;
import com.model.consts.StringConst;
import com.view.gameWindow.flyEffect.FlyEffectMediator;
import com.view.gameWindow.mainUi.subuis.bottombar.ExpRecorder;
import com.view.gameWindow.panel.PanelConst;
import com.view.gameWindow.panel.PanelMediator;
import com.view.gameWindow.panel.panels.boss.BossDataManager;
import com.view.gameWindow.panel.panels.boss.MCIndividualBossDgn;
import com.view.gameWindow.panel.panels.boss.dungeonindividualboss.PanelIndividualBoss;
import com.view.gameWindow.panel.panels.buyitemconfirm.PanelBuyItemConfirmData;
import com.view.gameWindow.panel.panels.dungeon.DgnGoalsDataManager;

import flash.events.MouseEvent;
import flash.geom.Point;
import flash.utils.clearInterval;
import flash.utils.setInterval;

class MouseHandle
{
	private var _skin:MCIndividualBossDgn;
	private var _panel:PanelIndividualBoss;
	
	private var _foldTween:TweenLite;
	
	public function MouseHandle(panel:PanelIndividualBoss)
	{
		_skin = panel.skin as MCIndividualBossDgn;
		_panel = panel;
	}
	
	public function initialize():void
	{
		_panel.addEventListener(MouseEvent.CLICK,onClick);
	}
	
	private function onClick(e:MouseEvent):void
	{
		if(!_panel.viewHandle)
		{
			return;
		}
		switch(e.target)
		{
			case _skin.btnFold:
				dealFold(_skin.btnFold.selected);
				break;
			case _skin.btn:
				dealBtn();
				break;
			case _skin.buyTxt2:
				dealBuyItem(_panel.viewHandle.cellDatas[1]);
				break;
			case _skin.buyTxt1:
				dealBuyItem(_panel.viewHandle.cellDatas[0]);
				break;
			default:
				break;
		}
	}
	
	private function dealFold(isFold:Boolean):void
	{
		if(_foldTween)
		{
			_foldTween.kill();
		}
		_foldTween = TweenLite.to(_skin,0.8,{x:isFold?_skin.width:0});
	}
	
	private function dealBtn():void
	{
		var id:uint;
		if(_skin.loginTxt.text == StringConst.BOSS_INFO_0005)
		{
			ExpRecorder.storeData();
			var startPoint:Point = _skin.localToGlobal(new Point(_skin.mcReward.x + ((_skin.mcReward.width) >> 1), _skin.mcReward.y + 20));
			FlyEffectMediator.instance.deExpStoneEffect(startPoint);
			id = setInterval(leaveFun,1200);
		}
		else
		{
			//BossDataManager.instance.dungeonId = 0;
			
			DgnGoalsDataManager.instance.requestCancel();
		}
		function leaveFun():void
		{
			clearInterval(id);
			//BossDataManager.instance.dungeonId = 0;
			DgnGoalsDataManager.instance.requestCancel();
		}
		
	}
	
	private function dealBuyItem(cfgDt:NpcShopCfgData):void
	{
		PanelBuyItemConfirmData.cfgDt = cfgDt;
		PanelMediator.instance.switchPanel(PanelConst.TYPE_BUY_ITEM_CONFIRM);
	}
	
	public function destroy():void
	{
		if(_foldTween)
		{
			_foldTween.kill();
			_foldTween = null;
		}
		_panel.removeEventListener(MouseEvent.CLICK,onClick);
	}
}