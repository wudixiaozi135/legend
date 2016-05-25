package com.view.gameWindow.panel.panels.activitys.loongWar.panelList
{
	import com.core.toArray;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.FontFamily;
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.activitys.loongWar.tabApply.DataLoongWarApplyGuild;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.PageListData;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * 龙城争霸审核面板
	 * @author Administrator
	 */	
	public class PanelLoongWarListUnion extends PanelBase
	{
		private const _pageNum:int = 10;

		private var _pageListData:PageListData;
		
		public function PanelLoongWarListUnion()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McLoongWarListUnion = new McLoongWarListUnion();
			_skin = skin;
			addChild(_skin);
		}
		
		override protected function initData():void
		{
			ActivityDataManager.instance.loongWarDataManager.attach(this);
			//
			var skin:McLoongWarListUnion = _skin as McLoongWarListUnion;
			setTitleBar(skin.mcDrag);
			skin.txtTitle.text = StringConst.LOONG_WAR_0060;
			skin.txt0.text = StringConst.LOONG_WAR_0064;
			skin.txt1.text = StringConst.LOONG_WAR_0063;
			//
			_pageListData = new PageListData(_pageNum);
			//
			var i:int,l:int = _pageNum;
			for (i=0;i<l;i++) 
			{
				var mc:McLoongWarListItemUnion = skin["mc"+i] as McLoongWarListItemUnion;
				mc.txt0.mouseEnabled = false;
				mc.txt1.htmlText = HtmlUtils.createHtmlStr(0x00ff00,StringConst.LOONG_WAR_0055,12,false,2,FontFamily.FONT_NAME,true);
				mc.txt2.htmlText = HtmlUtils.createHtmlStr(0x00ff00,StringConst.LOONG_WAR_0056,12,false,2,FontFamily.FONT_NAME,true);
			}
			//
			skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var skin:McLoongWarListUnion = _skin as McLoongWarListUnion;
			switch(event.target)
			{
				case skin.btnDown:
					dealBtnDown();
					break;
				case skin.btnUp:
					dealBtnUp();
					break;
				case skin.btnClose:
					dealClose();
					break;
				default:
					dealDefault(event);
					break;
			}
		}
		
		private function dealBtnDown():void
		{
			var hasNext:Boolean = _pageListData.hasNext();
			if(hasNext)
			{
				_pageListData.next();
				refresh();
			}
		}
		
		private function dealBtnUp():void
		{
			var hasPre:Boolean = _pageListData.hasPre();
			if(hasPre)
			{
				_pageListData.prev();
				refresh();
			}
		}
		
		private function dealClose():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_LOONG_WAR_LIST_UNION);
		}
		
		private function dealDefault(event:MouseEvent):void
		{
			if(event.target is TextField)
			{
				var txt:TextField = event.target as TextField;
				var mc:McLoongWarListItemUnion = txt.parent as McLoongWarListItemUnion;
				if(!mc)
				{
					return;
				}
				var dt:DataLoongWarApplyGuild = mc.dt as DataLoongWarApplyGuild;
				if(!dt)
				{
					return;
				}
				var type:int = txt.text == StringConst.LOONG_WAR_0055 ? 1 : 2;
				ActivityDataManager.instance.loongWarDataManager.cmFamilyLongchengLeagueAction(type,dt);
			}
		}
		
		override public function update(proc:int=0):void
		{
			var dts:Vector.<DataLoongWarApplyGuild> = ActivityDataManager.instance.loongWarDataManager.dtsApplyLeague;
			if(!dts.length && proc == GameServiceConstants.SM_FAMILY_QUERY_LEAGUE_APPLY)
			{
				MainUiMediator.getInstance().bottomBar.sysAlert.removeItemById(args[0]);
				dealClose();
				return;
			}
			var list:Array = new Array();
			toArray(dts,list)
			_pageListData.list = list;
			refresh();
		}
		
		private function refresh():void
		{
			var skin:McLoongWarListUnion = _skin as McLoongWarListUnion;
			var dts:Vector.<DataLoongWarApplyGuild> = _pageListData.list ? Vector.<DataLoongWarApplyGuild>(_pageListData.getCurrentPageData()) : null;
			var i:int,l:int = _pageNum;
			for (i=0;i<l;i++) 
			{
				var mc:McLoongWarListItemUnion = skin["mc"+i] as McLoongWarListItemUnion;
				if(dts && i < dts.length)
				{
					mc.visible = true;
					mc.txt0.text = dts[i].familyName;
					mc.dt = dts[i];
				}
				else
				{
					mc.visible = false;
				}
			}
			//
			skin.txtPage.text = _pageListData.curPage + "/" + _pageListData.totalPage;
		}
		
		override public function destroy():void
		{
			ActivityDataManager.instance.loongWarDataManager.detach(this);
			skin.removeEventListener(MouseEvent.CLICK,onClick);
			super.destroy();
		}
	}
}