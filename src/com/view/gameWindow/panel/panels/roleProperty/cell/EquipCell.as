package com.view.gameWindow.panel.panels.roleProperty.cell
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.NpcShopCfgData;
	import com.model.consts.ConstRoleType;
	import com.model.consts.ConstStorage;
	import com.model.consts.ItemType;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.dungeon.TextFormatManager;
	import com.view.gameWindow.panel.panels.roleProperty.McEquipCell;
	import com.view.gameWindow.panel.panels.roleProperty.otherRole.OtherPlayerDataManager;
	import com.view.gameWindow.tips.toolTip.interfaces.IToolTipClient;
	import com.view.gameWindow.util.NumPic;
	import com.view.gameWindow.util.RectRim;
	import com.view.gameWindow.util.UIEffectLoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;

	/**
	 * 装备格子类
	 * @author Administrator
	 */	
	public class EquipCell extends McEquipCell implements IUrlBitmapDataLoaderReceiver,IToolTipClient
	{
		/**格子所属，使用ConstStorage中的常量*/
		public var storageType:int;
		public var notComplete:Boolean;
		public var npcShopCfgData:NpcShopCfgData;
		public var tipType:int = ToolTipConst.EQUIP_BASE_TIP;
		public var isPolish:Boolean;
		public var roleType:int = 0;
		/**绑定标志是否显示*/
		public var isBindShow:Boolean = true;
		
		private var _urlBitmapDataLoader:UrlBitmapDataLoader;
		private var _bitmap:Bitmap;
		private var _numPicLayer:MovieClip;
		private var _bg:MovieClip;
		private var _onlyId:int;
		private var _bornSid:int;
		private var _slot:int;
		private var _type:int;
		private var _nextStrengthData:Boolean;
		private var _cellEffectLoader:UIEffectLoader;
		private var _cellEffectRect:RectRim;
		private var _urlPic:String = "";
		private var _urlEffect:String = "";
		private var _colorRect:int = 0;
		private var _level:int;
		
		public function EquipCell(bg:MovieClip,slot:int,type:int)
		{
			_bg = bg;
			x = _bg.x;
			y = _bg.y;
			_bg.parent.addChild(this);
			_slot = slot;
			_type = type;
			_numPicLayer = new MovieClip();
			_numPicLayer.mouseChildren = false;
			_numPicLayer.mouseEnabled = false;
			txtNum.mouseEnabled = false;
			TextFormatManager.instance.setTextFormat(txtNum,0xd4a460,false,true);
			addChild(_numPicLayer);
			mcBindSign.visible = false;
			initView();
		}
		/**初始化界面<br>加载图片及SWF资源并刷新界面*/
		private function initView():void
		{
			var rsrLoader:RsrLoader = new RsrLoader();
			rsrLoader.load(this,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
		}
		
		public function set nextStrengthData(value:Boolean):void
		{
			_nextStrengthData = value;
		}

		public function get onlyId():int
		{
			return _onlyId;
		}
		
		public function get bornSid():int
		{
			return _bornSid;
		}
		
		public function refreshData(onlyId:int, bornSid:int):void
		{	
			_onlyId = onlyId;
			_bornSid = bornSid;
			loadPic();
			loadEffect();
			var memEquipData:MemEquipData = roleType == ConstRoleType.ROLE?MemEquipDataManager.instance.memEquipData(_bornSid, _onlyId):OtherPlayerDataManager.instance.memEquipData(_bornSid, _onlyId);
			setChildIndex(txtNum,numChildren-2);
			if(memEquipData && memEquipData.strengthen)
			{
				txtNum.text =  "+" + memEquipData.strengthen;
			}
			else
			{
				txtNum.text = "";
			}
		}
		
		public function copyRefreshData(equipCell:EquipCell):void
		{
			if(_onlyId != equipCell.onlyId || _bornSid != equipCell.bornSid)
			{
				_onlyId = equipCell.onlyId;
				_bornSid = equipCell.bornSid;
				loadPic();
				loadEffect();
			}
		}
		
		public function nextRefreshData(equipCell:EquipCell):void
		{
			if(_onlyId != equipCell.onlyId || _bornSid != equipCell.bornSid)
			{
				_onlyId = equipCell.onlyId;
				_bornSid = equipCell.bornSid;
				_nextStrengthData = true;
				loadPic();
				loadEffect();
			}
		}
		
		private function loadPic():void
		{
			var url:String = getUrlPic();
			if(url != _urlPic)
			{
				_urlPic = url;
				if(_urlPic)
				{
					_urlBitmapDataLoader = new UrlBitmapDataLoader(this);
					_urlBitmapDataLoader.loadBitmap(_urlPic);
				}
			}
		}
		
		private function getUrlPic():String
		{
			var memEquipData:MemEquipData,equipCfgData:EquipCfgData;
			memEquipData = roleType == ConstRoleType.ROLE?MemEquipDataManager.instance.memEquipData(_bornSid, _onlyId):OtherPlayerDataManager.instance.memEquipData(_bornSid, _onlyId);
			if(!memEquipData)
			{
				trace("in EquipCell.loadPic 不存在id"+_onlyId);
				return "";
			}
			
			equipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
			if(!equipCfgData)
			{
				trace("in EquipCell.loadPic 不存在id"+memEquipData.baseId);
				return "";
			}
			var url:String = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD+equipCfgData.icon+ResourcePathConstants.POSTFIX_PNG;
			return url;
		}
		
		private function loadEffect():void
		{
			var memEquipData:MemEquipData,equipCfgData:EquipCfgData;
			memEquipData = roleType == ConstRoleType.ROLE?MemEquipDataManager.instance.memEquipData(_bornSid, _onlyId):OtherPlayerDataManager.instance.memEquipData(_bornSid, _onlyId);
			if(!memEquipData)
			{
				trace("in EquipCell.loadPic 不存在id"+_onlyId);
				return;
			}
			
			equipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
			if(!equipCfgData)
			{
				trace("in EquipCell.loadPic 不存在id"+memEquipData.baseId);
				return;
			}
			var url:String = ItemType.getEffectUrlByQuality(equipCfgData.color);
			if(url != _urlEffect)
			{
				_urlEffect = url;
				destroyEffect();
				if(_urlEffect)
				{
					var theX:int = x + _bg.width/2;
					var theY:int = y + _bg.height/2;
					_cellEffectLoader = new UIEffectLoader(parent as MovieClip,theX,theY,_bg.width/60,_bg.height/60,_urlEffect,function():void{setEffectVisible(visible);});
				}
			}
			var colorRect:int = ItemType.getEffectRectColorByQuality(equipCfgData.color);
			if(colorRect != _colorRect)
			{
				_colorRect = colorRect;
				destoryEffectExtra();
				if(_colorRect)
				{
					_cellEffectRect = new RectRim(_colorRect,_bg.width+2,_bg.height+2,1,.8);
					_cellEffectRect.x = x-1;
					_cellEffectRect.y = y-1;
					_cellEffectRect.visible = visible;
					parent.addChild(_cellEffectRect);
				}
			}
		}
		
		private function refreshBind():void
		{
			if(mcBindSign == null)
			{
				return;
			}
			var memEquipData:MemEquipData = roleType == ConstRoleType.ROLE ? MemEquipDataManager.instance.memEquipData(_bornSid, _onlyId) : OtherPlayerDataManager.instance.memEquipData(_bornSid, _onlyId);
			mcBindSign.visible = isBindShow && visible && !isEmpty() && memEquipData && memEquipData.bind;
			mcBindSign.x != 0 ? mcBindSign.x = 0 : null;
			mcBindSign.y != _bg.height - mcBindSign.height ? mcBindSign.y = _bg.height - mcBindSign.height : null;
			sortBmp();
		}
		
		public function loadPicFromURL(url:String):void
		{
			_urlPic = url;
			_urlBitmapDataLoader = new UrlBitmapDataLoader(this);
			_urlBitmapDataLoader.loadBitmap(url);
		}
				
		public function addLevel(isPolish:Boolean = false):void
		{
			var memEquipData:MemEquipData = roleType == ConstRoleType.ROLE?MemEquipDataManager.instance.memEquipData(_bornSid, _onlyId):OtherPlayerDataManager.instance.memEquipData(_bornSid, _onlyId);
			if(!memEquipData)
			{
				destroyNumPic();
				return;
			}
			var level:int = !isPolish ? memEquipData.strengthen : memEquipData.polish;
			if(_level == level)
			{
				return;
			}
			_level = level;
			//
			if(level <= 0)
			{
				destroyNumPic();
				return;
			}
			setNumPic(level);
		}
		
		public function addNextLevel(isPolish:Boolean = false):void
		{
			var memEquipData:MemEquipData = roleType == ConstRoleType.ROLE?MemEquipDataManager.instance.memEquipData(_bornSid, _onlyId):OtherPlayerDataManager.instance.memEquipData(_bornSid, _onlyId);
			if(!memEquipData)
			{
				destroyNumPic();
				return;
			}
			var level:int = !isPolish ? memEquipData.strengthen : memEquipData.polish;
			if(_level == level+1)
			{
				return;
			}
			_level = level+1;
			//
			var equipCfgData:EquipCfgData =  ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
			if(!equipCfgData)
			{
				destroyNumPic();
				return;
			}
			var isMax:Boolean = !isPolish ? memEquipData.strengthen >= equipCfgData.strengthen : memEquipData.polish >= 9;
			setNumPic(isMax ? _level - 1 : _level);
		}
		
		private function setNumPic(level:int):void
		{
			destroyNumPic();
			if(level)
			{
				var numPic:NumPic = new NumPic();
				numPic.init("strength","+"+level,_numPicLayer,sortBmp);
			}
		}
		
		private function destroyNumPic():void
		{
			while(_numPicLayer.numChildren)
			{
				_numPicLayer.removeChildAt(0);
			}
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			destroyLoader();
			trace("类BagCell方法urlBitmapDataError,加载图片出错："+url);
			if(_bitmap)
			{
				if(_bitmap.parent)
				{
					_bitmap.parent.removeChild(_bitmap);
				}
				if(_bitmap.bitmapData)
				{
					_bitmap.bitmapData.dispose();
				}
				_bitmap = null;
			}
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function getTipType():int
		{
			if(notComplete)
			{
				if(storageType == ConstStorage.ST_HERO_EQUIP)
				{
					return ToolTipConst.EQUIP_BASE_TIP_NO_COMPLETE_HERO;
				}
				else
				{
					return ToolTipConst.EQUIP_BASE_TIP_NO_COMPLETE;
				}
			}
			if(storageType == ConstStorage.ST_HERO_EQUIP)
			{
				return ToolTipConst.EQUIP_BASE_TIP_HERO;
			}
			return tipType;
		}
		
		public function getTipData():Object
		{
			if(tipType == ToolTipConst.EQUIP_BASE_TIP || tipType == ToolTipConst.EQUIP_BASE_TIP_NO_COMPLETE || tipType == ToolTipConst.EQUIP_BASE_TIP_NO_COMPLETE_HERO || tipType == ToolTipConst.EQUIP_BASE_TIP_HERO)
			{
				var memEquipData:MemEquipData = roleType == ConstRoleType.ROLE ? MemEquipDataManager.instance.memEquipData(_bornSid, _onlyId) : OtherPlayerDataManager.instance.memEquipData(_bornSid, _onlyId);
				if(!_nextStrengthData)
				{
					return memEquipData;
				}
				else
				{
					return memEquipData.nextStrengthen(memEquipData,isPolish);
				}
			}
			else if(tipType == ToolTipConst.SHOP_ITEM_TIP)
			{
				return npcShopCfgData;
			}
			else
			{
				return null;
			}
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			if(_urlPic && url != _urlPic)
			{
				return;
			}
			if(_bitmap)
			{
				if(_bitmap.parent)
				{
					_bitmap.parent.removeChild(_bitmap);
				}
				if(_bitmap.bitmapData)
				{
					_bitmap.bitmapData.dispose();
				}
				_bitmap = null;
			}
			_bitmap = new Bitmap(bitmapData,"auto",true);
			_bitmap.width = _bg.width;
			_bitmap.height = _bg.height;
			addChild(_bitmap);
			
		    sortBmp();
			refreshBind();
			_bg.visible = false;
			destroyLoader();
		}
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			if(value)
			{
				if(_bitmap)
				{
					_bg.visible = false;
				}
				else
				{
					_bg.visible = true;
				}
			}
			else
			{
				_bg.visible = false;
			}
			setEffectVisible(visible);
		}
		
		private function setEffectVisible(boolean:Boolean):void
		{
			if(_cellEffectLoader && _cellEffectLoader.effect)
			{
				_cellEffectLoader.effect.visible = boolean;
			}
			if(_cellEffectRect)
			{
				_cellEffectRect.visible = boolean;
			}
		}
		
		public function isEmpty():Boolean
		{
			return _bitmap == null;
		}
		
		public function getBitmap():Bitmap
		{
			if(_bitmap)
			{
				removeChild(_bitmap);
				_onlyId = 0;
			}
			var temp:Bitmap = _bitmap;
			_bitmap = null;
			txtNum.text="";
			_urlPic = "";
			_urlEffect = "";
			_colorRect = 0;
			_bg.visible = true && visible;
			destroyNumPic();
			destroyEffect();
			destoryEffectExtra();
			refreshBind();
			return temp;
		}
		
		public function setBitmap(value:Bitmap, onlyId:int, bornSid:int):void
		{
			if(_onlyId == onlyId && _bornSid == bornSid)
			{
				return;
			}
			_onlyId = onlyId;
			_bornSid = bornSid;
			value.x = 0;
			value.y = 0;
			_bitmap = value;
			_urlPic = getUrlPic();
			addChild(_bitmap);
			loadEffect();
			_bg.visible = false;
			refreshBind();
		}
		
		private function sortBmp():void
		{
			if(!_bitmap)
			{
				return;
			}
			if(mcBindSign && mcBindSign.parent && getChildIndex(mcBindSign) < getChildIndex(_bitmap))
			{
				swapChildren(mcBindSign,_bitmap);
			}
			if(this.contains(_numPicLayer)&&getChildIndex(_numPicLayer) < getChildIndex(_bitmap))
			{
				swapChildren(_numPicLayer,_bitmap);
			}
		}
		
		private function destroyLoader():void
		{
			if(_urlBitmapDataLoader)
				_urlBitmapDataLoader.destroy();
			_urlBitmapDataLoader = null;
		}
		
		public function setNull():void
		{
			destroyEffect();
			destoryEffectExtra();
			if(_bitmap)
			{
				removeChild(_bitmap);
				_bitmap.bitmapData.dispose();
				_bitmap = null;
			}
			destroyNumPic();
			refreshBind();
			_level = 0;
			_urlPic = "";
			_bg.visible = true && visible;
			_onlyId = 0;
		}
		
		private function destroyEffect():void
		{
			if(_cellEffectLoader)
			{
				_cellEffectLoader.destroy();
				_cellEffectLoader = null;
				_urlEffect = "";
			}
		}
		
		private function destoryEffectExtra():void
		{
			if(_cellEffectRect && _cellEffectRect.parent)
			{
				_cellEffectRect.parent.removeChild(_cellEffectRect);
				_cellEffectRect = null;
				_colorRect = 0;
			}
		}
		
		public function destory():void
		{
			setNull();
			destroyLoader();
			_type = 0;
			roleType = 0;
			_slot = 0;
			
			if (_bg && _bg.parent)
			{
				_bg.parent.removeChild(this);
				_bg = null;
			}
		}

		public function set slot(value:int):void
		{
			_slot = value;
		}
		
		public function get slot():int
		{
			return _slot;
		}

		public function get type():int
		{
			return _type;
		}
		
		public function getTipCount():int
		{
			// TODO Auto Generated method stub
			return 1;
		}
		
	}
}