package com.view.gameWindow.panel.panels.npcfunc
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.task.npcfunc.NpcFuncItem;
	import com.view.gameWindow.panel.panels.task.npcfunc.NpcFuncs;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	/**
	 * NPC功能面板类
	 * @author Administrator
	 */	
	public class PanelNpcFunc extends PanelBase implements IPanelNpcFunc
	{
		private var _txtItems:Dictionary;
		
		public function PanelNpcFunc()
		{
			super();
			_txtItems = new Dictionary();
		}
		
		override protected function initSkin():void
		{
			_skin = new McNpcFuncPanel();
			addChild(_skin);
			setTitleBar((_skin as McNpcFuncPanel).mcTitleBar);
			addEventListener(MouseEvent.CLICK,clickHandle);
		}
		
		protected function clickHandle(event:MouseEvent):void
		{
			if(event.target is MovieClip)
			{
				var mc:MovieClip = event.target as MovieClip;
				var _mcNpcFunc:McNpcFuncPanel = _skin as McNpcFuncPanel;
				if(mc == _mcNpcFunc.btnClose)
				{
					PanelMediator.instance.closePanel(PanelConst.TYPE_NPC_FUNC);
				}
			}
			else if(event.target is TextField)
			{
				var textField:TextField = event.target as TextField;
				var panelNpcFuncItem:PanelNpcFuncItem = _txtItems[textField] as PanelNpcFuncItem;
				if(panelNpcFuncItem)
				{
					panelNpcFuncItem.onClick();
				}
			}
		}
		
		override public function update(proc:int = 0):void
		{
			var npcId:int = PanelNpcFuncData.npcId;
			var npcCfgData:NpcCfgData = ConfigDataManager.instance.npcCfgData(npcId);
			if(npcCfgData)
			{
				var mcNpcFuncPanel:McNpcFuncPanel = _skin as McNpcFuncPanel;
				mcNpcFuncPanel.txtNpcName.text = npcCfgData.name;
				var textColor:uint = mcNpcFuncPanel.txtDialog.textColor;
				var leading:int = mcNpcFuncPanel.txtDialog.defaultTextFormat.leading as int;
				mcNpcFuncPanel.txtDialog.htmlText = CfgDataParse.pareseDesToStr(npcCfgData.default_dialog,textColor,leading);
				mcNpcFuncPanel.txtDialog.height = mcNpcFuncPanel.txtDialog.textHeight + 4;
				var theY:Number = mcNpcFuncPanel.txtDialog.y + mcNpcFuncPanel.txtDialog.height + 6;
				
				mcNpcFuncPanel.removeChild(mcNpcFuncPanel.txtFunc);
				var items:Vector.<NpcFuncItem>,item:NpcFuncItem,i:int,panelNpcFuncItem:PanelNpcFuncItem;
				items = PanelNpcFuncData.items;
				for each(item in items)
				{
					panelNpcFuncItem = new PanelNpcFuncItem(mcNpcFuncPanel);
					panelNpcFuncItem.y = (i++)*29+theY;
					mcNpcFuncPanel.addChild(panelNpcFuncItem);
					var funcName:String = NpcFuncs.funcName(item.func);
					panelNpcFuncItem.func = item.func;
					panelNpcFuncItem.txt.text = funcName;
					_txtItems[panelNpcFuncItem.txt] = panelNpcFuncItem;
				}
			}
		}
		
		override public function destroy():void
		{
			if(_txtItems)
			{
				var item:PanelNpcFuncItem;
				for each(item in _txtItems)
				{
					if(item.parent)
						item.parent.removeChild(item);
					item.destory();
				}
			}
			_txtItems = null;
			PanelNpcFuncData.npcId = 0;
			PanelNpcFuncData.items = null;
			removeEventListener(MouseEvent.CLICK,clickHandle);
			super.destroy();
		}
	}
}