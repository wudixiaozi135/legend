package com.view.gameWindow.panel.panels.thingNew.itemNew
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.ConstStorage;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.util.cell.IconCell;
	
	import flash.display.MovieClip;
	
	public class ItemCell extends IconCell
	{
		private var _bg:MovieClip;
		private var _id:int;

		private var _bagData:BagData;
		
		public function ItemCell(bg:MovieClip)
		{
			_bg = bg;
			super(bg.parent, bg.x, bg.y, bg.width, bg.height);
		}
		
		override public function getTipData():Object
		{
			var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(_id);
			if(itemCfgData)
			{
				if(!_bagData)
				{
					_bagData = new BagData();
				}
				_bagData.id = _id;
				_bagData.storageType == ConstStorage.ST_CHR_BAG;
				return _bagData;
			}
			else
			{
				return null;
			}
		}
		
		override public function getTipType():int
		{
			return ToolTipConst.ITEM_BASE_TIP;
		}
		
		public function refreshData(id:int):void
		{
			if(_id != id)
			{
				_id = id;
				var url:String = "";
				var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(_id);
				if(itemCfgData)
				{
					url = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD+itemCfgData.icon+ResourcePathConstants.POSTFIX_PNG;
					loadPic(url);
				}
				else
				{
					trace("MailCell.refreshData 物品配置不存在");
				}
			}
		}
		
		public function setNull():void
		{
			_bagData = null;
			_bg.visible = true;
			_id = 0;
			destroyBmp();
		}
		
		override public function destroy():void
		{
			setNull();
			_bg = null;
			super.destroy();
		}
	}
}