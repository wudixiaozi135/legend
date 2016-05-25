package com.view.gameWindow.panel.panels.hero.tab2
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.position.PositionDataManager;
	
	import flash.events.MouseEvent;

	public class HeroUpgradeMouseHandler
	{
		private var panel:HeroUpgradeTab;
		private var skin:MCHeroUpgradeTab;
		public function HeroUpgradeMouseHandler(panel:HeroUpgradeTab)
		{
			this.panel = panel;
			skin = panel.skin as MCHeroUpgradeTab;
			skin.addEventListener(MouseEvent.CLICK,onClickFunc);
			skin.addEventListener(MouseEvent.MOUSE_OVER,onOverFunc);
			skin.addEventListener(MouseEvent.MOUSE_OUT,onOutFunc);
			skin.addEventListener(MouseEvent.MOUSE_DOWN,onDownFunc);
			skin.addEventListener(MouseEvent.MOUSE_UP,onUPFunc);
		}
		
		protected function onUPFunc(event:MouseEvent):void
		{
			if(event.target is HeroUpgradeNode)
			{
				var node:HeroUpgradeNode=event.target as HeroUpgradeNode;
				node.scaleX=node.scaleY=1.1;
			}
		}
		
		protected function onDownFunc(event:MouseEvent):void
		{
			if(event.target is HeroUpgradeNode)
			{
				var node:HeroUpgradeNode=event.target as HeroUpgradeNode;
				node.scaleX=node.scaleY=1.05;
			}
		}
		
		protected function onOutFunc(event:MouseEvent):void
		{
			if(event.target==skin.txt1)
			{
				skin.txt1.textColor=0x00ff00;
			}
			if(event.target==skin.txt3)
			{
				skin.txt3.textColor=0x00ff00;
			}
			if(event.target is HeroUpgradeNode)
			{
				var node:HeroUpgradeNode=event.target as HeroUpgradeNode;
				node.scaleX=node.scaleY=1;
			}
		}
		
		protected function onOverFunc(event:MouseEvent):void
		{
			if(event.target==skin.txt1)
			{
				skin.txt1.textColor=0xff0000;
			}
			if(event.target==skin.txt3)
			{
				skin.txt3.textColor=0xff0000;
			}
			
			if(event.target is HeroUpgradeNode)
			{
				var node:HeroUpgradeNode=event.target as HeroUpgradeNode;
				node.scaleX=node.scaleY=1.1;
			}
		}		
		
		
		protected function onClickFunc(event:MouseEvent):void
		{
			if(event.target is HeroUpgradeNode)
			{
				var node:HeroUpgradeNode=event.target as HeroUpgradeNode;
				if(node.nodeCfg.meridians_level>HeroDataManager.instance.heroUpgradeData.meridians+1)
				{
					Alert.warning(StringConst.HERO_UPGRADE_1013);
				}else if(node.nodeCfg.meridians_level==HeroDataManager.instance.heroUpgradeData.meridians+1)
				{
					if(node.nodeCfg.cost_hero_exp>HeroDataManager.instance.heroUpgradeData.exp)
					{
						Alert.warning(StringConst.HERO_UPGRADE_1019);
						return;
					}
					var id:int = int(node.nodeCfg.bi_request);
					if(PositionDataManager.instance.hero_chopid<id)
					{
						Alert.warning(StringConst.HERO_UPGRADE_1014);
						return;
					}
					HeroDataManager.instance.activateNode();
				}else
				{
					
				}
			}
		}		
		
		public function destroy():void
		{
			skin.removeEventListener(MouseEvent.MOUSE_OVER,onOverFunc);
			skin.removeEventListener(MouseEvent.MOUSE_OUT,onOutFunc);
			skin.removeEventListener(MouseEvent.CLICK,onClickFunc);
			skin.removeEventListener(MouseEvent.MOUSE_DOWN,onDownFunc);
			skin.removeEventListener(MouseEvent.MOUSE_UP,onUPFunc);
		}
	}
}