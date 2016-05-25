package com.view.gameWindow.panel.panels.hero.tab2
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import mx.utils.StringUtil;
	
	public class HeroUpgradeTab extends TabBase
	{
		private var _handler:HeroUpgradeHandler;
		private var _mouseHandler:HeroUpgradeMouseHandler;
		public function HeroUpgradeTab()
		{
			super();
			this.mouseEnabled=false;
		}
		
		override protected function initSkin():void
		{
			var skin:MCHeroUpgradeTab = new MCHeroUpgradeTab();
			skin.mouseEnabled=false;
			_skin = skin;
			addChild(_skin);
			_handler=new HeroUpgradeHandler(this);
			_mouseHandler=new HeroUpgradeMouseHandler(this);
			
			initText();
		}
		
		private function initText():void
		{
			var panel:MCHeroUpgradeTab = _skin as MCHeroUpgradeTab;
			panel.txt1.htmlText=HtmlUtils.createHtmlStr(0x00ff00,StringConst.HERO_UPGRADE_1000);
			panel.txt2.text=StringConst.HERO_UPGRADE_1001;
			panel.txt3.htmlText=HtmlUtils.createHtmlStr(0x00ff00,StringConst.HERO_UPGRADE_1002);
			var html2:String = HtmlUtils.createHtmlStr(0xffffff,StringUtil.substitute(StringConst.HERO_UPGRADE_1004,VipDataManager.instance.lv));
			ToolTipManager.getInstance().attachByTipVO(panel.txt1,ToolTipConst.TEXT_TIP,html2);
			var html1:String = HtmlUtils.createHtmlStr(0xffffff,StringConst.HERO_UPGRADE_1003);
			ToolTipManager.getInstance().attachByTipVO(panel.txt3,ToolTipConst.TEXT_TIP,html1);
		}
		 
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			super.addCallBack(rsrLoader);
		}
		
		override public function destroy():void
		{
			ToolTipManager.getInstance().detach(skin.txt1);
			ToolTipManager.getInstance().detach(skin.txt3);
			_mouseHandler&&_mouseHandler.destroy();
			_mouseHandler=null;
			_handler&&_handler.destroy();
			_handler=null;
			super.destroy();
		}
		
		private function refreshSource():void
		{
			var mc:MCHeroUpgradeTab=skin as MCHeroUpgradeTab;
			loadNewSource(mc.current_bg);
			loadNewSource(mc.current_txt);
			loadNewSource(mc.next_bg);
			loadNewSource(mc.next_txt);
			loadNewSource(mc.hero_bg);
			loadNewSource(mc.hero_base);
			if(_handler.mCHeroUpgradeAlert!=null)
			{
				rsrLoader.load(_handler.mCHeroUpgradeAlert,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
			}
		}
		
		override protected function initData():void
		{
			// TODO Auto Generated method stub
			HeroDataManager.instance.requestHeroUpgradeData();
		}	
		
		override public function update(proc:int=0):void
		{
			if(proc==GameServiceConstants.SM_HERO_INFO)
			{
				initData();
			}
			else if(proc==GameServiceConstants.SM_QUERY_HERO_GRADE)
			{
				_handler.updatePanel();
				refreshSource();
			}
			super.update(proc);
		}
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			HeroDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			HeroDataManager.instance.detach(this);
			super.detach();
		}
		
	}
}