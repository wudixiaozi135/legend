package com.view.gameWindow.panel.panels.forge.refined
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.consts.ItemType;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.UrlPic;
	import com.view.gameWindow.util.cell.CellData;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;

	/**
	 * 锻造进阶面板单元格处理类
	 * @author Administrator
	 */	
	public class RefinedCellHandle
	{
		private var _tab:TabRefined;
		private var _skin:McRefined;
		internal var cells:Vector.<RefinedCell>;
		private const length:int = 7;
		
		public function RefinedCellHandle(tab:TabRefined)
		{
			_tab = tab;
			_skin = _tab.skin as McRefined;
			initialize();
		}
		
		public function destroy():void
		{
			var cell:RefinedCell;
			for each(cell in cells)
			{
				ToolTipManager.getInstance().detach(cell);
				cell.destroy();
			}
			cells = null;
			_skin = null;
			_tab = null;
		}
		
		private function initialize():void
		{
			_skin.mcSelectEffect.mouseEnabled = false;
			_skin.mcSelectEffect.mouseChildren = false;
			_skin.mcSelectEffect.visible = false;
			cells = new Vector.<RefinedCell>(length,true);
			var i:int;
			for(i=0;i<length;i++)
			{
				var mcEquipItem:McEquipItem = _skin["mcEquipItem"+i] as McEquipItem;
				var bg:MovieClip = mcEquipItem.mcBg;
				var cell:RefinedCell = new RefinedCell(bg,bg.x,bg.y,bg.width,bg.height);
				cells[i] = cell;
				ToolTipManager.getInstance().attach(cell);
			}
		}
		
		internal function refreshData(datas:Vector.<CellData>):void
		{
			var isShow:Boolean;
			var i:int;
			for(i=0;i<length;i++)
			{
				if(i < datas.length)
				{
					var cell:RefinedCell = cells[i];
					var cellData:CellData = datas[i];
					cell.refreshData(cellData);
					setEquipName(cellData,i);
					if(_tab.clickHandle.selectMain && cellData.id == _tab.clickHandle.selectMain.id)
					{
						isShow = true;
					}
				}
				else
				{
					cells[i].setNull();
					setEquipName(null,i);
				}
			}
			_skin.mcSelectEffect.visible = isShow;
			refreshSign();
		}
		
		internal function refreshSign():void
		{
			var i:int;
			for(i=0;i<length;i++)
			{
				var cell:RefinedCell = cells[i];
				var mcEquipItem:McEquipItem = _skin["mcEquipItem"+i] as McEquipItem;
				var layer:MovieClip = mcEquipItem.mcLayerMS;
				var selectMain:CellData = _tab.clickHandle.selectMain;
				var selectSubstitute:CellData = _tab.clickHandle.selectSubstitute;
				if(selectMain && cell.cellData && cell.cellData.id == selectMain.id)
				{
					addSign(layer,true);
				}
				else if(selectSubstitute && cell.cellData && cell.cellData.id == selectSubstitute.id)
				{
					addSign(layer,false);
				}
				else
				{
					removeSign(layer);
				}
			}
		}
		/**加载添加主副标志*/
		public function addSign(layer:MovieClip,isMain:Boolean):void
		{
			removeSign(layer);
			var urlPic:UrlPic = new UrlPic(layer);
			urlPic.load(ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD + (isMain ? "forge/refinedMain.png" : "forge/refinedVice.png"));
		}
		/**移除主副标志*/
		public function removeSign(layer:MovieClip):void
		{
			while(layer.numChildren)
			{
				var bitmap:Bitmap = layer.removeChildAt(0) as Bitmap;
				if(bitmap && bitmap.bitmapData)
				{
					bitmap.bitmapData.dispose();
				}
			}
		}
		
		private function setEquipName(cellData:CellData,i:int):void
		{
			var mcEquipItem:McEquipItem = _skin["mcEquipItem"+i] as McEquipItem;
			if(!cellData)
			{
				mcEquipItem.txt.text = "";
			}
			else
			{
				var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(cellData.bornSid,cellData.id);
				if(memEquipData)
				{
					var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
					if(equipCfgData)
					{
						mcEquipItem.txt.text = equipCfgData.name;
						mcEquipItem.txt.textColor = ItemType.getColorByQuality(equipCfgData.color);
					}
				}
			}
		}
	}
}