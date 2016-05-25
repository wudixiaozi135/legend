package com.view.gameWindow.flyEffect.subs
{
	import com.model.consts.EffectConst;
	import com.view.gameWindow.flyEffect.FlyEffectBase;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
	import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelBase;
	import com.view.gameWindow.panel.panels.specialRing.SpecialRingDataManager;
	import com.view.gameWindow.panel.panels.specialRingPrompt.McSpecialRingPrompt;
	import com.view.gameWindow.util.UIEffectLoader;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * 特戒飞行特效处理类
	 * @author Administrator
	 */	
	public class FlyEffectSpecialRing extends FlyEffectBase
	{
		private var _uiEffectLoader:UIEffectLoader;
		
		public function FlyEffectSpecialRing(layer:Sprite)
		{
			super(layer);
			initialize();
		}
		
		private function initialize():void
		{
			var panel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_SPECIAL_RING_PROMPT);
			if(!panel)
			{
				return;
			}
			var bottomBar:BottomBar = MainUiMediator.getInstance().bottomBar as BottomBar;
			if(!bottomBar)
			{
				return;
			}
			//
			var skin:McSpecialRingPrompt = panel.skin as McSpecialRingPrompt;
			var mc:MovieClip = skin.mcRingLayer;
			var point:Point = new Point(mc.x,mc.y);
			fromLct = mc.localToGlobal(point);
			//
			/*var openedPanel1:PanelSpecialRing = mediator.openedPanel(PanelConst.TYPE_SPECIAL_RING) as PanelSpecialRing;
			if(!openedPanel1)
			{
				onComplete();
				return;
			}
			var skin1:McSpecialRingUpgrade = openedPanel1.tab.skin as McSpecialRingUpgrade;
			var ringGet:int = SpecialRingDataManager.instance.ringGet;
			var mc1:MovieClip = skin1["mcRing"+ringGet] as MovieClip;*/
			var skin1:McMainUIBottom = bottomBar.skin as McMainUIBottom;
			var mc1:MovieClip = skin1.btnSpecialRing;
			point.x = mc1.x + mc1.width*.5 - mc.width*.5 + 4;
			point.y = mc1.y + mc1.height*.5 - mc.height*.5 - 8;
			toLct = mc1.parent.localToGlobal(point);
			//
			getTarget(mc);
			duration = 2;
			
			SpecialRingDataManager.instance.isFlying = true;
		}
		
		private function getTarget(mc:MovieClip):void
		{
			target = new Sprite();
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var ringGet:int = manager.ringGet;
			var cX:int = mc.width/2;
			var cY:int = mc.height/2;
			var url:String = EffectConst.RES_SPECIAL_RING.replace("&x",ringGet);
			_uiEffectLoader = new UIEffectLoader(target as Sprite,cX,cY,1,1,url);
		}
		
		override protected function onComplete():void
		{
			PanelMediator.instance.openPanel(PanelConst.TYPE_SPECIAL_RING);
			SpecialRingDataManager.instance.isFlying = false;
			if(_uiEffectLoader)
			{
				_uiEffectLoader.destroy();
				_uiEffectLoader = null;
			}
			super.onComplete();
		}
	}
}