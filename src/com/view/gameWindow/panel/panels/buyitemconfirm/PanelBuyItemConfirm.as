package com.view.gameWindow.panel.panels.buyitemconfirm
{
    import com.model.business.fileService.UrlBitmapDataLoader;
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.configData.cfgdata.ItemCfgData;
    import com.model.configData.cfgdata.NpcShopCfgData;
    import com.model.consts.ConstPriceType;
    import com.model.consts.ConstStorage;
    import com.model.consts.ItemType;
    import com.model.consts.SlotType;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.npcshop.McPanelBuyItemConfirm;
    import com.view.gameWindow.panel.panels.npcshop.NpcShopDataManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.UtilCostRollTip;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;

    /**
	 * 购买物品确认面板类
	 * @author Administrator
	 */	
	public class PanelBuyItemConfirm extends PanelBase implements IPanelBuyItemConfirm,IUrlBitmapDataLoaderReceiver
	{
		private const cellW:int = 60,cellH:int = 60;
		private var _urlBitmapDataLoader:UrlBitmapDataLoader;
		private var _bitmap:Bitmap;

		private var _cfgDt:NpcShopCfgData;
		private var _num:int;
        private var _mcCost1:Sprite;
        private var _mcCost2:Sprite;
		public function PanelBuyItemConfirm()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			_cfgDt = PanelBuyItemConfirmData.cfgDt;
			_skin = new McPanelBuyItemConfirm();
			addChild(_skin);
			setTitleBar((_skin as McPanelBuyItemConfirm).mcTitleBar);
			if(_cfgDt)
			{
				_skin.icon0.resUrl = ConstPriceType.getResUrl(_cfgDt.price_type);
				_skin.icon1.resUrl = ConstPriceType.getResUrl(_cfgDt.price_type);
                _mcCost1 = new Sprite();
                _mcCost1.graphics.beginFill(0xffffff, 0);
                _mcCost1.graphics.drawRect(0, 0, _skin.icon0.width, _skin.icon0.height);
                _mcCost1.graphics.endFill();
                _skin.icon0.addChild(_mcCost1);

                _mcCost2 = new Sprite();
                _mcCost2.graphics.beginFill(0xffffff, 0);
                _mcCost2.graphics.drawRect(0, 0, _skin.icon1.width, _skin.icon1.height);
                _mcCost2.graphics.endFill();
                _skin.icon1.addChild(_mcCost2);

                ToolTipManager.getInstance().attachByTipVO(_mcCost1, ToolTipConst.TEXT_TIP, getCostLabel(_cfgDt.price_type));
                ToolTipManager.getInstance().attachByTipVO(_mcCost2, ToolTipConst.TEXT_TIP, getCostLabel(_cfgDt.price_type));
			}
		}

        private function getCostLabel(priceType:int):String
        {
            switch (priceType)
            {
                case 1:
                    return HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_4);
                case 2:
                    return HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_5);
                case 3:
                    return HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_1);
                case 4:
                    return HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_2);
            }
            return "";
        }
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
		}
		
		override protected function initData():void
		{
			var mc:McPanelBuyItemConfirm = _skin as McPanelBuyItemConfirm;
			mc.txtName.mouseEnabled = false;
			mc.txtName.text = StringConst.BUY_IMTE_CONFIRM_0001;
			var defaultTextFormat:TextFormat = mc.txtName.defaultTextFormat;
			defaultTextFormat.bold = true;
			mc.txtName.defaultTextFormat = defaultTextFormat;
			mc.txtName.setTextFormat(defaultTextFormat);
			mc.txtPrice.text = StringConst.BUY_IMTE_CONFIRM_0002;
            mc.txtPrice.mouseEnabled = false;
            mc.txtPriceValue.mouseEnabled = false;
			mc.txtHeapMax.text = StringConst.BUY_IMTE_CONFIRM_0003;
			mc.txtBuyNum.text = StringConst.BUY_IMTE_CONFIRM_0004;
			mc.txtAllCost.text = StringConst.BUY_IMTE_CONFIRM_0005;
			mc.txtBtn.text = StringConst.BUY_IMTE_CONFIRM_0006;
			mc.txtBtn.mouseEnabled = false;
			mc.txtAllCostValue.x = mc.txtAllCost.x+mc.txtAllCost.textWidth+2;
			mc.txtAllCostValue.width = 70;
			mc.txtAllCostValue.border = true;
			mc.txtAllCostValue.autoSize = TextFieldAutoSize.CENTER;
			mc.txtButNumValue.type = TextFieldType.INPUT;
			mc.txtButNumValue.selectable = true;
			mc.txtButNumValue.restrict="0-9";
			mc.txtButNumValue.addEventListener(Event.CHANGE,onTextInputHandler);
			mc.addEventListener(MouseEvent.CLICK,onClick);
			initText();
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var mc:McPanelBuyItemConfirm = _skin as McPanelBuyItemConfirm;
			switch(event.target)
			{
				case mc.btnClose:
					PanelMediator.instance.switchPanel(PanelConst.TYPE_BUY_ITEM_CONFIRM);
					break;
				case mc.btnSub:
					var num1:int = int(mc.txtButNumValue.text);
					num1 = num1 <= 1 ? 1 : num1-1;
					mc.txtButNumValue.text= num1+"";
					mc.txtAllCostValue.text = num1*_cfgDt.price_value+"";
					_num = num1;
					break;
				case mc.btnAdd:
					var num2:int = int(mc.txtButNumValue.text);
					num2 = /*num2 >= maxBuyNum ? maxBuyNum : */num2+1;//不限增加上限
					mc.txtButNumValue.text= num2+"";
					mc.txtAllCostValue.text = num2*_cfgDt.price_value+"";
					_num = num2;
					break;
				case mc.btnOne:
					sendData();
					PanelMediator.instance.switchPanel(PanelConst.TYPE_BUY_ITEM_CONFIRM);
					break;
			}
		}
		
		private function onTextInputHandler(event:Event):void
		{
			var mc:McPanelBuyItemConfirm = _skin as McPanelBuyItemConfirm;
			mc.txtAllCostValue.text = int(mc.txtButNumValue.text)*_cfgDt.price_value+"";
			_num = int(mc.txtButNumValue.text);
		}
		
		private function sendData():void
		{
			var mc:McPanelBuyItemConfirm = _skin as McPanelBuyItemConfirm;
			var str:String;
			var num:Number = int(mc.txtButNumValue.text);
			
			if(num == 0)
			{
				return;
			}
			
			if(!_cfgDt)
			{
				return;
			}
			if(!UtilCostRollTip.costShopBuy(_cfgDt,num))
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,UtilCostRollTip.str);
				return;
			}
			NpcShopDataManager.instance.cmNpcShopBuy(_cfgDt.id,num,ConstStorage.ST_CHR_BAG);
		}
		
		override public function update(proc:int=0):void
		{
				
		}
		
		private function initText():void
		{
			_cfgDt = PanelBuyItemConfirmData.cfgDt;
			var url:String,name:String,color:int;
			var mc:McPanelBuyItemConfirm = _skin as McPanelBuyItemConfirm;
			if(!_cfgDt)
			{
				return;
			}
			if(_cfgDt.type == SlotType.IT_EQUIP)
			{
				var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(_cfgDt.base);
				url = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD+equipCfgData.icon+ResourcePathConstants.POSTFIX_PNG;
				name = equipCfgData.name;
				color = ItemType.getColorByQuality(equipCfgData.color);
				ToolTipManager.getInstance().attachByTipVO(_skin.mcIcon, ToolTipConst.EQUIP_BASE_TIP,equipCfgData);

			}
			else if(_cfgDt.type == SlotType.IT_ITEM)
			{
				var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(_cfgDt.base);
				url = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD+itemCfgData.icon+ResourcePathConstants.POSTFIX_PNG;
				name = itemCfgData.name;
				color = ItemType.getColorByQuality(itemCfgData.quality);
				ToolTipManager.getInstance().attachByTipVO(_skin.mcIcon, ToolTipConst.ITEM_BASE_TIP,itemCfgData);
			}
			loadPic(url);
			mc.txtItemName.text = name;
			mc.txtItemName.textColor = color;
			mc.txtPriceValue.text = _cfgDt.price_value+"";
			mc.txtHeapMaxValue.text = "99";
			mc.txtButNumValue.text = "1";
			mc.txtAllCostValue.text = int(mc.txtButNumValue.text)*_cfgDt.price_value+"";
			_num = int(mc.txtButNumValue.text);
		}
		
		private function loadPic(url:String):void
		{
			_urlBitmapDataLoader = new UrlBitmapDataLoader(this);
			_urlBitmapDataLoader.loadBitmap(url);
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
			if(_bitmap)
			{
				if(_bitmap.parent)
					_bitmap.parent.removeChild(_bitmap);
				if(_bitmap.bitmapData)
					_bitmap.bitmapData.dispose();
				_bitmap = null;
			}
			_bitmap = new Bitmap(bitmapData,"auto",true);
			_bitmap.width = cellW;
			_bitmap.height = cellH;
			(_skin as McPanelBuyItemConfirm).mcIcon.addChild(_bitmap);
			destroyLoader();
		}
		
		public function setNull():void
		{
			if(_bitmap)
			{
				(_skin as McPanelBuyItemConfirm).mcIcon.removeChild(_bitmap);
				_bitmap.bitmapData.dispose();
				_bitmap = null;
			}
		}
		
		private function get maxBuyNum():int
		{
			if(_cfgDt.price_type == 3)
				return BagDataManager.instance.goldUnBind/_cfgDt.price_value;
			else
				return (BagDataManager.instance.coinBind+BagDataManager.instance.coinUnBind)/_cfgDt.price_value;
		}
		
		private function destroyLoader():void
		{
			if(_urlBitmapDataLoader)
				_urlBitmapDataLoader.destroy();
			_urlBitmapDataLoader = null;
		}
		
		override public function destroy():void
		{
            if (_mcCost1)
            {
                ToolTipManager.getInstance().detach(_mcCost1);
                if (_mcCost1.parent)
                {
                    _mcCost1.parent.removeChild(_mcCost1);
                    _mcCost1 = null;
                }
            }
            if (_mcCost2)
            {
                ToolTipManager.getInstance().detach(_mcCost2);
                if (_mcCost2.parent)
                {
                    _mcCost2.parent.removeChild(_mcCost2);
                    _mcCost2 = null;
                }
            }
			ToolTipManager.getInstance().detach(_skin.mcIcon);
			PanelBuyItemConfirmData.cfgDt = null;
			setNull();
			destroyLoader();
			super.destroy();
		}
	}
}