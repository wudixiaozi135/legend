package com.view.gameWindow.panel.panels.closet.handle
{
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.panels.closet.ClosetData;
    import com.view.gameWindow.panel.panels.closet.ClosetDataManager;
    import com.view.gameWindow.panel.panels.closet.ClosetPanel;
    import com.view.gameWindow.panel.panels.closet.McClosetPanel;
    import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
    
    import flash.display.MovieClip;

    public class ClosetAddCallBackHandle
	{
		private var _panel:ClosetPanel;
		private var _skin:McClosetPanel;
		
		public function ClosetAddCallBackHandle(panel:ClosetPanel)
		{
			_panel = panel;
			_skin = _panel.skin as McClosetPanel;
		}
		
		public function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(_skin.fashionBtn,function(mc:MovieClip):void
			{
				var current:int = ClosetDataManager.instance.current;
				var selectBtn:MovieClip = current == ConstEquipCell.TYPE_SHIZHUANG ? mc : null;
				_panel.mouseEvent.setBtnState(selectBtn,true);
			});
			rsrLoader.addCallBack(_skin.bambooBtn,function(mc:MovieClip):void
			{
				var current:int = ClosetDataManager.instance.current;
				var selectBtn:MovieClip = current == ConstEquipCell.TYPE_DOULI ? mc : null;
				_panel.mouseEvent.setBtnState(selectBtn,true);
			});
			rsrLoader.addCallBack(_skin.footprintBtn,function(mc:MovieClip):void
			{
				var current:int = ClosetDataManager.instance.current;
				var selectBtn:MovieClip = current == ConstEquipCell.TYPE_ZUJI ? mc : null;
				_panel.mouseEvent.setBtnState(selectBtn,true);
			});
			rsrLoader.addCallBack(_skin.huanwuBtn,function(mc:MovieClip):void
			{
				var current:int = ClosetDataManager.instance.current;
				var selectBtn:MovieClip = current == ConstEquipCell.TYPE_HUANWU ? mc : null;
				_panel.mouseEvent.setBtnState(selectBtn,true);
			});
			rsrLoader.addCallBack(_skin.btnLevelUp,function(mc:MovieClip):void
			{
				_skin.btnLevelUp.txt.text = StringConst.CLOSET_PANEL_0006;
				_skin.btnLevelUp.txt.textColor = 0xd4a460;
			});
			rsrLoader.addCallBack(_skin.btnPutIn,function(mc:MovieClip):void
			{
				var currentClosetData:ClosetData = ClosetDataManager.instance.currentClosetData();
				_skin.btnPutIn.txt.text = currentClosetData.textPutInBtn;
				_skin.btnPutIn.txt.textColor = 0xd4a460;
			});
			rsrLoader.addCallBack(_skin.mcLevel,function(mc:MovieClip):void
			{
				var currentClosetData:ClosetData = ClosetDataManager.instance.currentClosetData();
				
				if(currentClosetData)
				{
					if(!currentClosetData.level)
					{
						_skin.mcLevel.visible = false;
					}
					else
					{
						_skin.mcLevel.visible = true;
						_skin.mcLevel.gotoAndStop(currentClosetData.level);
					}
				}
			});
			rsrLoader.addCallBack(_skin.btnChange,function(mc:MovieClip):void
			{
				var currentClosetData:ClosetData = ClosetDataManager.instance.currentClosetData();
				
				if(currentClosetData)
				{
					_skin.btnChange.visible = Boolean(currentClosetData.fashionIds.length);
					var fashionIds:Vector.<int> = currentClosetData.fashionIds;
					_skin.btnChange.visible = Boolean(fashionIds.length);
					if(fashionIds.length && fashionIds[0] == currentClosetData.fashionId)
					{
						_skin.btnChange.selected = true;
					}
					else
					{
						_skin.btnChange.selected = false;
					}
				}
			});
			
			rsrLoader.addCallBack(_skin.mcName,function(mc:MovieClip):void
			{
				++count;
				if(count == 2)
				{
					_panel.mouseEvent.refresh();
				}
			});
			
			rsrLoader.addCallBack(_skin.mcLevel,function(mc:MovieClip):void
			{
				++count;
				if(count == 2)
				{
					_panel.mouseEvent.refresh();
				}
			});
		}
		
		private var count:int = 0;
	}
}