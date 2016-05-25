package com.view.gameWindow.panel.panels.hero.tab1.equip
{
	import com.view.gameWindow.mainUi.subuis.herohead.McHeroPanel;
	import com.view.gameWindow.panel.panels.closet.ClosetData;
	import com.view.gameWindow.panel.panels.closet.ClosetDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
	import com.view.gameWindow.panel.panels.roleProperty.cell.FashionCell;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	/**
	 * 英雄时装格子处理类
	 * @author Administrator
	 */	
	public class HeroFashionCellHandle
	{
		private var _fashionCells:Vector.<FashionCell>;
		private var _dicCells:Dictionary;
		
		public function HeroFashionCellHandle()
		{
			_fashionCells = new Vector.<FashionCell>();
			_dicCells = new Dictionary();
		}
		
		public function initData(mc:McHeroPanel):void
		{
			var vector:Vector.<MovieClip>,vector1:Vector.<int>,fashionCell:FashionCell,i:int;
			vector = Vector.<MovieClip>([mc.mcDouliBg,mc.mcFashionBg,mc.mcWingBg,mc.mcSpoorBg]);
			vector1 = Vector.<int>([ConstEquipCell.TYPE_DOULI,ConstEquipCell.TYPE_SHIZHUANG,ConstEquipCell.TYPE_CHIBANG,ConstEquipCell.TYPE_ZUJI]);
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