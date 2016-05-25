package com.view.gameWindow.panel.panels.thingNew.itemNew
{
    import com.greensock.TweenMax;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.ItemCfgData;
    import com.model.configData.cfgdata.ItemTypeCfgData;
    import com.model.consts.ItemType;
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.HighlightEffectManager;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.bag.BagData;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.batchUse.PanelBatchUseData;
    import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
    import com.view.gameWindow.panel.panels.guideSystem.UICenter;
    import com.view.gameWindow.panel.panels.guideSystem.action.OpenPanelAction;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.skill.SkillDataManager;
    import com.view.gameWindow.panel.panels.thingNew.McItemNew;
    import com.view.gameWindow.panel.panels.thingNew.ThingNewData;
    import com.view.gameWindow.scene.entity.EntityLayerManager;
    import com.view.gameWindow.scene.entity.constants.EntityTypes;
    import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.propertyParse.CfgDataParse;
    import com.view.newMir.NewMirMediator;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;

    /**
	 * 获得新道具提示面板类
	 * @author Administrator
	 */	
	public class PanelItemNew extends PanelBase implements IPanelItemNew
	{
		private var _cell:ItemCell;
		private var _bagData:BagData;
		private var _timerId:int,_delay:int = 5000;
		private var _btnHight:HighlightEffectManager;
		public function PanelItemNew()
		{
			super();
		}
		override protected function initSkin():void
		{
			var mc:McItemNew = new McItemNew();
			_skin = mc;
			addChild(_skin);
			setTitleBar(mc.mcDrag);
			_btnHight = new HighlightEffectManager();
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var mc:McItemNew = _skin as McItemNew;
			rsrLoader.addCallBack(mc.btnDo,function (mc:MovieClip):void
			{
				InterObjCollector.instance.add(mc);
				_btnHight.show(mc, mc);
			});
		}
		
		override protected function initData():void
		{
			var mc:McItemNew = _skin as McItemNew;
			//
			mc.title.mouseEnabled = false;
			mc.title.text = StringConst.THING_NEW_PANEL_0005;

			_bagData = ThingNewData.bagData;
			var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(_bagData.id);
			_cell = new ItemCell(mc.mc);
			_cell.refreshData(itemCfgData.id);
			//
			var color:int = ItemType.getColorByQuality(itemCfgData.quality);
			mc.txtName.htmlText = HtmlUtils.createHtmlStr(color, itemCfgData.name, 15);
			ToolTipManager.getInstance().attach(_cell);
			//
			var pareseDes:Array = CfgDataParse.pareseDes(itemCfgData.desc_short),htmlText:String = "";
			var i:int,l:int = pareseDes.length;
			for(i=0;i<l;i++)
			{
				htmlText += pareseDes[i];
			}
			mc.txt.htmlText = htmlText;
			//
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			//
			_timerId = setTimeout(dealDo,_delay);
			handlerEffect();
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var mc:McItemNew = _skin as McItemNew;
			switch(event.target)
			{
				case mc.btnDo:
					dealDo();
					break;
			}
		}

		private function dealDo():void
		{
			clearTimeout(_timerId);
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			if (firstPlayer.isPalsy)
			{
				closeHandler();
				return;
			}
            var bagData:BagData = null;
            if (_bagData)
            {
                bagData = BagDataManager.instance.getBagDataById(_bagData.id, _bagData.type, _bagData.bornSid);
            }
			if(!bagData)
			{
				closeHandler();
				return;
			}
			var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(bagData.id);
			if(!itemCfgData)
			{
				closeHandler();
				return;
			}
			var job:int = RoleDataManager.instance.job;
			if (itemCfgData.job && itemCfgData.job != job)//职业不对
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0013);
				closeHandler();
				return;
			}
			var sex:int = RoleDataManager.instance.sex;
			if (itemCfgData.entity && itemCfgData.entity != EntityTypes.ET_PLAYER)//使用者不对
			{
				var replace:String = StringConst.BAG_PANEL_0016.replace("&x", StringConst.BAG_PANEL_0017).replace("&y", itemCfgData.name);
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, replace);
				closeHandler();
				return;
			}
			var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(itemCfgData.reincarn,itemCfgData.level);
			if (!checkReincarnLevel)//等级不够
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0015);
				closeHandler();
				return;
			}
			if(itemCfgData.type == ItemType.SKILL_BOOK || itemCfgData.type == ItemType.HERO_SKILL_BOOK)
			{
				SkillDataManager.instance.useSkillBook(bagData.id,bagData.slot);
				closeHandler();
				return;
			}
			var itemTypeCfgData:ItemTypeCfgData = ConfigDataManager.instance.itemTypeCfgData(itemCfgData.type);
			if(itemTypeCfgData && itemTypeCfgData.canBatch && bagData.count > 1)
			{
				dealBatch(bagData);
				closeHandler();
				return;
			}
//			if(itemTypeCfgData.panel)
//			{
//				return;
//			}
			if(itemTypeCfgData.batch == ItemTypeCfgData.CantUse)
			{
				if(itemTypeCfgData.panel>0)
				{
					new OpenPanelAction(UICenter.getUINameFromMenu(itemTypeCfgData.panel+""),itemTypeCfgData.panel_param-1).act();
				}else
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.BAG_PANEL_0026);
				}
				return;
			}
			sendData(bagData.slot);
			var str:String = ItemType.itemTypeName(itemCfgData.type);
			if(str != "")
			{
				if(itemCfgData.type == ItemType.IT_ENERGY || itemCfgData.type == ItemType.IT_ENERGY2)
				{
					str = str.replace("xx",itemCfgData.effect).replace("xx",itemCfgData.effect); 
				}
				else
				{
					str = str + itemCfgData.effect;
				}
				RollTipMediator.instance.showRollTip(RollTipType.REWARD,str);
			}
			closeHandler();
		}
		
		private function dealBatch(bagData:BagData):void
		{
			PanelBatchUseData.id = bagData.id;
			PanelBatchUseData.type = bagData.type;
			PanelBatchUseData.storage = bagData.storageType;
			PanelBatchUseData.slot = bagData.slot;
			PanelMediator.instance.openPanel(PanelConst.TYPE_BATCH);
		}
		
		private function sendData(slot:int):void
		{
			BagDataManager.instance.sendUseData(slot);
		}
		
		override public function setPostion():void
		{
			var rect:Rectangle = getPanelRect();
			var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
			var newX:int = int((newMirMediator.width - rect.width));
			var newY:int = int((newMirMediator.height + rect.height - 10));
			x != newX ? x = newX : null;
			y != newY ? y = newY : null;
		}
		
		override public function resetPosInParent():void
		{
			super.resetPosInParent();
			setPostion();
		}

		private function handlerEffect():void
		{
			var rect:Rectangle = getPanelRect();
			var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
			var newX:int = int(newMirMediator.width - rect.width) - 50;
			var newY:int = int(newMirMediator.height - rect.height) - 100;

			TweenMax.fromTo(this, 2, {alpha: 0}, {
				x: newX, y: newY, alpha: 1, onComplete: function ():void
				{
					TweenMax.killTweensOf(this);
				}
			});
		}

		private function closeHandler():void
		{
			var rect:Rectangle = getPanelRect();
			var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
			var newX:int = int(newMirMediator.width + rect.width);

			alpha = 1;
            TweenMax.to(this, 3, {
				x: newX, alpha: 0, onComplete: function ():void
				{
					TweenMax.killTweensOf(this);
					PanelMediator.instance.closePanel(PanelConst.TYPE_ITEM_NEW, index);
				}
			});
		}
		
		override public function destroy():void
		{
			if(_bagData)
			{
				_bagData = null;
			}
			if(_cell)
			{
				ToolTipManager.getInstance().detach(_cell);
				_cell.destroy();
				_cell = null;
			}
			if(_skin)
			{
				if (_btnHight)
				{
					_btnHight.hide(_skin.btnDo);
					_btnHight = null;
				}
				_skin.removeEventListener(MouseEvent.CLICK,onClick);
				InterObjCollector.instance.remove(_skin.btnDo);
			}
			
			super.destroy();
		}
	}
}