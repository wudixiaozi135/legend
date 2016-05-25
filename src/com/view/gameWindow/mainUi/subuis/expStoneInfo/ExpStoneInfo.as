package com.view.gameWindow.mainUi.subuis.expStoneInfo
{
	import com.event.GameDispatcher;
	import com.event.GameEventConst;
	import com.model.configData.ConfigDataManager;
	import com.model.consts.EffectConst;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.common.ModelEvents;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.mainUi.MainUi;
	import com.view.gameWindow.mainUi.subclass.McExpStone;
	import com.view.gameWindow.mainUi.subuis.IconGroup;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.expStone.ExpStoneData;
	import com.view.gameWindow.panel.panels.expStone.ExpStoneDataManager;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockObserver;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.newMir.NewMirMediator;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;

	import mx.utils.StringUtil;

	public class ExpStoneInfo extends MainUi  implements IObserver
	{
		private var  _total:int;
		private var _mcExpStone:McExpStone;
		private var _mouseEvent:ExpStoneMouseHandle;
		private var _unlockObserver:UnlockObserver;
		private const ITEMID:int = 3001;//经验玉ID
		private var effect:UIEffectLoader;
		private var _effectSprite:Sprite;
		
		public function ExpStoneInfo()
		{
			super();
			IconGroup.instance.addIcon(this);
			ExpStoneDataManager.instance.attach(this);
			this.mouseEnabled=false;
		}
				
		override public function initView():void
		{
			_skin = new McExpStone();
			addChild(_skin);
			_mcExpStone = _skin as McExpStone;
			_skin.visible = false;
			initData();
			_effectSprite=new Sprite();
			_effectSprite.mouseEnabled=_effectSprite.mouseChildren=false;
			addChild(_effectSprite);
			super.initView();
		}
		
		private function initData():void
		{
			var tipVo:TipVO = new TipVO();
			tipVo.tipType = ToolTipConst.TEXT_TIP;
			tipVo.tipData = expStoneTip;
			ToolTipManager.getInstance().hashTipInfo(_mcExpStone,tipVo);
			ToolTipManager.getInstance().attach(_mcExpStone);
			_mouseEvent = new ExpStoneMouseHandle(_mcExpStone);
			_total = ExpStoneData.getMaxExp(ConfigDataManager.instance.itemCfgData(ITEMID));
			checkLockState(UnlockFuncId.EXP_STONE);
			initLockStateObserver();
		}
		
		private function expStoneTip():String
		{
			var exp:int = ExpStoneDataManager.instance.exp;
			var str:String = StringUtil.substitute(StringConst.EXP_STONE_001,exp + "/" + _total);
			return str;
		}
		
		private function initLockStateObserver():void
		{
			if(!_unlockObserver)
			{
				_unlockObserver = new UnlockObserver();
				_unlockObserver.setCallback(checkLockState);
				GuideSystem.instance.unlockStateNotice.attach(_unlockObserver);
			}
		}
		
		private function destroyLockStateObserver():void
		{
			if(_unlockObserver)
			{
				_unlockObserver.destroy();
				GuideSystem.instance.unlockStateNotice.detach(_unlockObserver);
				_unlockObserver = null;
			}
		}
		
		private function checkLockState(id:int):void
		{
			if(id == UnlockFuncId.EXP_STONE)
			{
				if(GuideSystem.instance.isUnlock(id))
				{
					ExpStoneDataManager.instance.openExpPanel();
				}
			}
		}
		
		private function closeVipExperience(type:int):void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_COVER);
			PanelMediator.instance.closePanel(PanelConst.TYPE_EXPERIENCE);
			
			FlyEffectMediator.instance.doFlyExp(new Point(NewMirMediator.getInstance().width/2,NewMirMediator.getInstance().height/2),new Point(x,y+20),flyComplete);
		}
		
		private function flyComplete():void
		{
			this.mouseChildren = true;
			_mouseEvent.clickHandle(null);
		}
		
		public function update(proc:int=0):void
		{
			if(proc == ModelEvents.SHOW_VIP_EXPERIENCE)
			{
				PanelMediator.instance.openPanel(PanelConst.TYPE_COVER);
				PanelMediator.instance.openPanel(PanelConst.TYPE_EXPERIENCE,true,1,closeVipExperience);
				this.mouseChildren = false;
			}
			else
			{
				if(ExpStoneDataManager.instance.type == 1 || ExpStoneDataManager.instance.type == 2 || ExpStoneDataManager.instance.type == 3)
				{
					showExpUi();
					expStoneTip();
				}
				else
				{
					_skin.visible = false;
					if(ExpStoneDataManager.instance.type >= 4)
					{
						/*if(ExpStoneDataManager.instance.type == 3)
						{
							PanelMediator.instance.openPanel(PanelConst.TYPE_ALERT_EXP_STONE2);
						}
						else */
						if(ExpStoneDataManager.instance.type == 4)
						{
							PanelMediator.instance.closePanel(PanelConst.TYPE_ALERT_EXP_STONE2);
						}
						destroy();
					}
				}
				GameDispatcher.dispatchEvent(GameEventConst.ICON_CHANGE);
			}
		}
		
		private function destroy():void
		{
			ToolTipManager.getInstance().detach(_mcExpStone);
			ExpStoneDataManager.instance.detach(this);
			if(_mouseEvent)
			{
				_mouseEvent.destroy();
				_mouseEvent = null;
			}
			removeEffect();
			if(_effectSprite)
			{
				_effectSprite.parent&&_effectSprite.parent.removeChild(_effectSprite);
				_effectSprite=null;
			}
			destroyLockStateObserver();
			_mcExpStone = null;
		}
		
		private function addEffect(mc:DisplayObjectContainer):void
		{
			if(!effect)
			{
				effect = new UIEffectLoader(mc, mc.x+24, mc.y+30, 1, 1, EffectConst.RES_ACT_ENTER_EFFECT,function():void
				{
					mc.addChildAt(effect.effect,0);
				});
			}
		}
		
		private function removeEffect():void
		{
			if(effect)
			{
				effect.destroyEffect();
				effect = null;
			}
		}
		
		private function showExpUi():void
		{
			_skin.visible = true;
			_mcExpStone.mcMask.scaleY = ExpStoneDataManager.instance.exp/_total;
			if(_mcExpStone.mcMask.scaleY == 1)
			{
				_mcExpStone.bottom.visible = true;
				_mcExpStone.bottom2.visible = false;	
				addEffect(_effectSprite);
			}
			else
			{
				_mcExpStone.bottom.visible = false;
				removeEffect();
				_mcExpStone.bottom2.visible = true;	
			}
		}

		override public function get visible():Boolean
		{
			if (_skin)
			{
				return _skin.visible;
			}
			return false;
		}
	}
}