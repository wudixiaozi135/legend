package com.view.gameWindow.panel.panels.expStone
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.FontFamily;
	import com.model.consts.ItemType;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.common.LinkButton;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.friend.McExpStonePanel;
	import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.cell.IconCellEx;
	
	import flash.events.MouseEvent;
	
	import mx.utils.StringUtil;
	
	public class AlertExpStone extends PanelBase
	{
		private var mc:McExpStonePanel;
		private var dataMgr:ExpStoneDataManager;
		private var storage:int;
		private var slot:int;
		private var icon:IconCellEx;
		private var vipButton:LinkButton;
		
		public function AlertExpStone()
		{
			super();
			dataMgr = ExpStoneDataManager.instance;
		}
		
		private function showUI(data:ItemCfgData,num:int,sum:int):void
		{
			if(data)
			{
				setExp(ExpStoneData.getMaxExp(data),ExpStoneData.getMaxExp(data),ExpStoneData.getGold(data));
				setNum(num,sum);
				setItem(data);
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
		
		public function setItem(item:ItemCfgData):void
		{
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
					icon.destroy();
				}
			}
			
		}
		
		override public function update(proc:int=0):void
		{
			 if(proc == GameServiceConstants.CM_GET_EXP_PANLE)
			 {
				 PanelMediator.instance.closePanel(PanelConst.TYPE_ALERT_EXP_STONE);
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
			
			InterObjCollector.instance.remove(mc.btn1);
			
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
			showUI(AlertExpStoneData.item,AlertExpStoneData.num,AlertExpStoneData.sum);
			addEventListener(MouseEvent.CLICK,clickHandler);	
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			super.addCallBack(rsrLoader);
			rsrLoader.addCallBack(mc.btn1,
				function():void
				{
					InterObjCollector.instance.add(mc.btn1);
				});
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			switch(e.target)
			{
				case mc.btn0:
					var isExpFull:Boolean = RoleDataManager.instance.isExpFull();
					if(isExpFull)
					{
						Alert.warning(StringConst.EXP_STONE_TIP16);
						return;
					}
					AlertExpStoneData.funcBtn();
					break;
				case mc.btn1:
					isExpFull = RoleDataManager.instance.isExpFull();
					if(isExpFull)
					{
						Alert.warning(StringConst.EXP_STONE_TIP16);
						return;
					}
					AlertExpStoneData.funcBtn2();
					break;
				case mc.btnClose:
					PanelMediator.instance.closePanel(PanelConst.TYPE_ALERT_EXP_STONE);
					break;
				case vipButton:
					PanelMediator.instance.openPanel(PanelConst.TYPE_VIP);
					break;
			}
		}
	}
}