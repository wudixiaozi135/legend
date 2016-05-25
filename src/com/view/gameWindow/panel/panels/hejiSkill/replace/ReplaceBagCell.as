package com.view.gameWindow.panel.panels.hejiSkill.replace
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.consts.SlotType;
	import com.view.gameWindow.common.ResManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	import com.view.gameWindow.util.scrollBar.IScrolleeCell;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class ReplaceBagCell extends Sprite implements IScrolleeCell
	{
		private var _iconCell:IconCellEx;
		private var _bg:Bitmap;
		
		public function ReplaceBagCell():void
		{
			initBG();
		}
		
		private function initBG():void
		{
			_bg=new Bitmap();
			addChild(_bg);
			_iconCell=new IconCellEx(this,4,4,38,38);
			ResManager.getInstance().loadBitmap(ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD+"bagPanel/bagCell.png",loadComple);
		}
		
		private function loadComple(bitmap:BitmapData,url:String):void
		{
			// TODO Auto Generated method stub
			if(_bg)
			{
				_bg.bitmapData=bitmap;
			}
		}
		
		public function setItem(itemId:int,num:int):void
		{
			IconCellEx.setItem(_iconCell,SlotType.IT_ITEM,itemId,num);
//			var td:ThingsData=new ThingsData();
//			td.id=itemId;
//			td.type=SlotType.IT_ITEM;
//			td.count=num;
//				
//			IconCellEx.setItemByThingsData(_iconCell,td);
			ToolTipManager.getInstance().attach(_iconCell);
		}
		
		public function destroy():void
		{
			// TODO Auto Generated method stub
			ToolTipManager.getInstance().detach(_iconCell);
			if(_iconCell)
			{
				_iconCell.destroy();
				_iconCell.parent&&_iconCell.parent.removeChild(_iconCell);
			}
			_iconCell=null;
			
			if(_bg)
			{
				_bg.parent&&_bg.parent.removeChild(_bg);
				_bg.bitmapData.dispose();
			}
			_bg=null;
		}

		public function get iconCell():IconCellEx
		{
			return _iconCell;
		}

		public function set iconCell(value:IconCellEx):void
		{
			_iconCell = value;
		}

		
	}
}