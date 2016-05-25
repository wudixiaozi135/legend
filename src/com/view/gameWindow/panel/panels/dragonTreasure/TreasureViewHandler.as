package com.view.gameWindow.panel.panels.dragonTreasure
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.ItemCfgData;
    import com.model.configData.cfgdata.TreasureCfgData;
    import com.model.consts.EffectConst;
    import com.model.consts.SlotType;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.dragonTreasure.data.TreasureEventData;
    import com.view.gameWindow.panel.panels.dragonTreasure.data.TreasureIconData;
    import com.view.gameWindow.panel.panels.dragonTreasure.treasureWareHouse.item.LinkTxtRow;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.NumPic;
    import com.view.gameWindow.util.UIEffectLoader;
    import com.view.gameWindow.util.cell.IconCellEx;
    import com.view.gameWindow.util.cell.ThingsData;
    import com.view.gameWindow.util.scrollBar.ScrollBar;
    import com.view.gameWindow.util.scrollBar.ScrollContent;
    import com.view.selectRole.SelectRoleDataManager;
    
    import flash.display.MovieClip;

    /**
	 * Created by Administrator on 2014/11/29.
	 */
	public class TreasureViewHandler implements IObserver
	{
		private var _panel:PanelTreasure;
		private var _skin:McTreasurePanel;
		private var _cellExs:Vector.<IconCellEx>;
		private var _dtVec:Vector.<ThingsData>;
		private var _mgt:DragonTreasureManager;

		private var _scoreEx:IconCellEx;
		private var _scoreDt:ThingsData;

		private var _scrollBar1:ScrollBar;
		private var _scrollBar2:ScrollBar;
//		private var _scrollRect1:Rectangle;
//		private var _scrollRect2:Rectangle;
		private var _contentHeight:int;
		
		private var _uiEffectLoader:UIEffectLoader;

		private var goldNumPic:NumPic;
		private var scoreNumPic:NumPic;

		private var _scrollContent1:ScrollContent;
		private var _scrollContent2:ScrollContent;


		public function TreasureViewHandler(panel:PanelTreasure)
		{
			_panel = panel;
			_skin = _panel.skin as McTreasurePanel;
			_mgt = DragonTreasureManager.instance;
			initialize();
			initData();
			initScoreReward();
//			DragonTreasureEvent.addEventListener(DragonTreasureEvent.SWITCH_TAB, switchTabHandler, false, 0, true);
			DragonTreasureManager.instance.attach(this);
			BagDataManager.instance.attach(this);
			_uiEffectLoader = new UIEffectLoader(_skin,463,65,1,1,EffectConst.RES_TREASURE);
            ToolTipManager.getInstance().attachByTipVO(_skin.mcGold, ToolTipConst.TEXT_TIP, HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_1));
		}

		public function refresh():void
		{
		}

		public function update(proc:int = 0):void
		{
			switch (proc)
			{
				case GameServiceConstants.SM_BAG_ITEMS:
					updateGold();
					break;
				case GameServiceConstants.SM_FIND_TREASURE:
					updateMyScore();
					break;
//				case GameServiceConstants.SM_FIND_TREASURE_STORAGE:
//					updateStorage();
//					break;
				case GameServiceConstants.SM_FIND_TREASURE_EVENT:
					updateTreasureEvt();
					break;
				default :
					break;
			}
		}

//		private function updateStorage():void
//		{
//			var mgt:DragonTreasureManager = DragonTreasureManager.instance;
//			_skin.txtVolumeValue.text = mgt.storageDatas.length + "/" + DragonTreasureManager.STORAGE_MAX;//最大容量
//		}

		private function updateGold():void
		{
			var dataManager:BagDataManager = BagDataManager.instance;
			if(goldNumPic==null)
			{
				goldNumPic = new NumPic();
			}
			goldNumPic.init("yellow_",dataManager.goldUnBind.toString(),_skin.mcGoldNum);
			
//			_skin.txtGoldValue.text = dataManager.goldUnBind.toString();
//			_skin.txtPicTxt.text = dataManager.getItemNumById(ItemType.IT_TREASURE_MAP).toString();
		}

		/**更新寻宝事件*/
		private function updateTreasureEvt():void
		{
			var sid:int = SelectRoleDataManager.getInstance().selectSid;
			var cid:int = SelectRoleDataManager.getInstance().selectCid;
			var mgt:DragonTreasureManager = DragonTreasureManager.instance;
			var data:Vector.<TreasureEventData> = mgt.treasureEvtDatas;
			var totalHeight:int;
			var myTotalHeight:int;
			_scrollContent1.removeAllItem();
			_scrollContent2.removeAllItem();
			
			var countNum:int = 0;
			var myCountNum:int=0;
			for (var i:int = 0, len:int = data.length; i < len; i++)
			{
				var item:TreasureEventData = data[i];
				
				if(item.cid==cid&&item.sid==sid)
				{
					var myLink:LinkTxtRow=new LinkTxtRow();
					myLink.data=data[i];
					_scrollContent2.additem(myLink);
					myLink.y = 17 * myCountNum;
					
					myTotalHeight+=17;
					myCountNum++;
				}
				
				if (item.itemType == SlotType.IT_ITEM)
				{
					var cfg:ItemCfgData = ConfigDataManager.instance.itemCfgData(item.itemId);
					if (cfg)
					{
						if (cfg.item_level < 60)
						{//60级物品不显示
							continue;
						}
					}
				}
				var row:LinkTxtRow = new LinkTxtRow();
				row.data = data[i];
				_scrollContent1.additem(row);
				row.y = 17 * countNum;
				totalHeight += 17;
				countNum++;
			}
			_scrollContent1.contentHeight=totalHeight;
			_scrollContent1.scrollTo(totalHeight - _scrollContent1.scrollRectHeight);
			if (_scrollBar1)
			_scrollBar1.resetScroll();
			
			_scrollContent2.contentHeight=myTotalHeight;
			_scrollContent2.scrollTo(myTotalHeight - _scrollContent2.scrollRectHeight);
			if (_scrollBar2)
				_scrollBar2.resetScroll();
		}

		private function updateMyScore():void
		{
			var mgt:DragonTreasureManager = DragonTreasureManager.instance;
			if(scoreNumPic==null)
			{
				scoreNumPic = new NumPic();
			}
			scoreNumPic.init("yellow_",mgt.score.toString(),_skin.mcScoreNum);
		}

		private function initScoreReward():void
		{
//			var scoreCfg:TreasureShopCfgData=_mgt.getScoreReward(TreasureShopType.SHELF_USUAL);//读取普通积分商店里的第一个位置的物品
//			_scoreEx=new IconCellEx(_skin.itemScore,0,0,60,60);
//			_scoreDt=new ThingsData();
//			_scoreDt.id=scoreCfg.item_id;
//			_scoreDt.type=scoreCfg.item_type;
//			IconCellEx.setItemByThingsData(_scoreEx,_scoreDt);
//			ToolTipManager.getInstance().attach(_scoreEx);

//			_skin.txtScoreExchange.mouseEnabled = false;
//			_skin.txtScoreExchange.text = scoreCfg.cost_value + StringConst.PANEL_DRAGON_TREASURE_015;
		}

//		private function switchTabHandler(event:DragonTreasureEvent):void
//		{
//			var type:int = DragonTreasureManager.instance.getTypeBySelectIndex();
//			if (type > 0) {
//				setTypeShop(type);
//			}
//		}

		private function initData():void
		{
			_cellExs = new Vector.<IconCellEx>();
			_dtVec = new Vector.<ThingsData>();
//			var cfg:TreasureCfgData = _mgt.getCfgByWoldLevel();
//			var datas:Vector.<TreasureIconData> = _mgt.getTreasureIconDataByGift(cfg.gift_desc);
			
//			var datas:Vector.<TreasureIconData> = _mgt.getTypeConfig(TreasureType.TYPE_1, false);
			var  cellEx:IconCellEx, dt:ThingsData, size:int;
			size=36;
			for (var i:int = 0, len:int =14; i < len; i++) {
//				data = datas[i];
//				i > 1 ? size = 48 : size = 60;
				cellEx = new IconCellEx(_skin["item" + i], 0, 0, size, size);
				_cellExs[i] = cellEx;
				dt = new ThingsData();
				_dtVec[i] = dt;
			}
			setWoldLevelShop();

			_scrollContent1.setScrollRectWH(214,156);
			_scrollContent2.setScrollRectWH(214,124);
			updateGold();
		}

		public function initScrollBar1(mc:MovieClip):void
		{
			_scrollBar1 = new ScrollBar(_scrollContent1, mc, 0, null, 10);
			_scrollBar1.resetHeight(_scrollContent1.scrollRectHeight);
			_scrollBar1.resetScroll();
		}
		
		public function initScrollBar2(mc:MovieClip):void
		{
			_scrollBar2 = new ScrollBar(_scrollContent2, mc, 0, null, 10);
			_scrollBar2.resetHeight(_scrollContent2.scrollRectHeight);
			_scrollBar2.resetScroll();
		}

		/**根据类型显示*/
		public function setWoldLevelShop():void
		{
			destroyTip();
			var config:TreasureCfgData = _mgt.getCfgByWoldLevel();
			var datas:Vector.<TreasureIconData> = _mgt.getTreasureIconDataByGift(config.gift_desc);
//			var datas:Vector.<TreasureIconData> = _mgt.getTypeConfig(type, false);
			var data:TreasureIconData, cellEx:IconCellEx, dt:ThingsData;
			var job:int = RoleDataManager.instance.job;
			var sex:int = RoleDataManager.instance.sex;
			var index:int=0
			for (var i:int = 0, len:int = datas.length; i < len; i++) {
				data = datas[i];
				if(data.sex!=0&&data.sex!=sex)
				{
					continue;
				}
				if(index>=_cellExs.length)continue;
				cellEx = _cellExs[index];
				dt = _dtVec[index];
				dt.id = data.id;
				dt.type = data.type;
				index++;
				IconCellEx.setItemByThingsData(cellEx, dt);
				ToolTipManager.getInstance().attach(cellEx);
			}
//			var config:TreasureCfgData = ConfigDataManager.instance.findTreasure(type);
			var costItem:Array = null;
			var costValueStr:String = "", cfg:Object;
			/////
			costItem = config.one_item_cost.split(":");//物品ID：物品类型：物品数量
			if (costItem[1] == SlotType.IT_EQUIP)
			{
				cfg = ConfigDataManager.instance.equipCfgData(costItem[0]);
			} else
			{
				cfg = ConfigDataManager.instance.itemCfgData(costItem[0]);
			}
			costValueStr = config.one_gold_cost + StringConst.GOLD + "(" + cfg.name + "X" + costItem[2] + ")";
			_skin.btnTxt1.htmlText = HtmlUtils.createHtmlStr(0xffe1aa, costValueStr);

			//////
			costItem = config.five_item_cost.split(":");//物品ID：物品类型：物品数量
			if (costItem[1] == SlotType.IT_EQUIP)
			{
				cfg = ConfigDataManager.instance.equipCfgData(costItem[0]);
			} else
			{
				cfg = ConfigDataManager.instance.itemCfgData(costItem[0]);
			}
			costValueStr = config.five_gold_cost + StringConst.GOLD + "(" + cfg.name + "X" + costItem[2] + ")";
			_skin.btnTxt10.htmlText = HtmlUtils.createHtmlStr(0xffe1aa, costValueStr);

			//////
			costItem = config.ten_item_cost.split(":");//物品ID：物品类型：物品数量
			if (costItem[1] == SlotType.IT_EQUIP)
			{
				cfg = ConfigDataManager.instance.equipCfgData(costItem[0]);
			} else
			{
				cfg = ConfigDataManager.instance.itemCfgData(costItem[0]);
			}
			costValueStr = config.ten_gold_cost + StringConst.GOLD + "(" + cfg.name + "X" + costItem[2] + ")";
			_skin.btnTxt50.htmlText = HtmlUtils.createHtmlStr(0xffe1aa, costValueStr);
		}

		private function initialize():void
		{

			_skin.btnChargeTxt.textColor = 0xd4a460;
			_skin.btnChargeTxt.mouseEnabled = false;
			_skin.btnChargeTxt.text = StringConst.PANEL_DRAGON_TREASURE_006;

			_skin.btnVolumeTxt.textColor = 0xd4a460;
			_skin.btnVolumeTxt.mouseEnabled = false;
			_skin.btnVolumeTxt.text = StringConst.PANEL_DRAGON_TREASURE_007;

			_scrollContent1 = new ScrollContent();
			_skin.addChild(_scrollContent1);
			_scrollContent1.x=640;
			_scrollContent1.y=350;
			
			_scrollContent2 = new ScrollContent();
			_skin.addChild(_scrollContent2);
			_scrollContent2.x=640;
			_scrollContent2.y=196;

			_skin.btnTxt1.mouseEnabled = false;
			_skin.btnTxt10.mouseEnabled = false;
			_skin.btnTxt50.mouseEnabled = false;
		}

		private function destroyTip():void
		{
			for each(var cell:IconCellEx in _cellExs) {
				ToolTipManager.getInstance().detach(cell);
			}
		}
		public function destroy():void
		{
			DragonTreasureManager.instance.detach(this);
			BagDataManager.instance.detach(this);
			ToolTipManager.getInstance().detach(_skin.mcGold);
			destroyTip();
			
			if(goldNumPic!=null)
			{
				goldNumPic.destory();
			}
			
			if(scoreNumPic!=null)
			{
				scoreNumPic.destory();
			}
			
			if(_scrollBar1!=null)
			{
				_scrollBar1.destroy();
			}
			
			if(_scrollBar2!=null)
			{
				_scrollBar2.destroy();
			}
			
			for each(var cell:IconCellEx in _cellExs) {
				cell.destroy();
				cell = null;
			}
			_cellExs = null;

			for each(var dt:ThingsData in _dtVec) {
				dt = null;
			}
			_dtVec = null;

			if(_scoreEx){
				ToolTipManager.getInstance().detach(_scoreEx);
				_scoreEx.destroy();
				_scoreEx=null;
			}
			
			if(_scoreDt){
				_scoreDt=null;
			}
			
			if(_uiEffectLoader)
			{
				_uiEffectLoader.destroy();
				_uiEffectLoader = null;
			}
		}
	}
}
