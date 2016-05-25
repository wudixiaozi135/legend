package com.view.gameWindow.panel.panels.bag.cell
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.ItemTypeCfgData;
	import com.model.consts.ConstStorage;
	import com.model.consts.EffectConst;
	import com.model.consts.ItemType;
	import com.model.consts.SlotType;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.common.ResManager;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.bag.DrugCDData;
	import com.view.gameWindow.panel.panels.bag.McBagCell;
	import com.view.gameWindow.panel.panels.dungeon.TextFormatManager;
	import com.view.gameWindow.panel.panels.expStone.ExpStoneData;
	import com.view.gameWindow.panel.panels.expStone.ExpStoneDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.panel.panels.trade.TradeDataManager;
	import com.view.gameWindow.tips.toolTip.interfaces.IToolTipClient;
	import com.view.gameWindow.util.ObjectUtils;
	import com.view.gameWindow.util.RectRim;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.gameWindow.util.cooldown.CoolDownEffect;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.utils.getTimer;

	/**
	 * 背包单元格类
	 * @author Administrator
	 */
	public class BagCell extends McBagCell implements IUrlBitmapDataLoaderReceiver,IToolTipClient
	{
		public var cellId:int;
		/**格子所属，使用ConstStorage中的常量*/
		public var storageType:int;
		
		private const cellW:int = 36;
		private const cellH:int = 36;
		private var _urlBitmapDataLoader:UrlBitmapDataLoader;
		private var _id:int = -1;
		private var _bornSid:int = -1;
		private var _type:int = -1;
		private var _isHide:int = -1;//背包物品显示属性 0正常 1隐藏 2变灰
        private var _isBind:int = -1;
		private var _bitmap:Bitmap;
		private var _bagData:BagData;
		private var _cellEffectLoader:UIEffectLoader;
		private var _cellEffectRect:RectRim;
		public var isClick:Boolean = false;
		
		public var _isHeroBagCell:Boolean = false;
		
		private var _coolDownEffect:CoolDownEffect;
		
		/**交易里的类型和默认背包里的类型*/
		public var bagType:int = 0;

		public function get bmp():Bitmap
		{
			return _bitmap;
		}
		
		/**
		 * 构造后<br>
		 * 必须调用initView方法，加载界面资源<br>
		 * 必须调用refreshLockState方法设置锁图标是否显示<br>
		 * 若需要设置storageType变量值，使用ConstStorage类中的常量<br>
		 * 若需要设置cellId变量值，表示格子在包裹中的位置
		 */
		public function BagCell()
		{
			super();
			txtNum.mouseEnabled = false;
			mcIcon.mouseEnabled = false;
			mcBindSign.mouseEnabled = false;
			mcBindSign.visible = false;
		 
			doubleClickEnabled = true;
			mouseChildren = false;
			arrow.visible = false;
			arrow.mouseEnabled = false;
			
			mcRedSign.visible=false;
			mcYellowSign.visible=false;
			_coolDownEffect = new CoolDownEffect();
		}
		
		/**初始化界面<br>加载图片及SWF资源并刷新界面*/
		public function initView():void
		{
			/*var rsrLoader:RsrLoader = new RsrLoader();
			rsrLoader.load(this, ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);*/
			var view:BagCell = this;
			ResManager.getInstance().loopLoadBitmap(view,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD,function(bitmapData:BitmapData,url:String):void
			{
				var mc:MovieClip = ResManager.getInstance().mcByUrl(view,url);
				if(!mc)
				{
					return;
				}
				var bitmap:Bitmap = new Bitmap(bitmapData,"auto",true);
				bitmap.width = mc.width;
				bitmap.height = mc.height;
				mc.scaleX = 1;
				mc.scaleY = 1;
				mc.addChild(bitmap);
				mc.removeChildAt(0);
				mc.mouseEnabled = false;
			});
		}
		
		public function refreshLockState(isLock:Boolean):void
		{
			if (isLock)
			{
				mcIcon.visible = false;
				txtNum.visible = false;
				mcLock.visible = true;
			}
			else
			{
				mcIcon.visible = true;
				txtNum.visible = true;
				mcLock.visible = false;
			}
		}
		
		public function refreshData(bagData:BagData):void
		{
			if (isLock)
			{
				return;
			}
			_coolDownEffect.stop();
			_bagData = bagData;
            if (_id != bagData.id || _type != bagData.type || _bornSid != bagData.bornSid || _isHide != bagData.isHide || _isBind != bagData.bind)
			{
				_id = bagData.id;
				_bornSid = bagData.bornSid;
				_type = bagData.type;
				_isHide = bagData.isHide;
                _isBind = bagData.bind;
				if (bagData.isHide != 1)
				{
                    bindSginVisible(Boolean(_isBind));
					loadPic();
					var isLoading:Boolean = true;
					destroyEffect();
					loadEffect();
				}
				else//交易物品状态
				{
					setNull();
				}
			}
			if(ConfigDataManager.instance.itemCfgData(_id) 
				&& (ConfigDataManager.instance.itemCfgData(_id).type == ItemType.EXP_STONE || ConfigDataManager.instance.itemCfgData(_id).type == ItemType.EXP_STONE_A))
			{
				if (bagData.isHide != 1)
				{
					loadEffect();
				}
			}
			if (bagData.type == SlotType.IT_ITEM)
			{
				TextFormatManager.instance.setTextFormat(txtNum, 0xffffff, false, false);
				if (bagData.count == 1)
				{
					txtNum.text = "";
				}
				else
				{
					if (bagData.isHide != 1)
					{
						txtNum.text = bagData.count + "";
					}
					else
					{
						txtNum.text = "";
					}
				}
				arrow.visible = false;
				if(!isLoading)
				{
					showCd();
				}
			}
			else if (bagData.type == SlotType.IT_EQUIP)
			{
				TextFormatManager.instance.setTextFormat(txtNum, 0xd4a460, false, true);
				if (!bagData.memEquipData || (bagData.memEquipData && bagData.memEquipData.strengthen == 0))
				{
					txtNum.text = "";
				}
				else
				{
					if (bagData.isHide != 1)
					{
						txtNum.visible=true;
						txtNum.text = "+" + bagData.memEquipData.strengthen + "";
					}
					else
					{
						txtNum.text = "";
					}
				}
				var fightHigher:Boolean;
				if(_isHeroBagCell)
				{
					fightHigher = BagDataManager.instance.isBagHeroFightPowerHigher(bagData);
				}
				else
				{
					fightHigher= BagDataManager.instance.isBagFightPowerHigher(bagData);
				}
				if (fightHigher)
				{
					if (bagData.isHide != 1)
					{
						arrow.visible = true;
					}
					else
					{
						arrow.visible = false;
					}
				}
				else
				{
					arrow.visible = false;
				}

                if (_isHide != 1)
                {
                    var checkEquipMatch:int = BagDataManager.instance.showRedOrYellowSign(bagData);//1红 2黄
                    if (checkEquipMatch == 1)//红标
                    {
                        mcRedSign.visible = true;
                        mcBindSign.visible = false;
                    } else if (checkEquipMatch == 2)//黄标
                    {
                        mcYellowSign.visible = true;
                        mcBindSign.visible = false;
                    } else
                    {//其他
                        bindSginVisible(Boolean(bagData.bind));
                    }
                }
			}
		}
		
		protected function bindSginVisible(value:Boolean):void
		{
			if (isLock)
			{
				if (mcBindSign.visible)
				{
					mcBindSign.visible = false;
				}
				return;
			}
            mcRedSign.visible = false;//有绑定在 红标和黄标都不显示
            mcYellowSign.visible = false;

			mcBindSign.visible = value;
		}
		
		public function getTipType():int
		{
			if(!_isHeroBagCell)
			{
				return _type == SlotType.IT_EQUIP ? ToolTipConst.EQUIP_BASE_TIP : ToolTipConst.ITEM_BASE_TIP;
			}
			else
			{
				return _type == SlotType.IT_EQUIP ? ToolTipConst.EQUIP_BASE_TIP_HERO : ToolTipConst.ITEM_BASE_TIP;
			}
		}
		
		public function getTipData():Object
		{
			if (_bagData == null)
			{
				return null;
			}
			if (_bagData.isHide == 1)
			{
				return null;//为隐藏物品不显示tips
			}
			if (_type == SlotType.IT_EQUIP)
			{
				if (bagType == BagCellType.TradeCellType)
				{
					return TradeDataManager.instance.getOthermemEquipData(_bornSid, _id);
				}
				if(storageType == ConstStorage.ST_SCHOOL_BAG) 
				{
					return SchoolElseDataManager.getInstance().getMemEquipData(_bornSid, _id);
				}
				return MemEquipDataManager.instance.memEquipData(_bornSid, _id);
			}
			else
			{
				if (storageType == ConstStorage.ST_CHR_BAG)
				{
					return _bagData;
					/*BagDataManager.instance.getBagCellDataByIdType(_id, SlotType.IT_ITEM, _bornSid);*/
				}
				else
				{
					return _bagData;// HeroDataManager.instance.getBagCellDataByIdType(_id,SlotType.IT_ITEM,_bornSid);
				}
			}
		}
		
		protected function loadPic():void
		{
			var url:String;
			if (_type == SlotType.IT_EQUIP)
			{
				var memEquipData:MemEquipData;
				if (bagType == BagCellType.TradeCellType)
				{
					memEquipData = TradeDataManager.instance.getOthermemEquipData(_bornSid, _id);
				}else if(storageType == ConstStorage.ST_SCHOOL_BAG) 
				{
					memEquipData=SchoolElseDataManager.getInstance().getMemEquipData(_bornSid, _id);
				}
				else
				{
					memEquipData = MemEquipDataManager.instance.memEquipData(_bornSid, _id);
				}
				if (!memEquipData)
				{
					trace("in BagCell.loadPic 不存在id" + _id);
					return;
				}
				var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
				if (!equipCfgData)
				{
					trace("in BagCell.loadPic 不存在id" + memEquipData.baseId);
					return;
				}
				url = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD + equipCfgData.icon + ResourcePathConstants.POSTFIX_PNG;
			}
			else if (_type == SlotType.IT_ITEM)
			{
				var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(_id);
				if (!itemCfgData)
				{
					trace("in BagCell.loadPic 不存在id" + _id);
					return;
				}
				url = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD + itemCfgData.icon + ResourcePathConstants.POSTFIX_PNG;
			}
			if(url=="")return;
			
			if(_urlBitmapDataLoader)
			{
				destroyLoader();
			}
			
			_urlBitmapDataLoader = new UrlBitmapDataLoader(this);
			_urlBitmapDataLoader.loadBitmap(url, null, true);
		}
		
		public function loadEffect():void
		{
//			destroyEffect();
			
			if(_cellEffectRect && _cellEffectRect.parent)
			{
				_cellEffectRect.parent.removeChild(_cellEffectRect);
				_cellEffectRect = null;
			}

            var url:String, colorRect:int, itemCfgData:ItemCfgData;
			if (_type == SlotType.IT_EQUIP)
			{
				var memEquipData:MemEquipData;
				if (bagType == BagCellType.TradeCellType)
				{
					memEquipData = TradeDataManager.instance.getOthermemEquipData(_bornSid, _id);
				} 
				else
				{
					memEquipData = MemEquipDataManager.instance.memEquipData(_bornSid, _id);
				}
				if (!memEquipData)
				{
					trace("in BagCell.loadPic 不存在id" + _id);
					return;
				}
				var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
				if (!equipCfgData)
				{
					trace("in BagCell.loadPic 不存在id" + memEquipData.baseId);
					return;
				}
				url = ItemType.getEffectUrlByQuality(equipCfgData.color);
				colorRect = ItemType.getEffectRectColorByQuality(equipCfgData.color);
			}
			else if (_type == SlotType.IT_ITEM)
			{
                itemCfgData = ConfigDataManager.instance.itemCfgData(_id);
				var expStoneData:ExpStoneData;
				if (!itemCfgData)
				{
					trace("in BagCell.loadPic 不存在id" + _id);
					return;
				}
				url = ItemType.getEffectUrlByQuality(itemCfgData.quality);
				colorRect = ItemType.getEffectRectColorByQuality(itemCfgData.quality);
				if(itemCfgData.type == ItemType.EXP_STONE||itemCfgData.type==ItemType.EXP_STONE_A)
				{
					if(_bagData)
					{
						expStoneData = ExpStoneDataManager.instance.getExpInfo(_bagData.storageType,_bagData.slot);
						if(expStoneData && expStoneData.exp >= expStoneData.maxExp)
						{
                            url = EffectConst.RES_STONE_GREEN;
							colorRect = 0;
						}
					}
				}
			}
			
			if(!_cellEffectLoader && url)
			{
				var theX:int = x + width / 2;
				var theY:int = y + height / 2;
                if (_type == SlotType.IT_ITEM)
                {
                    itemCfgData = ConfigDataManager.instance.itemCfgData(_id);
                }
                if (itemCfgData && (itemCfgData.type == ItemType.EXP_STONE || itemCfgData.type == ItemType.EXP_STONE_A))
                {
                    _cellEffectLoader = new UIEffectLoader(parent as MovieClip, theX, theY, 1, 1, url);
                }
				else
                {
                    _cellEffectLoader = new UIEffectLoader(parent as MovieClip, theX, theY, cellW / 60, cellH / 60, url);
                }
			}
			else if(_cellEffectLoader)
			{
				if(!url)
				{
					_cellEffectLoader.destroy();
					_cellEffectLoader = null;
				}
				else
				{
					_cellEffectLoader.url = url;
				}
			}
			
			if(colorRect && parent)
			{
				_cellEffectRect = new RectRim(colorRect,cellW+2,cellH+2,1,.8);
				_cellEffectRect.x = x + (width - (cellW+2)) * .5;
				_cellEffectRect.y = y + (height - (cellH+2)) * .5;
				parent.addChild(_cellEffectRect);
			}
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			trace("类BagCell方法urlBitmapDataError,加载图片出错：" + url);
			if (_bitmap)
			{
				if (_bitmap.parent)
				{
					_bitmap.parent.removeChild(_bitmap);
				}
				if (_bitmap.bitmapData)
				{
					_bitmap.bitmapData.dispose();
				}
				_bitmap = null;
			}
			destroyLoader();
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			if (_bitmap)
			{
				if (_bitmap.parent)
				{
					_bitmap.parent.removeChild(_bitmap);
				}
				_bitmap.bitmapData.dispose();
				_bitmap = null;
			}
			_bitmap = new Bitmap(bitmapData, "auto", true);
			_bitmap.width = cellW;
			_bitmap.height = cellH;
			mcIcon.addChild(_bitmap);
			if (bagData)
			{
				if (bagData.isHide == 2)
				{
					ObjectUtils.gray(this);
					this.mouseEnabled = false;
				}
				else
				{
					ObjectUtils.gray(this, false);
					this.mouseEnabled = true;
				}
				
				if(_isHeroBagCell)
				{
					if (HeroDataManager.instance.isBagFightPowerHigher(bagData))
					{
						arrow.visible = true;
					}
					else
					{
						arrow.visible = false;
					}
				}
				else
				{
					if (BagDataManager.instance.isBagFightPowerHigher(bagData))
					{
						arrow.visible = true;
					}
					else
					{
						arrow.visible = false;
					}
				}
			}
			destroyLoader();
			showCd();
		}
		
		private function showCd():void
		{
			if (!bagData) return;
			if(bagData.type != SlotType.IT_ITEM)
			{
				return;
			}
			var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(bagData.id);
			var item:ItemTypeCfgData = ConfigDataManager.instance.itemTypeCfgData(itemCfgData.type);
			if(item&&item.type == ItemType.ITEM_TYPE_DRUG)
			{
				var cd:Array = DrugCDData.drugCDChr(storageType);
				var timer:int = getTimer();
				if(!cd[item.id])
				{
					return;
				}
				/*if(storageType == ConstStorage.ST_HERO_BAG)
				{
					trace(timer+"开始刷新cd~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
				}*/
				var skillCDAfter:int = timer - cd[item.id];
				var checkSkillCd:Boolean = (cd[item.id]+item.cd<=timer);
				var initAngle:Number = -90; 
				var durationAngle:Number = 360;
				var duration:int = 0;
				duration = (!checkSkillCd && (item.cd > skillCDAfter)) ? (item.cd - skillCDAfter) : 0;
				initAngle = initAngle + durationAngle * (1 - duration / item.cd);
				durationAngle = durationAngle * duration / item.cd;
				_coolDownEffect.stop();
				if(duration)
				{
					_coolDownEffect.play(_bitmap,duration,initAngle,durationAngle);
				}	
			}
		}
		
		public function get isLock():Boolean
		{
			return mcLock.visible;
		}
		
		public function isEmpty():Boolean
		{
			return _bitmap == null;
		}
		
		public function getBitmap():Bitmap
		{
			if (_bitmap)
			{
				mcIcon.removeChild(_bitmap);
				txtNum.visible=false;
				arrow.visible = false;
				_id = 0;
				_type = 0;
				mcBindSign.visible = false;
				mcRedSign.visible=false;
				mcYellowSign.visible=false;
			}
			_bagData = null;
			var temp:Bitmap = _bitmap;
			_bitmap = null;
			destroyEffect();
			_coolDownEffect.stop();
			return temp;
		}
		/**拖动道具，放开时设置数据*/
        public function setBitmap(value:Bitmap, bagData:BagData):void
		{
			if (isLock) return;
			if (!bagData) return;
            if (_id != bagData.id || _bornSid != bagData.bornSid || _type != bagData.type || _isHide != bagData.isHide || _isBind != bagData.bind)
			{
				_bagData = bagData;
				_coolDownEffect.stop();
				_id = bagData.id;
				_bornSid = bagData.bornSid;
				_type = bagData.type;
                _isHide = bagData.isHide;
                _isBind = bagData.bind;
				bindSginVisible(Boolean(bagData.bind));
				value.x = 0;
				value.y = 0;
				_bitmap = value;
				mcIcon.addChild(_bitmap);
				destroyEffect();
				loadEffect();
			}
			if (bagData.type == SlotType.IT_ITEM)
			{
				TextFormatManager.instance.setTextFormat(txtNum, 0xffffff, false, false);
				if (bagData.count == 1)
				{
					txtNum.text = "";
				}
				else
				{
					txtNum.text = bagData.count + "";
                    if (txtNum.visible == false)
                        txtNum.visible = true;
				}
				showCd();
			}
			else if (bagData.type == SlotType.IT_EQUIP)
			{
				TextFormatManager.instance.setTextFormat(txtNum, 0xd4a460, false, true);
				if (!bagData.memEquipData || (bagData.memEquipData && bagData.memEquipData.strengthen == 0))
				{
					txtNum.text = "";
				}
				else
				{
					txtNum.visible=true;
					txtNum.text = "+" + bagData.memEquipData.strengthen + "";
				}
				if (BagDataManager.instance.isBagFightPowerHigher(bagData))
				{
					arrow.visible = true;
				}

                if (_isHide != 1)
                {
                    var checkEquipMatch:int = BagDataManager.instance.showRedOrYellowSign(bagData);//1红 2黄
                    if (checkEquipMatch == 1)//红标
                    {
                        mcRedSign.visible = true;
                        mcBindSign.visible = false;
                    } else if (checkEquipMatch == 2)//黄标
                    {
                        mcYellowSign.visible = true;
                        mcBindSign.visible = false;
                    } else
                    {//其他
                        bindSginVisible(Boolean(bagData.bind));
                    }
                }
			}
		}
		
		public function setNull():void
		{
			destroyLoader();
			destroyEffect();
			if (_bitmap)
			{
				mcIcon.removeChild(_bitmap);
				_bitmap.bitmapData.dispose();
				_bitmap = null;
			}
			mcBindSign.visible = false;
			arrow.visible = false;
			isClick = false;
			_bagData = null;
			txtNum.text = "";
			mcRedSign.visible=false;
			mcYellowSign.visible=false;
			_coolDownEffect.stop();
			_id = 0;
			_type = 0;
//            _isHide = -1;
		}
		
		protected function destroyEffect():void
		{
			if (_cellEffectLoader)
			{
				_cellEffectLoader.destroy();
				_cellEffectLoader = null;
			}
			if(_cellEffectRect && _cellEffectRect.parent)
			{
				_cellEffectRect.parent.removeChild(_cellEffectRect);
				_cellEffectRect = null;
			}
		}
		
		protected function destroyLoader():void
		{
			if (_urlBitmapDataLoader)
				_urlBitmapDataLoader.destroy();
			_urlBitmapDataLoader = null;
		}
		
		public function destory():void
		{
			setNull();
			destroyLoader();
			_coolDownEffect&&_coolDownEffect.stop();
			_coolDownEffect = null;
		}
		
		public function get id():int
		{
			return _id;
		}
		/**使用SlotType中的值*/
		public function get type():int
		{
			return _type;
		}
		/**来源服务器id*/
		public function get bornSid():int
		{
			return _bornSid;
		}
		
		public function get bagData():BagData
		{
			return _bagData;
		}
		
		public function getTipCount():int
		{
			return 1;
		}
	}
}