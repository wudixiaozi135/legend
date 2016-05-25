package com.view.gameWindow.mainUi.subuis.monsterhp.dropList
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.UrlPic;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	
	import flash.display.Sprite;
	
	public class DropView extends Sprite
	{
		private var _icon:IconCellEx;
		private var _size:Number;
		private var _isWaitingDestroy:Boolean = false;
		private var _sprite:Sprite;

		private var urlPic:UrlPic;

		private var _data:ThingsData;
		public function DropView(size:Number = 24)
		{
			_size = size;
			super();
			drawBg();
		}
		
		public function drawBg():void
		{
			/*graphics.clear();
			graphics.beginFill(0x0,1);
			graphics.drawRect(0,0,_size,_size);
			graphics.endFill();*/
			_sprite = new Sprite();
			addChild(_sprite);
			urlPic = new UrlPic(_sprite);	
			urlPic.load(ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD+"bossHP/bottom"+ResourcePathConstants.POSTFIX_PNG);
		}
		
		public function get isWaitingDestroy():Boolean
		{
			return _isWaitingDestroy;
		}
		
		/*public function get data():DropData
		{
			return _data;
		}*/
		
		public function set data(value:ThingsData):void
		{
			this._data = value;
			
			ToolTipManager.getInstance().detach(this);
			if(_data)
			{
				if(!_icon)
				{
					_icon = new IconCellEx(this,3,3,_size,_size);
				}
				
				IconCellEx.setItemByThingsData(_icon,_data);
				ToolTipManager.getInstance().attach(_icon);
//				_icon.url = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD+_data.icon+ResourcePathConstants.POSTFIX_PNG;
//				var tipVO:TipVO = new TipVO();
//				tipVO.tipData = _data;
//				tipVO.tipType = ToolTipConst.EQUIP_BASE_TIP_NO_COMPLETE;
//				ToolTipManager.getInstance().hashTipInfo(this,tipVO);
//				ToolTipManager.getInstance().attach(this);
			}
		}
		
		public function destroy():void
		{
			urlPic.destroy();
			urlPic=null;
			if(_sprite!=null)
			{
				_sprite.parent.removeChild(_sprite);
			}
			_sprite=null;
			if(_icon)
			{
				_icon.parent&&_icon.parent.removeChild(_icon);
				_icon.destroy();
				_icon = null;
			}
			ToolTipManager.getInstance().detach(this);
		}
	}
}