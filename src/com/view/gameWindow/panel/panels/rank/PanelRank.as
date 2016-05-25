package com.view.gameWindow.panel.panels.rank
{
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMapProperty;
    import com.view.gameWindow.mainUi.subuis.minimap.MiniMap;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.ObjectUtils;

    import flash.display.MovieClip;
    import flash.geom.Point;

    public class PanelRank extends PanelBase
	{
		private var _mouseHandle:RankMouseHandler;
		
		public function PanelRank()
		{
			RankDataManager.getInstance().attach(this);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:mcRankPanel = _skin as mcRankPanel;
			var i:int = 0, len:int = 7;
			
			for (; i < len; i++)
			{
				rsrLoader.addCallBack(skin["pic" + i], getPic(i));
			}
			i = 0;
			
			for (; i < len; i++)
			{
				rsrLoader.addCallBack(skin["tab" + i], getTab(i));
			}
		}
		
		private function getTab(i:int):Function
		{
			var func:Function = function (mc:MovieClip):void
			{
				var selectIndex:int = RankDataManager.selectIndex;
				var lastMc:MovieClip;
				if (selectIndex >= 0)
				{
					if (i == selectIndex)
					{
						RankDataManager.lastMc = mc;
						lastMc = RankDataManager.lastMc;
						lastMc.selected = true;
						lastMc.mouseEnabled = false;
					}
				} else
				{
					if (i == 0)
					{
						RankDataManager.lastMc = mc;
						lastMc = RankDataManager.lastMc;
						lastMc.selected = true;
						lastMc.mouseEnabled = false;
					}
				}
			};
			return func;
		}
		
		private function getPic(i:int):Function
		{
			var func:Function = function (mc:MovieClip):void
			{
				mc.mouseEnabled = false;
				mc.mouseChildren = false;
				var selectIndex:int = RankDataManager.selectIndex;
				var lastMc:MovieClip;
				if (selectIndex >= 0)
				{
					if (i == selectIndex)
					{
						mc.filters = [ObjectUtils.btnlightFilter];
					}
				} else
				{
					if (i == 0)
					{
						mc.filters = [ObjectUtils.btnlightFilter];
					}
				}
			};
			return func;
		}
		
		override public function destroy():void
		{
			RankDataManager.getInstance().detach(this);
			if(_mouseHandle)
			{
				_mouseHandle.destroy();
				_mouseHandle = null;
			}
			super.destroy();
		}
		
		override protected function initData():void
		{
			_mouseHandle=new RankMouseHandler(this);
		}
		
		override protected function initSkin():void
		{
			_skin=new mcRankPanel();
			addChild(_skin);
			setTitleBar(_skin.mcTitleBar);
			_skin.txt.htmlText=HtmlUtils.createHtmlStr(0xFFE1AA,StringConst.RANK_PANEL_0001,14,true);
		}

		
		override public function setPostion():void
		{
            var mc:McMapProperty = (MainUiMediator.getInstance().miniMap as MiniMap).skin as McMapProperty;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.btnRanking.x, mc.btnRanking.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
		}
		
		override public function update(proc:int=0):void
		{
			super.update(proc);
		}
	}
}