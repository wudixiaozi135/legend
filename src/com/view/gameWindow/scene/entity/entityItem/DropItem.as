package com.view.gameWindow.scene.entity.entityItem
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.RoughEase;
	import com.model.business.fileService.GameBitmapDataManager;
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.ItemType;
	import com.model.consts.SlotType;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityInfoLabel.DropItemInfoLabel;
	import com.view.gameWindow.scene.entity.entityItem.interf.IDropItem;
	import com.view.gameWindow.scene.map.utils.MapTileUtils;
	
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class DropItem extends Entity implements IDropItem,IUrlBitmapDataLoaderReceiver
	{
		private var _itemId:int;
		private var _itemType:int;
		private var _itemCount:int;
		private var _ownerTeamId:int;
		private var _ownerCid:int;
		private var _ownerSid:int;
		private var _ownerName:String;
		private var _urlBitmapDataLoader:UrlBitmapDataLoader;
		private var _bitmapData:BitmapData;
		private var _isTween:Boolean;
		
		private static var _shadowBitmapData:BitmapData;
		public var isNotShowBornEffect:int;
		
		public function DropItem()
		{
			
		}
		
		override public function set entityId(value:int):void
		{
			super.entityId = value;
			if(_infoLabel)
			{
				_infoLabel.entityId = _entityId;
			}
		}
		
		public override function get entityType():int
		{
			return EntityTypes.ET_DROPITEM;
		}
		
		public function get itemId():int
		{
			return _itemId;
		}
		
		public function set itemId(value:int):void
		{
			_itemId = value;
		}
		
		public function get itemType():int
		{
			return _itemType;
		}
		
		public function set itemType(value:int):void
		{
			_itemType = value;
		}
		
		public function get itemCount():int
		{
			return _itemCount;
		}
		
		public function set itemCount(value:int):void
		{
			_itemCount = value;
		}
		
		public function get ownerTeamId():int
		{
			return _ownerTeamId;
		}
		
		public function set ownerTeamId(value:int):void
		{
			_ownerTeamId = value;
		}
		
		public function get ownerCid():int
		{
			return _ownerCid;
		}
		
		public function set ownerCid(value:int):void
		{
			_ownerCid = value;
		}
		
		public function get ownerSid():int
		{
			return _ownerSid;
		}
		
		public function set ownerSid(value:int):void
		{
			_ownerSid = value;
		}
		
		public function get ownerName():String
		{
			return _ownerName;
		}
		
		public function set ownerName(value:String):void
		{
			_entityName = _ownerName = value;
		}
		
		public override function initInfoLabel():void
		{
			_infoLabel = new DropItemInfoLabel();
		}
		
		public function loadPic():void
		{
			var url:String;
			if(_itemType == SlotType.IT_EQUIP)
			{
				/*var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(id);*/
				var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(_itemId);
				if(!equipCfgData)
				{
					trace("in DropItem.loadPic 不存在id"+_itemId)
					return;
				}
				url = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD+equipCfgData.drop_icon+ResourcePathConstants.POSTFIX_PNG;
			}
			else if(_itemType == SlotType.IT_ITEM)
			{
				var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(_itemId);
				if(!itemCfgData)
				{
					trace("in DropItem.loadPic 不存在id"+_itemId)
					return;
				}
				url = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD+itemCfgData.drop_icon+ResourcePathConstants.POSTFIX_PNG;
			}
			
			var bitmap:BitmapData = GameBitmapDataManager.getInstance().getSignleBitMapData(url);
			if(bitmap!=null)
			{
				_bitmapData = bitmap;
				show();
				destroyLoader();
			}else
			{
				_urlBitmapDataLoader = new UrlBitmapDataLoader(this);
				_urlBitmapDataLoader.loadBitmap(url);
			}
			/*trace("加载资源："+url);*/
		}
		
		public function setTheName():void
		{
			if(_itemType == SlotType.IT_EQUIP)
			{
				/*var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(id);*/
				var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(_itemId);
				if(!equipCfgData)
				{
					trace("in DropItem.setTheName 不存在id"+_itemId)
					return;
				}
				_entityName = equipCfgData.name;
				_nameColor = ItemType.getColorByQuality(equipCfgData.color);
			}
			else if(_itemType == SlotType.IT_ITEM)
			{
				var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(_itemId);
				if(!itemCfgData)
				{
					trace("in DropItem.setTheName 不存在id"+_itemId)
					return;
				}
				_entityName = itemCfgData.name;
				_nameColor = ItemType.getColorByQuality(itemCfgData.quality);
			}
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			destroyLoader();
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			_bitmapData = bitmapData;
			GameBitmapDataManager.getInstance().addSignleBitMapData(url,bitmapData);
			show();
			destroyLoader();
		}
		
		override public function show():void
		{
			super.show();
			initViewBitmap();
			refreshNameTxtPos();
			refreshBmp();
			refreshShadow();
			doTween();
			updateView(0);
		}
		
		private function doTween():void
		{
			if(this.isNotShowBornEffect==1)return;  //如果不是第一次显示，就 不要播放动画了
			if(!_isTween)
			{
				_isTween = true;
				var theX:int = x,theY:int = y;
				TweenMax.fromTo(this,0.6,{y:theY-MapTileUtils.TILE_HEIGHT*2},{y:theY,ease:RoughEase.create(3, 6, false, Bounce.easeOut, "out", false),onComplete:function ():void
				{
					_isTween = false
				}});
			}
		}
		
		protected override function refreshNameTxtPos():void
		{
			if(_nameTxt)
			{
				_infoLabel.refreshNameTextPos(_nameTxt, 0);
			}
		}
		
		private function refreshBmp():void
		{
			if(_bitmapData)
			{
				_viewBitmap.bitmapData = _bitmapData;
				_viewBitmap.width = 30;
				_viewBitmap.height = 30;
				_viewBitmap.x = -_viewBitmap.width/2;
				_viewBitmap.y = -_viewBitmap.height/2;
			}
		}
		
		private function refreshShadow():void
		{
			if(_bitmapData)
			{
				if (!_shadowBitmapData)
				{
					genShadow();
				}
				_shadow.bitmapData = _shadowBitmapData;
				var skewX:Number = - 0.5;
				var yScale:Number = 0.5;
				var tx:Number = 0;
				var ty:Number = 0;
				var matrix:Matrix = new Matrix(1, 0, skewX, yScale, tx, -skewX * ty);
				_shadow.transform.matrix = matrix;
			}
		}
		
		private function destroyLoader():void
		{
			if(_urlBitmapDataLoader)
			{
				_urlBitmapDataLoader.destroy();
				_urlBitmapDataLoader = null;
			}
		}
		
		private function genShadow():void
		{
			if (_bitmapData)
			{
				_shadowBitmapData = new BitmapData(_bitmapData.width, _bitmapData.height, true, 0x00000000);
				_shadowBitmapData.fillRect(new Rectangle(_viewBitmap.width / 4, _viewBitmap.height / 4, _bitmapData.width / 4, _viewBitmap.height / 2), 0x80000000);
				var bitmapFilter:BlurFilter = new BlurFilter(15, 15);
				_shadowBitmapData.applyFilter(_shadowBitmapData, _shadowBitmapData.rect, new Point(0, 0), bitmapFilter);
			}
		}
		
		public override function get tileDistToReach():int
		{
			return 0;
		}
		
		public override function set y(value:Number):void
		{
			super.y = value;
			resetInfoLabelPos();
		}
		
		override public function destory():void
		{
			if (_bitmapData)
			{
				_bitmapData.dispose();
				_bitmapData = null;
			}
			if (_shadow && _shadow.bitmapData)
			{
				_shadow.bitmapData = null;
			}
			destroyLoader();
			super.destory();
		}
	}
}