package com.view.gameWindow.panel.panels.map
{
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMapProperty;
    import com.view.gameWindow.mainUi.subuis.minimap.MiniMap;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.map.mappic.MapPicHandle;
    import com.view.gameWindow.util.scrollBar.ScrollBar;
    
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFormat;

    public class MapPanel extends PanelBase implements IMapPanel
	{
		private var _mouseEvent:MapMouseEventHandle;

		private var _mapPicHandle:MapPicHandle;
		
		private var _mapSidebar:MapItemSidebar;
		private var _sideBarScrollBar:ScrollBar;
		private var _sidebarWidth:Number = 188;
		private var _sidebarHeight:Number = 352;
		
		public function MapPanel()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McMapPanel = new McMapPanel();
			_skin = skin;
			addChild(skin);
			setTitleBar(skin.dragCell);
			
			_mapSidebar = new MapItemSidebar(_sidebarWidth,_sidebarHeight);
			_mapSidebar.addEventListener(Event.CHANGE,mapSidebarChange);
			skin.sidebarPos.addChild(_mapSidebar);
			//隐藏世界地图按钮
			skin.worldMap.visible = false;
			skin.worldTxt.visible = false;
		}
		
		private function mapSidebarChange(e:Event):void
		{
			if(_sideBarScrollBar)
			{
				_sideBarScrollBar.resetScroll();
			}
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var mc:McMapPanel = _skin as McMapPanel;
			var _txt:TextField;
			rsrLoader.addCallBack(mc.currentMap,function():void
			{
				mc.currentMap.selected = true;
			});
			rsrLoader.addCallBack(mc.worldMap,function():void
			{
				mc.worldMap.selected = false;
			});
			rsrLoader.addCallBack(mc.goBtn,function():void
			{
				_txt =  mc.goBtn.txt as TextField;
				_txt.text = StringConst.MAP_PANEL_0003;
				_txt.textColor = 0xd4a460;
			});
			rsrLoader.addCallBack(mc.mcScrollBar,function(mc:MovieClip):void
			{
				_sideBarScrollBar = new ScrollBar(_mapSidebar,mc,0,_mapSidebar,15);
				_sideBarScrollBar.resetHeight(_sidebarHeight);
			});
		}
		
		override protected function initData():void
		{
			var mcMapPanel:McMapPanel = _skin as McMapPanel;
			initText();
			_mouseEvent = new MapMouseEventHandle();
			_mouseEvent.addEvent(mcMapPanel);
			_mapPicHandle = new MapPicHandle(mcMapPanel.mcPic);
			_mapPicHandle.mapSidebar = _mapSidebar;
			_mouseEvent.mapPicHandle = _mapPicHandle;
		}
		
		private function initText():void
		{
			var _mcSkin:McMapPanel = _skin as McMapPanel;
			var _textFormat:TextFormat = _mcSkin.searchText.defaultTextFormat;
			_textFormat.underline = true;
			_mcSkin.searchText.defaultTextFormat = _textFormat;
			_mcSkin.searchText.setTextFormat(_textFormat);
			_mcSkin.searchText.text = StringConst.MAP_PANEL_0004;
			_mcSkin.searchText.restrict = null;
			_mcSkin.tileX.selectable = true;
			_mcSkin.tileY.selectable = true;
			_mcSkin.currentTxt.mouseEnabled = false;
			_mcSkin.worldTxt.mouseEnabled = false;
			_mcSkin.currentTxt.text = StringConst.MAP_PANEL_0001;
			_mcSkin.currentTxt.textColor = 0xffe1aa;
			_mcSkin.worldTxt.text = StringConst.MAP_PANEL_0002;
			_mcSkin.worldTxt.textColor = 0x675138;
		}
		
		override public function update(proc:int = 0):void
		{
			_mapPicHandle.init();
		}
		
		public function refreshFirstPlayerSign():void
		{
			_mapPicHandle.refreshFirstPlayerSign();
		}
		
		public function addMstSign(id:int):void
		{
			_mapPicHandle.addMstSign(id);
		}
		
		public function refreshMstSign(id:int):void
		{
			_mapPicHandle.refreshMstSign(id);
		}
		
		public function removeMstSign(id:int):void
		{
			_mapPicHandle.removeMstSign(id);
		}
		
		public function addPlayerSign(id:int):void
		{
			_mapPicHandle.addPlayerSign(id);
		}
		
		public function refreshPlayerSign(id:int):void
		{
			_mapPicHandle.refreshPlayerSign(id);
		}
		
		public function refreshMousePoint():void
		{
			_mapPicHandle.refreshMousePoint();
		}
		
		public function removePlayerSign(id:int):void
		{
			_mapPicHandle.removePlayerSign(id);
		}
		
		public function removePathSigns():void
		{
			_mapPicHandle.removePathSigns();
		}

        override public function setPostion():void
        {
            var mc:McMapProperty = (MainUiMediator.getInstance().miniMap as MiniMap).skin as McMapProperty;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.btnMap.x, mc.btnMap.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
        }

        override public function getPanelRect():Rectangle
        {
            return new Rectangle(0, 0, 818, 523);//为什么刚开始时高度为何那么大
        }

        override public function destroy():void
		{
			super.destroy();
			if(_mouseEvent)
				_mouseEvent.mouseEventDestroy();
			_mouseEvent = null;
			if(_mapPicHandle)
				_mapPicHandle.destroy();
			_mapPicHandle = null;
		}
	}
}