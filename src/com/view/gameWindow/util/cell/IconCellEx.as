package com.view.gameWindow.util.cell
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.configData.cfgdata.ItemCfgData;
    import com.model.configData.cfgdata.SkillCfgData;
    import com.model.consts.FontFamily;
    import com.model.consts.ItemType;
    import com.model.consts.SlotType;
    import com.model.consts.ToolTipConst;
    import com.view.gameWindow.common.ResManager;
    import com.view.gameWindow.panel.panels.bag.BagData;
    import com.view.gameWindow.util.ObjectUtils;
    import com.view.gameWindow.util.UIEffectLoader;
    import com.view.gameWindow.util.UtilNumChange;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.filters.GlowFilter;
    import flash.text.TextField;
    import flash.text.TextFormat;

    import flashx.textLayout.formats.TextAlign;

    /**
	 * @author wqhk
	 * 2014-8-27
	 */
	public class IconCellEx extends IconCell
	{
		public static function setItem(icon:IconCellEx, type:int, id:int, num:int, needNumAlways:Boolean = false):void
		{
			var nc:UtilNumChange = new UtilNumChange();
			if (type == SlotType.IT_ITEM)
			{
				var itemCfg:ItemCfgData = ConfigDataManager.instance.itemCfgData(id);
				icon.url = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD + itemCfg.icon + ResourcePathConstants.POSTFIX_PNG;
				icon.setTipType(ToolTipConst.ITEM_BASE_TIP);
				icon.setTipData(itemCfg);
				icon.setTipCount(num);
				icon.id = id;
				if (!needNumAlways)
				{
					icon.text = "";
				}
				else
				{
					var isItemNumShow:Boolean = ItemType.isItemNumShow(id);
					if(isItemNumShow)
					{
						icon.text = "×" + nc.changeNum(num);
					}
				}
			}
			else if (type == SlotType.IT_EQUIP)
			{
				var equipCfg:EquipCfgData = ConfigDataManager.instance.equipCfgData(id);
				icon.url = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD + equipCfg.icon + ResourcePathConstants.POSTFIX_PNG;
				icon.setTipType(ToolTipConst.EQUIP_BASE_TIP);
				icon.setTipData(equipCfg);
				icon.text = "×" + nc.changeNum(num);
				icon.id = id;
			}
		}

		public static function setItemByThingsData(icon:IconCellEx, dt:ThingsData):void
		{
			
			var preUrl:String, typeTip:int;
			if (dt.type == SlotType.IT_ITEM)
			{
				preUrl = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD;
				typeTip = ToolTipConst.ITEM_BASE_TIP;
			}
			else if (dt.type == SlotType.IT_EQUIP)
			{
				preUrl = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD;
				typeTip = ToolTipConst.EQUIP_BASE_TIP;
			}
			icon.url = preUrl + dt.cfgData.icon + ResourcePathConstants.POSTFIX_PNG;
			icon.id = dt.id;
			icon.slot = dt.slot;
			icon.type = dt.type;
			icon.storageType = dt.storageType;
			icon.lock = dt.bind;
			var effectUrl:String = ItemType.getEffectUrlByQuality(dt.cfgData.quality);
			icon.loadEffect(effectUrl);
			icon.setTipType(typeTip);
			icon.setTipData(dt.cfgData);
			icon.setTipCount(dt.count);
			icon.setLock(dt.bind);
			if (dt.count)
			{
				var nc:UtilNumChange = new UtilNumChange();
				if (dt.type == SlotType.IT_ITEM)
				{
					var isItemNumShow:Boolean = ItemType.isItemNumShow(dt.id);
					if (!isItemNumShow)
					{
						icon.text = "";
						return;
					}
				}
				icon.text = nc.changeNum(dt.count);
			}
		}

		/**按装备tips显示*/
		public static function setEquipMemByBagData(icon:IconCellEx, dt:BagData):void
		{
			var preUrl:String, typeTip:int;
			preUrl = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD;
			typeTip = ToolTipConst.EQUIP_BASE_TIP;
			icon.url = preUrl + dt.memEquipData.equipCfgData.icon + ResourcePathConstants.POSTFIX_PNG;

			icon.id = dt.memEquipData.equipCfgData.id;
			icon.slot = dt.slot;
			icon.storageType = dt.storageType;
			icon.lock = dt.bind;
			var effectUrl:String = ItemType.getEffectUrlByQuality(dt.memEquipData.equipCfgData.quality);
			icon.loadEffect(effectUrl);
			icon.setTipType(typeTip);
			icon.setTipData(dt.memEquipData);
//			icon.setTipCount(dt.count);
			icon.setLock(dt.bind);
			icon.text = "";
//			if (dt.count)
//			{
//				var nc:UtilNumChange = new UtilNumChange();
//				icon.text = nc.changeNum(dt.count);
//			}
		}

		public static function setItemBySkill(icon:IconCellEx, skillCfg:SkillCfgData):void
		{
			if (skillCfg)
			{
				icon.url = ResourcePathConstants.IMAGE_ICON_SKILL_FOLDER_LOAD + skillCfg.icon + ResourcePathConstants.POSTFIX_PNG;
				icon.setTipType(ToolTipConst.SKILL_TIP);
				icon.setTipData(skillCfg);
				icon.text = "";
			}
			else
			{
				icon.url = null;
				icon.setTipType(0);
				icon.setTipData(null);
				icon.text = "";
			}
		}

		public function IconCellEx(layer:DisplayObjectContainer, x:int, y:int, w:int, h:int, layerIndex:int = -1)
		{
			super(layer, x, y, w, h, layerIndex);

			_text = new TextField();
			_text.selectable = false;
			_text.mouseEnabled = false;
            _text.defaultTextFormat = new TextFormat(FontFamily.FONT_NAME, 12, 0xffffff, null, null, null, null, null, TextAlign.RIGHT);
			_text.width = w;
			_text.height = 18;
			_text.y = h - _text.height + 3;
			_text.filters = [new GlowFilter(0x0, 1, 2, 2, 100)];
			addChild(_text);
			addChild(_lockContainer = new Sprite());
			_lockContainer.mouseEnabled = false;
			_lockContainer.mouseChildren = false;
		}

        public var receiveCallBack:Function;//资源加载完成回调
		public var id:int;
		public var slot:int;
		public var type:int;  //
		public var storageType:int;
		public var lock:int;
		private var _tipData:Object;//0非绑定 1 绑定
		private var _tipType:int;
		private var _cellEffectLoader:UIEffectLoader;
		private var _cellEffectLoader2:UIEffectLoader;
		private var _lockContainer:Sprite;
		private var _tipCount:int;

		private var _url:String;
		public function set url(value:String):void
		{
			if (_url != value)
			{
				destroyBmp();
				destroyLoader();

				_url = value;
				if (!_url)
				{
					text = "";
				}
				else
				{
					loadPic(value);
				}
			}
		}

		private var _text:TextField;
		
		

		public function setTipCount(tipCount:int):void
		{
			_tipCount = tipCount;
		}
		
		public function set text(value:String):void
		{
			if(_text != null)
			{
				_text.text = value != "1" ? value : "";	
			}
		}
		
		public function set htmlText(value:String):void
		{
			if(_text != null)
			{
				_text.htmlText = value;
			}
		}

		override public function destroy():void
		{
			setNull();
			if(_text != null)
			{
				_text.parent&&_text.parent.removeChild(_text);
				_text.filters=null;
				_text=null;
			}
            if (receiveCallBack != null)
            {
                receiveCallBack = null;
            }
			super.destroy();
		}

		override public function getTipData():Object
		{
			return _tipData;
		}

		override public function getTipType():int
		{
			return _tipType;
		}

		public function setLock(lock:int):void
		{
			if (lock)
			{
				ResManager.getInstance().loadBitmap(ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD + "bagPanel/bindSign.jpg", function (bmd:BitmapData,url:String):void
				{
					_lockContainer.addChild(new Bitmap(bmd));
					_lockContainer.y = height - _lockContainer.height - 5;
				});
			} else
			{
				if (_lockContainer && _lockContainer.numChildren)
				{
					ObjectUtils.clearAllChild(_lockContainer);
				}
			}
		}

		public function setNull():void
		{
			url = "";
			id = 0;
			_tipData = null;
			_tipType = ToolTipConst.NONE_TIP;
			destroyEffect();
		}

		public function loadEffect(value:String):void
		{
			destroyEffect();
			if (!_cellEffectLoader)
			{
				var theX:int = x + _w / 2;
				var theY:int = y + _h / 2;
				_cellEffectLoader = new UIEffectLoader(parent as MovieClip, theX, theY, _w / 60, _h / 60);
			}
			_cellEffectLoader.url = value;
		}
		
		 
		public function loadEffect2(value:String):void
		{
			destroyEffect2();
			if (!_cellEffectLoader2)
			{
				var theX:int = x + _w / 2;
				var theY:int = y + _h / 2;
				_cellEffectLoader2 = new UIEffectLoader(this, theX, theY);
			}
			_cellEffectLoader2.load2(value);
		}

        override public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
        {
            super.urlBitmapDataReceive(url, bitmapData, info);
            if (receiveCallBack != null)
            {
                if (receiveCallBack.length == 1)
                {
                    receiveCallBack(bitmapData);
                } else if (receiveCallBack.length == 0)
                {
                    receiveCallBack();
                }
            }
        }

        public function setTipData(tipData:Object):void
		{
			_tipData = tipData
		}

		public function setTipType(type:int):void
		{
			_tipType = type;
		}

		private function destroyEffect():void
		{
			if (_cellEffectLoader)
			{
				_cellEffectLoader.destroy();
				_cellEffectLoader = null;
			}
			
		}
		private function destroyEffect2():void
		{
			if (_cellEffectLoader2)
			{
				_cellEffectLoader2.destroy();
				_cellEffectLoader2 = null;
			}
			
		}
		override public function getTipCount():int
		{
			return _tipCount;
		}
		
	}
}