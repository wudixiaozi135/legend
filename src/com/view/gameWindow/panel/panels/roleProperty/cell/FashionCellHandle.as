package com.view.gameWindow.panel.panels.roleProperty.cell
{
    import com.view.gameWindow.panel.panels.closet.ClosetData;
    import com.view.gameWindow.panel.panels.closet.ClosetDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.McRole;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    
    import flash.display.MovieClip;
    import flash.utils.Dictionary;

    /**
	 * 时装格子处理类
	 * @author Administrator
	 */	
	public class FashionCellHandle
	{
		private var _fashionCells:Vector.<FashionCell>;
		private var _dicCells:Dictionary;
		
		public function FashionCellHandle()
		{
			_fashionCells = new Vector.<FashionCell>();
			_dicCells = new Dictionary();
		}
		
		public function initData(mc:McRole):void
		{
			var vector:Vector.<MovieClip>,vector1:Vector.<int>,fashionCell:FashionCell,i:int;
			vector = Vector.<MovieClip>([mc.mcFashionBg,mc.mcDouliBg,mc.mcSpoorBg,mc.mcHuanwuBg]);
            vector1 = Vector.<int>([ConstEquipCell.TYPE_SHIZHUANG, ConstEquipCell.TYPE_DOULI, ConstEquipCell.TYPE_ZUJI, ConstEquipCell.TYPE_HUANWU]);
			for(i=0;i<4;i++)
			{
				fashionCell = new FashionCell(vector[i]);
				ToolTipManager.getInstance().attach(fashionCell);
				_dicCells[vector1[i]] = fashionCell;
				_fashionCells.push(fashionCell);
			}
		}
		
		public function set visible(value:Boolean):void
		{
			var i:int,l:int;
			l = _fashionCells.length;
			for(i=0;i<l;i++)
			{
				_fashionCells[i].visible = value;
			}
		}
		
		public function refresh():void
		{
			var closetData:ClosetData,closetDatas:Dictionary;
			closetDatas = ClosetDataManager.instance.closetDatas;
			var i:int,l:int;
			l = _fashionCells.length;
			for each(closetData in closetDatas)
			{
				var fashionCell:FashionCell = _dicCells[closetData.type] as FashionCell;
				if(closetData.fashionId)
				{
					fashionCell.refreshData(closetData.fashionId);
				}
				else
				{
					fashionCell.setNull();
				}
			}
		}
		
		public function destroy():void
		{
			_dicCells = null;
			while(_fashionCells && _fashionCells.length)
			{
				var fashionCell:FashionCell = _fashionCells.pop();
				ToolTipManager.getInstance().detach(fashionCell);
				fashionCell.destroy();
			}
			_fashionCells = null;
		}
	}
}