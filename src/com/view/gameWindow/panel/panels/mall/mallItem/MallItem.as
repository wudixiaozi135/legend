package com.view.gameWindow.panel.panels.mall.mallItem
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.GameShopCfgData;
    import com.model.configData.cfgdata.ItemCfgData;
    import com.model.consts.ItemType;
    import com.model.consts.SlotType;
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.HighlightEffectManager;
    import com.view.gameWindow.common.MoveAroundAnim;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.guideSystem.view.GuideArrow2;
    import com.view.gameWindow.panel.panels.mall.McMallItem;
    import com.view.gameWindow.panel.panels.mall.constant.ResIconType;
    import com.view.gameWindow.panel.panels.mall.mallbuy.data.MallBuyData;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.ObjectUtils;
    import com.view.gameWindow.util.cell.IconCellEx;
    import com.view.gameWindow.util.cell.ThingsData;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    /**
	 * Created by Administrator on 2014/11/19.
	 */
	public class MallItem extends MallItemBase
	{
		public function MallItem()
		{
			mouseEnabled = false;
			_skin = new McMallItem();
			_skin.mouseEnabled = false;
			var mc:McMallItem = _skin as McMallItem;
			mc.iconContainer.mouseEnabled = false;

			addChild(_skin);
			initTxt();
			initView();
			_skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			_hl = new HighlightEffectManager();
		}

		private var _itemCfg:ItemCfgData;
		private var _dt:ThingsData;
		private var _cellEx:IconCellEx;

		private var _data:GameShopCfgData;
		private var _hl:HighlightEffectManager;
		private var _hightLight:Boolean = false;
		private var _arrow:GuideArrow2;
		private var _aroundAnim:MoveAroundAnim;
		private var _isBuyBtnInited:Boolean = false;
		private var _isBagInited:Boolean = false;
		
		public function get hightLight():Boolean
		{
			return _hightLight;
		}


        override public function get width():Number
        {
            return _skin.bg.width;
        }


        override public function get height():Number
        {
            return _skin.bg.height;
        }

        public function set hightLight(value:Boolean):void
		{
			if(_hightLight != value)
			{
				_hightLight = value;
				checkHightLight();
			}
		}
		
		private function checkHightLight():void
		{
			if(_isBuyBtnInited && _isBagInited)
			{
				if(_hightLight)
				{
					_hl.show(this,skin.btnBuy);
					if(!_arrow)
					{
						_arrow = new GuideArrow2();
						_arrow.rotation = 270;
						_arrow.label = StringConst.MALL_BUY_BOOK_TIP;
					}
					
					if(this.parent)
					{
						var rect:Rectangle = skin.btnBuy.getBounds(this.parent);
						_arrow.x = rect.x + rect.width/2;
						_arrow.y = rect.y + rect.height;
						this.parent.addChild(_arrow);
						
						//按要求先去掉
//						if(!_aroundAnim)
//						{
//							var list:Array = [];
//							var radius:Array = [3,2,2,2,2,1,1,1,0,0,0,0];
//							for(var i:int = 0; i < 48; ++i)
//							{
//								var star:CrossStar = new CrossStar(radius[i%12]);
//								list.push(star);
//							}
//							_aroundAnim = new MoveAroundAnim(this,new Point(0,0),this.parent,list,10,400);
//						}
					}
				}
				else
				{
					_hl.hide(skin.btnBuy);
					
					if(_arrow && _arrow.parent)
					{
						_arrow.destroy();
						_arrow.parent.removeChild(_arrow);
						_arrow = null;
					}
					
//					if(_aroundAnim)
//					{
//						_aroundAnim.destroy();
//						_aroundAnim = null;
//					}
				}
			}
		}

		public function get data():GameShopCfgData
		{
			return _data;
		}

		public function set data(value:GameShopCfgData):void
		{
			_data = value;
			if (_data)
			{
				var mc:McMallItem = _skin as McMallItem;
				_itemCfg = ConfigDataManager.instance.itemCfgData(_data.item_id);
				mc.txtCost.text = _data.cost_value.toString();
				mc.txtOriginal.htmlText = "<a>" + _data.original_cost.toString() + "</a>";
				if (_itemCfg)
				{
                    mc.txtName.textColor = ItemType.getColorByQuality(_itemCfg.quality);
					mc.txtName.text = _itemCfg.name;

					_cellEx = new IconCellEx(mc.iconContainer, 0, 0, 60, 60);
					_dt = new ThingsData();
					_dt.id = _itemCfg.id;
					_dt.type = SlotType.IT_ITEM;
					_dt.bind = _data.is_bind;
					IconCellEx.setItemByThingsData(_cellEx, _dt);
					ToolTipManager.getInstance().attach(_cellEx);
				}
				if (mc.costContainer)
				{
					ObjectUtils.clearAllChild(mc.costContainer);
					mc.costContainer.addChild(new CostType(_data.cost_type));
				}
				if (mc.originalContainer)
				{
					ObjectUtils.clearAllChild(mc.originalContainer);
					mc.originalContainer.addChild(new CostType(_data.cost_type));
				}
				if (_data.is_limit) {
					if (mc.limitContainer) {
						ObjectUtils.clearAllChild(mc.limitContainer);
						mc.limitContainer.addChild(new CostType(ResIconType.TYPE_LIMIT));
					}
				}
				mc.txtGive.visible = Boolean(_data.is_give);
				mc.btnGive.visible = Boolean(_data.is_give);
				
				hightLight = data.hight_light;
			}
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McMallItem = _skin as McMallItem;
			rsrLoader.addCallBack(skin.bg, function (mc:MovieClip):void
			{
				mc.mouseChildren = false;
				mc.mouseEnabled = false;
				_isBagInited = true;
				checkHightLight();
			});
			rsrLoader.addCallBack(skin.btnBuy, function (mc:MovieClip):void
			{
				_isBuyBtnInited = true;
				checkHightLight();
			});
		}

		override public function destroy():void
		{
			hightLight = false;
			if (_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK, onClick);
				_skin = null;
			}
			if (_itemCfg)
			{
				_itemCfg = null;
			}
			if (_dt)
			{
				_dt = null;
			}
			if (_cellEx)
			{
				ToolTipManager.getInstance().detach(_cellEx);
				_cellEx.destroy();
				_cellEx = null;
			}
			super.destroy();
		}

		/**赠送*/
		private function giveHandler():void
		{
			if (_data)
			{
				MallBuyData.giveData = null;
				MallBuyData.giveData = _data;
			}
			PanelMediator.instance.openPanel(PanelConst.TYPE_MALL_GIVE);
		}

		/**购买*/
		private function buyHandler():void
		{
			if (_data)
			{
				MallBuyData.buyData = null;
				MallBuyData.buyCount = 1;
				MallBuyData.buyData = _data;
			}
			if (_data.is_limit) {
				var byte:ByteArray = new ByteArray();
				byte.endian = Endian.LITTLE_ENDIAN;
				byte.writeInt(_data.id);
				ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_CHR_LIMIT_NUM, byte);
			}
			PanelMediator.instance.openPanel(PanelConst.TYPE_MALL_BUY);
			hightLight = false;
		}

		private function initTxt():void
		{
			var mc:McMallItem = _skin as McMallItem;
			mc.txtPrice.text = StringConst.MALL_LABEL_4;
			mc.txtOriginalPrice.textColor = 0xfff2cc;
			mc.txtOriginalPrice.text = StringConst.MALL_LABEL_8;
			mc.txtOriginal.textColor = 0xfff2cc;
            mc.txtCost.textColor = 0xffcc00;

			mc.txtGive.text = StringConst.MALL_LABEL_5;
			mc.txtBuy.text = StringConst.MALL_LABEL_6;
			mc.txtGive.mouseEnabled = false;
			mc.txtBuy.mouseEnabled = false;
		}

		private function onClick(event:MouseEvent):void
		{
			var mc:McMallItem = _skin as McMallItem;
			switch (event.target)
			{
				default :
					break;
				case mc.btnBuy:
					buyHandler();
					break;
				case mc.btnGive:
					giveHandler();
					break;
			}
		}
	}
}