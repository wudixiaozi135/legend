package com.view.gameWindow.panel.panels.activitys.castellanWorship
{
	import com.core.toArray;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.util.PageListData;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	public class PanelWorshipInfos extends PanelBase
	{
		private const _pageNum:int = 5;
		private var _pageListData:PageListData;
		
		public function PanelWorshipInfos()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McWorshipInfos = new McWorshipInfos();
			_skin = skin;
			addChild(_skin);
			setTitleBar(skin.mcDrag);
		}
		
		override protected function initData():void
		{
			ActivityDataManager.instance.worshipDataManager.attach(this);
			//
			initText();
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			_pageListData = new PageListData(5);
		}
		
		private function initText():void
		{
			var skin:McWorshipInfos = skin as McWorshipInfos;
			//
			skin.txtTitle.text = StringConst.WORSHIP_INFOS_0001;
			var defaultTextFormat:TextFormat = skin.txtTitle.defaultTextFormat;
			defaultTextFormat.bold = true;
			skin.txtTitle.defaultTextFormat = defaultTextFormat;
			skin.txtTitle.setTextFormat(defaultTextFormat);
			//
			skin.txtTime.text = StringConst.WORSHIP_INFOS_0002;
			//
			skin.txtInfos.text = StringConst.WORSHIP_INFOS_0003;
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var skin:McWorshipInfos = skin as McWorshipInfos;
			switch(event.target)
			{
				case skin.btnClose:
					dealBtnClose();
					break;
				case skin.btnUp:
					dealBtnPrev();
					break;
				case skin.btnDown:
					dealBtnNext();
					break;
				default:
					break;
			}
		}
		
		private function dealBtnClose():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_WORSHIP_INFOS);
		}
		
		private function dealBtnPrev():void
		{
			var hasPre:Boolean = _pageListData.hasPre();
			if(hasPre)
			{
				_pageListData.prev();
				refresh();
			}
		}
		
		private function dealBtnNext():void
		{
			var hasNext:Boolean = _pageListData.hasNext();
			if(hasNext)
			{
				_pageListData.next();
				refresh();
			}
		}
		
		override public function update(proc:int = GameServiceConstants.SM_QUERY_MASTER_WORSHIP_RECORD):void
		{
			if(proc != GameServiceConstants.SM_QUERY_MASTER_WORSHIP_RECORD)
			{
				return;
			}
			var dts:Vector.<DataWorshipRecord> = ActivityDataManager.instance.worshipDataManager.dtsRecord;
			var list:Array = new Array();
			toArray(dts,list)
			_pageListData.list = list;
			//
			refresh();
		}
		
		private function refresh():void
		{
			var skin:McWorshipInfos = _skin as McWorshipInfos;
			var dts:Vector.<DataWorshipRecord> = _pageListData.list ? Vector.<DataWorshipRecord>(_pageListData.getCurrentPageData()) : null;
			var i:int,l:int = _pageNum;
			for (i=0;i<l;i++) 
			{
				var mc:McTxtInfos = skin["txts"+i] as McTxtInfos;
				if(dts && i < dts.length)
				{
					mc.visible = true;
					var dt:DataWorshipRecord = dts[i];
					mc.txtTime.text = dt.strTime;
					mc.txtInfos.htmlText = dt.strInfos;
				}
				else
				{
					mc.visible = false;
				}
			}
			//
			skin.txtPage.text = _pageListData.curPage + "/" + _pageListData.totalPage;
			//
			skin.btnUp.btnEnabled = _pageListData.hasPre();
			skin.btnDown.btnEnabled = _pageListData.hasNext();
		}
		
		override public function destroy():void
		{
			ActivityDataManager.instance.worshipDataManager.detach(this);
			_pageListData.destroy();
			_skin.removeEventListener(MouseEvent.CLICK,onClick);
			super.destroy();
		}
	}
}