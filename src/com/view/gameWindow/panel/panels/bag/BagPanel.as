package com.view.gameWindow.panel.panels.bag
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.consts.ConstStorage;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.bag.cell.BagCell;
    import com.view.gameWindow.panel.panels.bag.cell.BagCellClickHandle;
    import com.view.gameWindow.panel.panels.bag.cell.BagCellDragHandle;
    import com.view.gameWindow.panel.panels.bag.cell.BagCellMouseEfHandle;
    import com.view.gameWindow.panel.panels.bag.cell.BagCellRectRimHandle;
    import com.view.gameWindow.panel.panels.bag.menu.BagCellMenuDataManager;
    import com.view.gameWindow.panel.panels.expStone.ExpStoneDataManager;
    import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
    import com.view.gameWindow.panel.panels.hero.HeroDataManager;
    import com.view.gameWindow.panel.panels.onhook.AutoSystem;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;
    
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    public class BagPanel extends PanelBase implements IBagPanel
	{
		private var _bagCells:Vector.<BagCell>;
		private var _bagPanelOnClick:BagPanelClickHander;
		private var _bagCellDragHander:BagCellDragHandle;
		private var _bagCellClickHandle:BagCellClickHandle;
		private var _bagCellRectRimHandle:BagCellRectRimHandle;
		private var _bagCellMouseEfHandle:BagCellMouseEfHandle;

		private var num:int = 0;
		
		public function BagPanel()
		{
			super();
			isSingleton = true;
			attach();
		}
		
		private function attach():void
		{
			BagDataManager.instance.attach(this);
			BagCellMenuDataManager.instance.attach(this);
			HeroDataManager.instance.attach(this);
			ExpStoneDataManager.instance.attach(this);
			RoleDataManager.instance.attach(this);
		}
		
		override protected function initSkin():void
		{
			_skin = new McBag();
			addChild(_skin);
			setTitleBar((_skin as McBag).mcTitleBar);
            addTips();
		}

        private function addTips():void
        {
            var skin:McBag = _skin as McBag;
            ToolTipManager.getInstance().attachByTipVO(skin.mcCoin, ToolTipConst.TEXT_TIP, HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_4));
            ToolTipManager.getInstance().attachByTipVO(skin.mcBindCoin, ToolTipConst.TEXT_TIP, HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_5));
            ToolTipManager.getInstance().attachByTipVO(skin.mcGold, ToolTipConst.TEXT_TIP, HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_1));
            ToolTipManager.getInstance().attachByTipVO(skin.mcBindGold, ToolTipConst.TEXT_TIP, HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_2));
        }

        private function removeTips():void
        {
            var skin:McBag = _skin as McBag;
            ToolTipManager.getInstance().detach(skin.mcCoin);
            ToolTipManager.getInstance().detach(skin.mcBindCoin);
            ToolTipManager.getInstance().detach(skin.mcGold);
            ToolTipManager.getInstance().detach(skin.mcBindGold);
        }
		override public function setPostion():void 
		{
            var mc:McMainUIBottom = (MainUiMediator.getInstance().bottomBar as BottomBar).skin as McMainUIBottom;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.btnBag.x, mc.btnBag.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
		}
		
		override protected function initData():void
		{
			initTxt();
			initBagCells();
			_bagCellRectRimHandle = new BagCellRectRimHandle(_skin as McBag);
			requestBagData();
			_bagPanelOnClick = new BagPanelClickHander();
			_bagPanelOnClick.mcBag = _skin as McBag;
			_bagPanelOnClick.addEvent(this);
			_bagCellDragHander = new BagCellDragHandle();
			_bagCellDragHander.addEvent(this);
			_bagCellClickHandle = new BagCellClickHandle(this);
			_bagCellMouseEfHandle=new BagCellMouseEfHandle(this);
			
			addEventListener(Event.ADDED_TO_STAGE,onAdded2Stage);
		}
		/**初始化文本*/
		private function initTxt():void
		{
			var mcBag:McBag,defaultTextFormat:TextFormat;
			mcBag = _skin as McBag;
			defaultTextFormat = mcBag.txtName.defaultTextFormat;
			defaultTextFormat.bold = true;
			mcBag.txtName.defaultTextFormat = defaultTextFormat;
			mcBag.txtName.setTextFormat(defaultTextFormat);
			mcBag.txtName.text = StringConst.BAG_PANEL_0001;
			
			mcBag.selectCellEfc.visible=false;
		}
		/**初始化背包单元格*/
		private function initBagCells():void
		{
			var jl:int = 7,il:int = 9,i:int,j:int,vector:Vector.<BagCell>;
			_bagCells = new Vector.<BagCell>(BagDataManager.totalCellNum,true);
			for(j=0;j<jl;j++)
			{
				for(i=0;i<il;i++)
				{
					var bagCell:BagCell = new BagCell();
					bagCell.storageType = ConstStorage.ST_CHR_BAG;
					bagCell.cellId = j*il+i;
					bagCell.initView();
					bagCell.refreshLockState(true);
					bagCell.x = 46*(i+1);
					bagCell.y = 38+46*(j+1);
					_skin.addChild(bagCell);
					_bagCells[j*il+i] = bagCell;
				}
			}
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var mcBag:McBag;
			mcBag = _skin as McBag;
			rsrLoader.addCallBack(mcBag.btnRole,function (mc:MovieClip):void
			{
				mcBag.btnRole.selected = true;
				mcBag.btnRole.mouseEnabled = false;
				var textField:TextField = mcBag.btnRole.txt as TextField;
				textField.text = StringConst.BAG_PANEL_0003;
				textField.textColor = 0xffe1aa;
			});
			rsrLoader.addCallBack(mcBag.btnBtach,function (mc:MovieClip):void
			{
				var textField:TextField = mcBag.btnBtach.txt as TextField;
				textField.text = StringConst.HERO_PANEL_003;
				textField.textColor = 0xd4a460;
			});
			rsrLoader.addCallBack(mcBag.btnBuy,function (mc:MovieClip):void
			{
				var textField:TextField = mcBag.btnBuy.txt as TextField;
				textField.text = StringConst.BAG_PANEL_0005;
				textField.textColor = 0xd4a460;
				InterObjCollector.instance.add(mc,PanelConst.TYPE_BAG);
			});
			rsrLoader.addCallBack(mcBag.btnSell,function (mc:MovieClip):void
			{
				var textField:TextField = mcBag.btnSell.txt as TextField;
				textField.text = StringConst.BAG_PANEL_0006;
				textField.textColor = 0xd4a460;
				
				InterObjCollector.instance.add(mc,PanelConst.TYPE_BAG);
			});
			rsrLoader.addCallBack(mcBag.btnArrange,function (mc:MovieClip):void
			{
				var textField:TextField = mcBag.btnArrange.txt as TextField;
				textField.text = StringConst.BAG_PANEL_0007;
				textField.textColor = 0xd4a460;
				_bagPanelOnClick.initBtnSort();
				InterObjCollector.instance.add(mc,PanelConst.TYPE_BAG);
			});
			rsrLoader.addCallBack(mcBag.selectCellEfc,function (mc:MovieClip):void
			{
//				mcBag.selectCellEfc.visible=false;
				mcBag.mouseEnabled=false;
			});
		}
		/**请求背包数据*/
		private function requestBagData():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(0);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_BAG_ITEMS,byteArray);
		}
		
		private function onAdded2Stage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onAdded2Stage);
			_bagCellDragHander.stage = stage;
		}
		
		override public function update(proc:int = 0):void
		{
			if(proc == HeroDataManager.TYPE_EXCHANGE)
			{
				_bagCellRectRimHandle.switchVisible();
			}
			else if(proc == GameServiceConstants.SM_CHR_INFO)
			{
				num += 1;
				refreshMoneys();
				refreshBagCellData();
			}
			else if(proc == GameServiceConstants.SM_BAG_ITEMS)
			{
				num += 1;
				refreshMoneys();
				refreshBagCellData();
			}
			else
			{
				refreshMoneys();
				refreshBagCellData();
			}
			if(num == 2)
			{
				refreshBagCellData();
				num = 0;
			}
			_bagCellClickHandle.dealNotify(proc);
		}
		
		private function refreshMoneys():void
		{
			var mcBag:McBag,instance:BagDataManager;
			instance = BagDataManager.instance;
			mcBag = _skin as McBag;
            if (mcBag)
            {
                mcBag.txtMoney.text = stringFormat(instance.coinUnBind) + "";
                mcBag.txtMoneyBind.text = stringFormat(instance.coinBind) + "";
                mcBag.txtGold.text = stringFormat(instance.goldUnBind) + "";
                mcBag.txtGoldBind.text = stringFormat(instance.goldBind) + "";
            }
		}
		
		private function stringFormat(num:int):String
		{
			var s:String=String(num);
			var ret:String='';
			var symbol:String ="";
			if(s.charAt(0)=="+"||s.charAt(0)=="-")
			{
				symbol = s.charAt(0);
				s =s.substr(1);
			}
			for(var i:int=s.length-3;i>0;i-=3)
			{
				ret=','+s.substr(i,3)+ret;
			}
			ret=symbol+s.substr(0,i+3)+ret;
			return ret;
		}
		
		private function refreshBagCellData():void
		{
			var isAuto:Boolean = AutoSystem.instance.isAuto();
			trace("refreshBagCellData"+isAuto);
			var bagCellDatas:Vector.<BagData>,dt:BagData,i:int,usedCell:int,numCelUnLock:int;
			bagCellDatas = BagDataManager.instance.bagCellDatas;
			numCelUnLock = BagDataManager.instance.numCelUnLock;
			if(bagCellDatas)
			{
				for(i=0;i<BagDataManager.totalCellNum;i++)
				{
					if(_bagCellDragHander.clickBagCell && _bagCells[i].cellId == _bagCellDragHander.clickBagCell.cellId)
					{
						continue;
					}
					dt = bagCellDatas[i];
					_bagCells[i].refreshLockState((i+1)>numCelUnLock);
					if(dt)
					{
						_bagCells[i].refreshData(dt);
						usedCell++;
						ToolTipManager.getInstance().attach(_bagCells[i]);
					}
					else
					{
						ToolTipManager.getInstance().detach(_bagCells[i]);
						_bagCells[i].setNull();
					}
				}
			}
			var mcBag:McBag = _skin as McBag;
			mcBag.txtCellNum.text = StringConst.BAG_PANEL_0008+usedCell+"/"+numCelUnLock;
		}
		
		override public function show(layer:Sprite):void
		{
			super.show(layer);
			attach();
			update();
		}
		
		override public function hide():void
		{
			super.hide();
			detach();
		}
		
		private function detach():void
		{
			HeroDataManager.instance.detach(this);
			BagCellMenuDataManager.instance.detach(this);
			BagDataManager.instance.detach(this);
			ExpStoneDataManager.instance.detach(this);
			RoleDataManager.instance.detach(this);
		}
		
		override public function destroy():void
		{
            removeTips();
			detach();
			var bagCell:BagCell;
			if(_bagCells)
			{
				for each(bagCell in _bagCells)
				{
					if(bagCell)
					{
						bagCell.destory();
						ToolTipManager.getInstance().detach(bagCell);
					}
					_bagCells[_bagCells.indexOf(bagCell)] = null;
				}
				_bagCells = null;
			}
			if(_bagPanelOnClick)
			{
				_bagPanelOnClick.removeEvent(this);
				_bagPanelOnClick = null;
			}
			if(_bagCellDragHander)
			{
				_bagCellDragHander.removeEvent(this);
				_bagCellDragHander = null;
			}
			if(_bagCellClickHandle)
				_bagCellClickHandle.destory();
			_bagCellClickHandle = null;
			if(_bagCellMouseEfHandle)
			{
				_bagCellMouseEfHandle.destory();
			}
			_bagCellMouseEfHandle=null;
			
			InterObjCollector.instance.removeByGroupId(PanelConst.TYPE_BAG);
			
			removeEventListener(Event.ADDED_TO_STAGE,onAdded2Stage);
			super.destroy();
		}

		public function get bagCellDragHander():BagCellDragHandle
		{
			return _bagCellDragHander;
		}

		public function get bagCellClickHandle():BagCellClickHandle
		{
			return _bagCellClickHandle;
		}

	}
}