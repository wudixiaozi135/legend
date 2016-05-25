package com.view.gameWindow.panel.panels.dragonTreasure.treasureReward
{
	import com.model.configData.cfgdata.TreasureGiftCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.dragonTreasure.DragonTreasureManager;
	import com.view.gameWindow.panel.panels.dragonTreasure.event.DragonTreasureEvent;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.ObjectUtils;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;

	/**
	 * Created by Administrator on 2014/12/1.
	 */
	public class RewardViewHandler
	{
		private static const TOTAL_CELL_NUM:int = 70;//70个格子数量
		private static const ICON_SIZE:int = 36;//图片尺寸

		private var _panel:PanelTreasureReward;
		private var _skin:McTreasureReward;
		private var _cellIcons:Vector.<IconCellEx>;
		private var _cellData:Vector.<ThingsData>;

		private var _totalPage:int;
		private var _currentPage:int = 1;
		private var _totalDatas:Vector.<TreasureGiftCfgData>;

		public function RewardViewHandler(panel:PanelTreasureReward)
		{
			_panel = panel;
			_skin = _panel.skin as McTreasureReward;
			initialize();
			DragonTreasureEvent.addEventListener(DragonTreasureEvent.VIEW_ALL_GOODS, viewAllHandler, false, 0, true);
		}

		private function viewAllHandler(event:DragonTreasureEvent):void
		{
			var mgt:DragonTreasureManager = DragonTreasureManager.instance;
			var type:int = mgt.getTypeBySelectIndex();
			_totalDatas = mgt.getTypeGiftConfig(type);

			_totalPage = ObjectUtils.getTotalPage(_totalDatas.length, TOTAL_CELL_NUM);
			if(_totalPage==1){
				_skin.btnLeft.selected=_skin.btnRight.selected=false;
			}

			updatePage();
			refresh();
		}

		public function refresh():void
		{
			destroyTip();
			var iconData:TreasureGiftCfgData, count:int = 0, dt:ThingsData, iconEx:IconCellEx;
			_cellIcons.forEach(function(element:IconCellEx,index:int,vec:Vector.<IconCellEx>):void{
				element.visible=false;
				element.loadEffect("");
			},null);

			for (var i:int = (_currentPage - 1) * TOTAL_CELL_NUM, len:int = _totalDatas.length; i < len; i++)
			{
				if (i < _currentPage * TOTAL_CELL_NUM)
				{
					iconData = _totalDatas[i];
					dt = _cellData[count];
					dt.id = iconData.item_id;
					dt.type = iconData.item_type;
					iconEx = _cellIcons[count];
					iconEx.visible=true;
					IconCellEx.setItemByThingsData(iconEx, dt);
					ToolTipManager.getInstance().attach(iconEx);
				}
				count++;
			}
		}

		public function turnLeft():void
		{
			if(_currentPage>1){
				_currentPage--;
			}
			updatePage();
		}

		public function turnRight():void
		{
			if(_currentPage<_totalPage){
				_currentPage++;
			}
			updatePage();
		}
		private function updatePage():void
		{
			_skin.txtContent.text = _currentPage + "/" + _totalPage;

			if(_totalPage==1){
				_skin.btnLeft.btnEnabled=false;
				_skin.btnRight.btnEnabled=false;
			}else{
				if(_currentPage<_totalPage){
					if(_currentPage!=1){
						_skin.btnLeft.btnEnabled=true;
						_skin.btnRight.btnEnabled=true;
					}else{
						_skin.btnLeft.btnEnabled=false;
						_skin.btnRight.btnEnabled=true;
					}
				}else if(_currentPage==_totalPage){
					_skin.btnLeft.btnEnabled=true;
					_skin.btnRight.btnEnabled=false;
				}
			}
			refresh();
		}

		private function initialize():void
		{
			_skin.txtName.text = StringConst.PANEL_DRAGON_TREASURE_009;
			_skin.txtName.mouseEnabled = false;
			_skin.txtContent.mouseEnabled = false;
			_cellIcons = new Vector.<IconCellEx>();
			_cellData = new Vector.<ThingsData>();

			var row:int = 7, column:int = 10;
			var cell:TreasureRewardCell;
			for (var i:int = 0; i < row; i++)
			{
				for (var j:int = 0; j < column; j++)
				{
					cell = new TreasureRewardCell();
					cell.x = cell.width * j;
					cell.y = cell.height * i;
					_skin.container.addChild(cell);

					var cellEx:IconCellEx = new IconCellEx(cell, (cell.width - ICON_SIZE) >> 1, (cell.height - ICON_SIZE) >> 1, ICON_SIZE, ICON_SIZE);
					_cellIcons.push(cellEx);

					var dt:ThingsData = new ThingsData();
					_cellData.push(dt);
				}
			}
		}

		private function destroyTip():void
		{
			if (_cellIcons)
			{
				_cellIcons.forEach(function (cell:IconCellEx, index:int, vec:Vector.<IconCellEx>):void
				{
					ToolTipManager.getInstance().detach(cell);
				}, null);
			}
		}

		public function destroy():void
		{
			DragonTreasureEvent.removeEventListener(DragonTreasureEvent.VIEW_ALL_GOODS, viewAllHandler);
			if (_cellIcons)
			{
				destroyTip();
				for each(var cell:IconCellEx in _cellIcons)
				{
					cell.destroy();
					cell = null;
				}
				_cellIcons = null;
			}
			if (_cellData)
			{
				for each(var data:ThingsData in _cellData)
				{
					data = null;
				}
				_cellData = null;
			}
			if (_skin.container)
			{
				ObjectUtils.clearAllChild(_skin.container);
			}
		}
	}
}
