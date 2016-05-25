package com.view.gameWindow.panel.panels.activitys.loongWar.panelList
{
	import com.core.toArray;
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.activitys.loongWar.trace.DataLoongWarFamilyRank;
	import com.view.gameWindow.util.PageListData;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * 查看更多排名列表
	 * @author Administrator
	 */	
	public class PanelLoongWarListRank extends PanelBase
	{
		private const _pageNum:int = 10;
		
		private var _pageListData:PageListData;
		
		public function PanelLoongWarListRank()
		{
			super();
		}
		override protected function initSkin():void
		{
			var skin:McLoongWarListRank = new McLoongWarListRank();
			_skin = skin;
			addChild(_skin);
		}
		
		override protected function initData():void
		{
			ActivityDataManager.instance.loongWarDataManager.attach(this);
			//
			var skin:McLoongWarListRank = _skin as McLoongWarListRank;
			setTitleBar(skin.mcDrag);
			skin.txtTitle.text = StringConst.LOONG_WAR_RANK_0001;
			skin.txt0.text = StringConst.LOONG_WAR_RANK_0002;
			skin.txt1.text = StringConst.LOONG_WAR_RANK_0003;
			skin.txt2.text = StringConst.LOONG_WAR_RANK_0004;
			//
			_pageListData = new PageListData(_pageNum);
			//
			skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var skin:McLoongWarListRank = _skin as McLoongWarListRank;
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
			PanelMediator.instance.closePanel(PanelConst.TYPE_LOONG_WAR_LIST_RANK);
		}
		
		private function dealDefault(event:MouseEvent):void
		{
			if(event.target is TextField)
			{
				
			}
		}
		
		override public function update(proc:int=0):void
		{
			var dts:Vector.<DataLoongWarFamilyRank> = ActivityDataManager.instance.loongWarDataManager.dtLWTrace.dtsFamilyRank;
			var list:Array = new Array();
			toArray(dts,list)
			_pageListData.list = list;
			refresh();
		}
		
		private function refresh():void
		{
			var skin:McLoongWarListRank = _skin as McLoongWarListRank;
			var dts:Vector.<DataLoongWarFamilyRank> = _pageListData.list ? Vector.<DataLoongWarFamilyRank>(_pageListData.getCurrentPageData()) : null;
			var i:int,l:int = _pageNum;
			for (i=0;i<l;i++) 
			{
				var mc:McLoongWarListItemRank = skin["mc"+i] as McLoongWarListItemRank;
				if(dts && i < dts.length)
				{
					mc.visible = true;
					var dt:DataLoongWarFamilyRank = dts[i];
					mc.txt0.text = (i + 1 + (_pageListData.curPage - 1) * _pageNum)+"";
					mc.txt1.text = dt.familyName;
					mc.txt2.text = dt.familyScore+"";
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