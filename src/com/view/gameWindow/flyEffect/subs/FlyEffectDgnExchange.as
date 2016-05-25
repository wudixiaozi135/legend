package com.view.gameWindow.flyEffect.subs
{
	import com.model.consts.EffectConst;
	import com.view.gameWindow.flyEffect.FlyEffectBase;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.dungeonTower.McDgnTowerBtns;
	import com.view.gameWindow.panel.panels.dungeonTower.McDgnTowerInfo;
	import com.view.gameWindow.panel.panels.dungeonTower.McDgnTowerInfoExpUnget;
	import com.view.gameWindow.panel.panels.dungeonTower.PanelDgnTowerBtns;
	import com.view.gameWindow.panel.panels.dungeonTower.PanelDgnTowerInfo;
	import com.view.gameWindow.util.UIEffectLoader;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class FlyEffectDgnExchange extends FlyEffectBase
	{
		private var _ballExp:UIEffectLoader;
		private var _ballExpContainer:Sprite;
		
		public function FlyEffectDgnExchange(layer:Sprite,index:int)
		{
			super(layer);
			initialize(index);
		}
		
		private function initialize(index:int):void
		{
			var panel:PanelDgnTowerInfo = PanelMediator.instance.openedPanel(PanelConst.TYPE_DUNGEON_TOWER_INFO) as PanelDgnTowerInfo;
			if(!panel)
			{
				return;
			}
			var panel1:PanelDgnTowerBtns = PanelMediator.instance.openedPanel(PanelConst.TYPE_DUNGEON_TOWER_BTNS) as PanelDgnTowerBtns;
			if(!panel1)
			{
				return;
			}
			//
			var skin:McDgnTowerInfo = panel.skin as McDgnTowerInfo;
			var mc:McDgnTowerInfoExpUnget = skin.mcExpUnget;
			var point:Point = new Point(mc.x+mc.mcMask.width*.5,mc.y+mc.mcMask.height*.5);
			fromLct = skin.localToGlobal(point);
			//
			var skin1:McDgnTowerBtns = panel1.skin as McDgnTowerBtns;
			var mc1:MovieClip = skin1["btn"+index];
			point = new Point(mc1.x+mc1.width*.5,mc1.y+mc1.height*.5);
			toLct = skin1.localToGlobal(point);
			//
			layer.addChild(_ballExpContainer = new Sprite());
			_ballExp = new UIEffectLoader(_ballExpContainer, 0, 0, 1, 1, EffectConst.RES_DGN_TOWER_EXCHANGE, fly);
			target = _ballExpContainer;
		}
		
		override protected function onComplete():void
		{
			if (_ballExpContainer && _ballExpContainer.parent)
			{
				_ballExpContainer.parent.removeChild(_ballExpContainer);
				_ballExpContainer = null;
			}
			if (_ballExp)
			{
				_ballExp.destroy();
				_ballExp = null;
			}
			super.onComplete();
		}
	}
}