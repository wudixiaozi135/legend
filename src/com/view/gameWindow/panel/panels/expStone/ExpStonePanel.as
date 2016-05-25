package com.view.gameWindow.panel.panels.expStone
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.ConstStorage;
	import com.model.consts.FontFamily;
	import com.model.consts.ItemType;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.common.LinkButton;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.friend.McExpStonePanel;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.cell.IconCellEx;
	
	import flash.events.MouseEvent;
	
	import mx.utils.StringUtil;
	
	
	/**
	 * @author wqhk
	 * 2014-11-13
	 */
	public class ExpStonePanel extends PanelBase implements IExpStonePanel
	{
		private var mc:McExpStonePanel;
		private var dataMgr:ExpStoneDataManager;
		private var storage:int;
		private var slot:int;
		private var icon:IconCellEx;
		private var vipButton:LinkButton;
		
		public function ExpStonePanel()
		{
			super();
			dataMgr = ExpStoneDataManager.instance;
		}
		
		public function setData(storage:int,slot:int):void
		{
			this.storage = storage;
			this.slot = slot;
			
			dataMgr.requestQueryInfo(1,storage,slot);
		}
		
		private function updateUI():void
		{
			var data:ExpStoneData = dataMgr.getExpInfo(storage,slot);
			if(data)
			{
				setExp(data.exp,data.maxExp,data.VIP);
				setNum(dataMgr.numUse,dataMgr.numTotal);
				setItem(data.item?data.item.id:0);
			}
		}
		
		public function setExp(value:int,total:int,gold:int):void
		{
			mc.expTxt.text = value + "/" + total;
			
			mc.txt0.text = StringUtil.substitute(StringConst.EXP_STONE_TIP0,total);
			mc.txt1.text = StringUtil.substitute(StringConst.EXP_STONE_TIP1,total*2,gold);
		}
		
		public function setNum(value:int,total:int):void
		{
			mc.txt3.text = value + "/" + total;
		}
		
		public function setItem(itemId:int):void
		{
			var item:ItemCfgData = ConfigDataManager.instance.itemCfgData(itemId);
			
			if(item)
			{
				mc.titleTxt.text = item.name;
				if(icon==null)
				{
					icon=new IconCellEx(mc.iconPos,0,0,60,60);
					ToolTipManager.getInstance().attach(icon);
				}
				if(icon.id==item.id)return;
				icon.setNull();
				icon.id=item.id;
				icon.url = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD+item.icon+ResourcePathConstants.POSTFIX_PNG;
				icon.setTipType(ToolTipConst.ITEM_BASE_TIP);
				icon.setTipData(item);
				icon.loadEffect(ItemType.getEffectUrlByQuality(item.quality));
				if(item.type == ItemType.EXP_STONE_A)
				{
					mc.txt2.text = StringConst.EXP_STONE_TIP4;
				}
				else if(item.type == ItemType.EXP_STONE)
				{
					mc.txt2.text = StringConst.EXP_STONE_TIP40;
				}
			}
			else
			{
				mc.titleTxt.text = "";
				if(icon)
				{
					icon.setNull();
				}
			}
				
		}
		
		override public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_ALL_EXP_YU_INFO||proc == GameServiceConstants.SM_DAILY_USE_EXPYU_NUM)
			{
				updateUI();
			}
			if(proc == GameServiceConstants.CM_USE_EXPYU)
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_EXP_STONE);
			}
		}
		
		override public function destroy():void
		{
			if(vipButton)
			{
				ToolTipManager.getInstance().detach(vipButton);
				vipButton.destroy();
				vipButton = null;
			}
			if(icon)
			{
				ToolTipManager.getInstance().detach(icon);
				icon.setNull();
				icon = null;
			}
			dataMgr.detach(this);
			dataMgr = null;
			super.destroy();
		}
		
		override protected function initSkin():void
		{
			mc = new McExpStonePanel();
			_skin = mc;
			setTitleBar(mc.mcTitleBar);
			addChild(mc);
			
			mc.btnTxt0.mouseEnabled = false;
			mc.btnTxt0.text = StringConst.EXP_STONE_TIP2;
			
			mc.btnTxt1.mouseEnabled = false;
			mc.btnTxt1.text = StringConst.EXP_STONE_TIP3;
			
			vipButton = new LinkButton();
			vipButton.label = HtmlUtils.createHtmlStr(0xFFE1AA,StringConst.EXP_STONE_TIP12,12,false,2,FontFamily.FONT_NAME,true);
			mc.vipPos.addChild(vipButton);
			var tipvo:TipVO = new TipVO();
			tipvo.tipType = ToolTipConst.TEXT_TIP;
			tipvo.tipData = dataMgr.getVipTipText;
			ToolTipManager.getInstance().hashTipInfo(vipButton,tipvo);
			ToolTipManager.getInstance().attach(vipButton);
			
			dataMgr.attach(this);
			
			addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			switch(e.target)
			{
				case mc.btn0:
					dataMgr.requestUseStone(storage,slot,1);
					break;
				case mc.btn1:
					dataMgr.requestUseStone(storage,slot,2);
					break;
				case mc.btnClose:
					PanelMediator.instance.closePanel(PanelConst.TYPE_EXP_STONE);
					break;
				case vipButton:
					PanelMediator.instance.openPanel(PanelConst.TYPE_VIP);
					break;
			}
		}
		
		public static function show(storage:int,slot:int):void
		{
			if(storage!=ConstStorage.ST_CHR_BAG)
			{
				Alert.warning(StringConst.EXP_STONE_TIP7);
				return;
			}
			
			var dataMgr:ExpStoneDataManager = ExpStoneDataManager.instance;
			
			var data:ExpStoneData = dataMgr.getExpInfo(storage,slot);
			
			if(!data || data.exp<data.maxExp)
			{
				Alert.warning(StringConst.EXP_STONE_TIP5);
				return;
			}
			
			PanelMediator.instance.openPanel(PanelConst.TYPE_EXP_STONE);
			var panel:IExpStonePanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_EXP_STONE) as IExpStonePanel;
			
			if(panel)
			{
				panel.setData(storage,slot);
			}
		}
	}
}