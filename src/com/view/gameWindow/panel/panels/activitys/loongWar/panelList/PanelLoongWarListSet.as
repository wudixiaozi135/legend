package com.view.gameWindow.panel.panels.activitys.loongWar.panelList
{
	import com.core.toArray;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.FontFamily;
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.PageListData;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * 龙城争霸任命面板
	 * @author Administrator
	 */	
	public class PanelLoongWarListSet extends PanelBase
	{
		private const _pageNum:int = 10;
		
		private var _pageListData:PageListData;
		
		public function PanelLoongWarListSet()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McLoongWarListSet = new McLoongWarListSet();
			_skin = skin;
			addChild(_skin);
		}
		
		override protected function initData():void
		{
			ActivityDataManager.instance.loongWarDataManager.attach(this);
			//
			var skin:McLoongWarListSet = _skin as McLoongWarListSet;
			setTitleBar(skin.mcDrag);
			skin.txtTitle.text = StringConst.LOONG_WAR_0059;
			skin.txt0.text = StringConst.LOONG_WAR_0061;
			skin.txt1.text = StringConst.LOONG_WAR_0062;
			skin.txt2.text = StringConst.LOONG_WAR_0063;
			//
			_pageListData = new PageListData(_pageNum);
			//
			var i:int,l:int = _pageNum;
			for (i=0;i<l;i++) 
			{
				var mc:McLoongWarListItemSet = skin["mc"+i] as McLoongWarListItemSet;
				mc.txt0.mouseEnabled = false;
				mc.txt1.mouseEnabled = false;
				mc.txt2.htmlText = HtmlUtils.createHtmlStr(0x00ff00,StringConst.LOONG_WAR_0054,12,false,2,FontFamily.FONT_NAME,true);
			}
			//
			skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var skin:McLoongWarListSet = _skin as McLoongWarListSet;
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
			PanelMediator.instance.closePanel(PanelConst.TYPE_LOONG_WAR_LIST_SET);
		}
		
		private function dealDefault(event:MouseEvent):void
		{
			if(event.target is TextField)
			{
				var txt:TextField = event.target as TextField;
				var mc:McLoongWarListItemSet = txt.parent as McLoongWarListItemSet;
				if(!mc)
				{
					return;
				}
				var dt:DataLoongWarSet = mc.dt as DataLoongWarSet;
				if(!dt)
				{
					return;
				}
				ActivityDataManager.instance.loongWarDataManager.cmLongchengAppoint(dt,args[0]);
			}
		}
		
		override public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.CM_LONGCHENG_APPOINT)
			{
				dealClose();
				return;
			}
			var dts:Vector.<DataLoongWarSet> = ActivityDataManager.instance.loongWarDataManager.dtsSet;
			var list:Array = new Array();
			toArray(dts,list)
			_pageListData.list = list;
			refresh();
		}
		
		private function refresh():void
		{
			var skin:McLoongWarListSet = _skin as McLoongWarListSet;
			var dts:Vector.<DataLoongWarSet> = _pageListData.list ? Vector.<DataLoongWarSet>(_pageListData.getCurrentPageData()) : null;
			var i:int,l:int = _pageNum;
			for (i=0;i<l;i++) 
			{
				var mc:McLoongWarListItemSet = skin["mc"+i] as McLoongWarListItemSet;
				if(dts && i < dts.length)
				{
					mc.visible = true;
					var dt:DataLoongWarSet = dts[i];
					mc.txt0.text = dt.name;
					mc.txt1.text = dt.score+"";
					mc.dt = dt;
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