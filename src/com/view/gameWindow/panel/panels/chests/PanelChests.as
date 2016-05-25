package com.view.gameWindow.panel.panels.chests
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.ItemType;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.prompt.McPanelChests;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mx.utils.StringUtil;

	public class PanelChests extends PanelBase
	{
		private var _mcChests:McPanelChests;
		private var _name:String;
		private var _effect:String;

		private var spilteArr:Array;
		
		public function PanelChests()
		{
			_skin = new McPanelChests();
			_mcChests = _skin as McPanelChests;
			addChild(_skin);
		}
		
		override protected function initSkin():void
		{
			_name = ChestsData.itemCfg.name;
			_effect = ChestsData.itemCfg.effect;
			setData(ChestsData.itemCfg.id);
			initText();
			_mcChests.addEventListener(MouseEvent.CLICK,clickHandle);
			setTitleBar(_mcChests.mcTitleBar);
			ChestsDataManager.instance.attach(this);
			BagDataManager.instance.attach(this);
		}
		
		protected function clickHandle(event:MouseEvent):void
		{
			if(event.target == _mcChests.btnClose)
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_CHESTS);
			}
			else if(event.target == _mcChests.btnOne)
			{
				if(BagDataManager.instance.coinBind + BagDataManager.instance.coinUnBind < spilteArr[0])
				{
					Alert.warning(StringConst.CHESTS_0005);
					return;
				}
				BagDataManager.instance.dealItemUse(ChestsData.itemCfg.id);
			}
		}
		
		public function setData(itemId:int):void
		{	
			ChestsDataManager.instance.requestChest(itemId);
		}
		
		private function initText():void
		{
			var dic:Dictionary = ConfigDataManager.instance.itemGiftRandomCfg(ChestsData.itemCfg.id);
			var index:int = 0;
			var str:String = "";
			spilteArr = _effect.split(":");
			_mcChests.txtName.text = _name;
			_mcChests.txtCost.htmlText = StringUtil.substitute(StringConst.CHESTS_0002,HtmlUtils.createHtmlStr(0x00ff00,_name));
			_mcChests.txtNum.htmlText = StringUtil.substitute(StringConst.CHESTS_0003,HtmlUtils.createHtmlStr(0x00ff00,_name));
			_mcChests.txtValue_0.text = spilteArr[0];
			_mcChests.txtBtn.text = StringConst.CHESTS_0004;
			_mcChests.txtBtn.mouseEnabled = false;
			_mcChests.txtName.mouseEnabled= false;
			for(var i:String in dic)
			{
				index ++;
				if(index > 6)
				{
					break;
				}
				else
				{
					var itemCfg:ItemCfgData = ConfigDataManager.instance.itemCfgData(int(i));
					str += "             " + HtmlUtils.createHtmlStr(ItemType.getColorByQuality(itemCfg.quality),itemCfg.name + "\n");
				}
			}
			_mcChests.txtContent.htmlText = StringConst.CHESTS_0001 + str;
		}		
		
		override public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_QUERY_BAOXIANG)
			{
				_mcChests.txtValue_1.text = ChestsDataManager.instance._num + "/" + spilteArr[1];
			}
			else if(proc == GameServiceConstants.CM_USE_ITEM)
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_CHESTS);
			}
			super.update(proc);
		}
		
		
		public static function show(itemCfg:ItemCfgData):void
		{
			ChestsData.itemCfg = itemCfg;
			PanelMediator.instance.openPanel(PanelConst.TYPE_CHESTS);
		}
		
		override public function destroy():void
		{
			ChestsDataManager.instance.detach(this);
			BagDataManager.instance.detach(this);
			if(_mcChests)
			{
				_mcChests.removeEventListener(MouseEvent.CLICK,clickHandle);
				_mcChests = null;
			}
			spilteArr = null;
			super.destroy();
		}
		
	}
}