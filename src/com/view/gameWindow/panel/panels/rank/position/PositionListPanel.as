package com.view.gameWindow.panel.panels.rank.position
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.rank.RankDataManager;
	import com.view.gameWindow.util.PageUtil;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	
	public class PositionListPanel extends TabBase
	{
		private var _handler:PositionListHandler;
		private var _mouseHandler:PositionListMouseHandler;

		public var page:PageUtil;
		
		public function PositionListPanel()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McPositionlPanel = new McPositionlPanel;
			_skin = skin as McPositionlPanel;
			addChild(_skin);
			initText(skin);
			page = new PageUtil(RankDataManager.PAGE_DATA_COUNT);
			_handler=new PositionListHandler(this);
			_mouseHandler=new PositionListMouseHandler(this);

		}
		
		private function initText(skin:McPositionlPanel):void
		{
			skin.txt1.text=StringConst.RANK_PANEL_0002;
			skin.txt2.text=StringConst.RANK_PANEL_0003;
			skin.txt3.text=StringConst.RANK_PANEL_0006;
			skin.txt4.text=StringConst.RANK_PANEL_0020;
			skin.txt9.text=StringConst.RANK_PANEL_0017;
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(skin.mcSelectBuf,function (mc:MovieClip):void
			{
				skin.mcSelectBuf.mouseEnabled=false;
				skin.mcSelectBuf.visible=false;
			});
			rsrLoader.addCallBack(skin.mcMouseBuf,function (mc:MovieClip):void
			{
				skin.mcMouseBuf.mouseEnabled=false;
				skin.mcMouseBuf.visible=false;
			});
			super.addCallBack(rsrLoader);
		}
		
		override public function destroy():void
		{
			page=null;
			_mouseHandler&&_mouseHandler.destroy();
			_mouseHandler=null;
			_handler&&_handler.destroy();
			_handler=null;
			super.destroy();
		}
		
		override protected function initData():void
		{
			var rankType:Number = RankDataManager.selectIndex+1;
			RankDataManager.getInstance().queryRankList(rankType);
		}
		
		override public function update(proc:int=0):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_RANK_LIST:
					updateList();
					break;
				default:
					break;
			}
			super.update(proc);
		}
		
		public function updateList():void
		{
			_handler.updateList();
		}
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			RankDataManager.getInstance().attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			RankDataManager.getInstance().detach(this);
			super.detach();
		}
		
	}
}