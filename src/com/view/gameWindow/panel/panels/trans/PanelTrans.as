package com.view.gameWindow.panel.panels.trans
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapCfgData;
	import com.model.configData.cfgdata.MapRegionCfgData;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.model.configData.cfgdata.NpcTeleportCfgData;
	import com.model.consts.FontFamily;
	import com.model.consts.StringConst;
	import com.model.consts.TranConst;
	import com.model.dataManager.TeleportDatamanager;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
	import com.view.gameWindow.panel.panels.npcfunc.PanelNpcFuncData;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.css.GameStyleSheet;
	
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	/**
	 * 传送面板类
	 * @author Administrator
	 */	
	public class PanelTrans extends PanelBase implements IPanelTrans
	{
		private var _mouseEvent:PanelTransMouseEvent;
		private var _dic:Dictionary;
		
		public function PanelTrans()
		{
			super();
			TeleportDatamanager.instance.attach(this);
		}
		
		override protected function initSkin():void
		{
			_skin = new McPanelTrans();
			addChild(_skin);
			setTitleBar((_skin as McPanelTrans).mcTitleBar);
			_mouseEvent = new PanelTransMouseEvent();
			_mouseEvent.addEvent(_skin as McPanelTrans);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			
		}
		
		override public function update(proc:int = 0):void
		{
			
		}	
		
		override protected function initData():void
		{
			var npcId:int = PanelNpcFuncData.npcId;
			var npcTeleportCfgData:NpcTeleportCfgData;
			var mapRegionCfgData:MapRegionCfgData;
			var txt:TextField;
			var vectorLength:int;
			var skin:McPanelTrans = _skin as McPanelTrans;
			var vectorSafe:Vector.<NpcTeleportCfgData> = new Vector.<NpcTeleportCfgData>();
			var vectorDanger:Vector.<NpcTeleportCfgData> = new Vector.<NpcTeleportCfgData>();
			var vectorChallenge:Vector.<NpcTeleportCfgData> = new Vector.<NpcTeleportCfgData>();
			var vectorOnHook:Vector.<NpcTeleportCfgData> = new Vector.<NpcTeleportCfgData>();
			var npcCfgData:NpcCfgData = ConfigDataManager.instance.npcCfgData(npcId);
			var npcTeleportDic:Dictionary = ConfigDataManager.instance.npcTeleportCfgDatas(npcId);
			_dic = new Dictionary();
			setTextMouseEnabled(skin);
			for each(npcTeleportCfgData in npcTeleportDic)
			{
				switch(npcTeleportCfgData.type)
				{
					case TranConst.TRANS_SAFE:
						vectorSafe.push(npcTeleportCfgData);
						vectorSafe.sort(sortTeleportOrder);
						break;
					case TranConst.TRANS_DANGER:
						vectorDanger.push(npcTeleportCfgData);
						vectorDanger.sort(sortTeleportOrder);
						break;
					case TranConst.TRANS_CHALLENGE:
						vectorChallenge.push(npcTeleportCfgData);
						vectorChallenge.sort(sortTeleportOrder);
						break;		
					case TranConst.TRANS_ON_HOOK:
						vectorOnHook.push(npcTeleportCfgData);
						break;		
				}
			}
			//
			if(vectorSafe.length !=0)
			{
				var txtArea:TextField = skin.safe.txtArea as TextField;
				txtArea.text = StringConst.TRANS_PANEL_0101;
				if(vectorSafe.length > 8)
				{
					vectorLength = 8;
					skin.danger.y = skin.safe.y + 90;
				}
				else
				{
					vectorLength = vectorSafe.length;
					skin.danger.y =  skin.safe.y + 28 + ((vectorLength/4)+1)*22 + 10;
				}
				for(var i:int = 0;i<vectorLength;i++)
				{
					mapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(vectorSafe[i].region_to);
					if(!mapRegionCfgData)
					{
						continue;
					}
					txt = skin.safe.getChildByName("safeTxt_0"+String(i)) as TextField;
					//
					InterObjCollector.instance.add(txt,PanelConst.TYPE_TRANS);
					txt.htmlText = HtmlUtils.createHtmlStr(txt.textColor,mapRegionCfgData.name,12,false,2,FontFamily.FONT_NAME,true);
					txt.mouseEnabled = true;
					txt.styleSheet = GameStyleSheet.linkStyle1;
					_dic["1"+txt.text] = vectorSafe[i].id;
				}
			}
			else
			{
				skin.danger.x = skin.safe.x;
				skin.danger.y = skin.safe.y;
				skin.safe.visible = false;
			}
			//
			if(vectorDanger.length !=0)
			{
				txtArea = skin.danger.txtArea as TextField;
				txtArea.text = StringConst.TRANS_PANEL_0102;
				skin.danger.dangerTxt_00.visible = false;
				vectorLength = vectorDanger.length;
				for(var j:int = 0;j<vectorLength;j++)
				{
					mapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(vectorDanger[j].region_to);
					var mapCfg:MapCfgData = ConfigDataManager.instance.mapCfgData(mapRegionCfgData.map_id);
					txt = cloneTxt();
					txt.x = 6 + (j%2)*163;
					txt.y = 36 +int(j/2)*25;
					skin.danger.addChild(txt);
					InterObjCollector.instance.add(txt,PanelConst.TYPE_TRANS);
					var strLimit:String = mapCfg.reincarn ? "(" + mapCfg.reincarn + StringConst.DUNGEON_PANEL_0031 + ")" : 
						(mapCfg.level ? "(" + mapCfg.level + StringConst.DUNGEON_PANEL_0028 + ")" : "");
					var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(mapCfg.reincarn,mapCfg.level);
					txt.textColor = checkReincarnLevel ? 0x00ff00 : 0xff0000;
					txt.htmlText = HtmlUtils.createHtmlStr(txt.textColor,mapRegionCfgData.name + strLimit+"",12,false,2,FontFamily.FONT_NAME,true);
					txt.mouseEnabled = true;
					txt.styleSheet = GameStyleSheet.linkStyle1;
					_dic["2"+txt.text] = vectorDanger[j].id;
				}
				skin.challenge.y =  skin.danger.y + skin.danger.height;
			}
			else
			{
				skin.challenge.x = skin.danger.x;
				skin.challenge.y = skin.danger.y;
				skin.danger.visible = false;
			}
			//
			if(vectorChallenge.length !=0)
			{
				txtArea = skin.challenge.txtArea as TextField;
				txtArea.text = StringConst.TRANS_PANEL_0103;
				if(vectorChallenge.length > 6)
				{
					vectorLength = 6;
				}
				else
				{
					vectorLength = vectorChallenge.length;
				}
				for(var k:int = 0;k<vectorLength;k++)
				{
					mapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(vectorChallenge[k].region_to);
					txt = skin.challenge.getChildByName("challengeTxt_0"+String(k)) as TextField;
					//
					InterObjCollector.instance.add(txt,PanelConst.TYPE_TRANS,new Point(2,2));
					txt.htmlText = HtmlUtils.createHtmlStr(txt.textColor,mapRegionCfgData.name,12,false,2,FontFamily.FONT_NAME,true);
					txt.mouseEnabled = true;
					txt.styleSheet = GameStyleSheet.linkStyle1;
					_dic["3"+txt.text] = vectorChallenge[k].id;
				}
			}
			else
			{
				skin.onHook.x = skin.challenge.x;
				skin.onHook.y = skin.challenge.y;
				skin.challenge.visible = false;
			}
			//
			if(vectorOnHook.length != 0)
			{
				txtArea = skin.onHook.txtArea as TextField;
				txtArea.text = StringConst.TRANS_PANEL_0104;
				skin.onHook.y =  skin.challenge.y + 28
				var txt0:TextField = skin.onHook.txt0 as TextField;
				txt0.htmlText = HtmlUtils.createHtmlStr(txt0.textColor,StringConst.INSTRUCTION_8,12,false,2,FontFamily.FONT_NAME,true);
				txt0.mouseEnabled = true;
				txt0.styleSheet = GameStyleSheet.linkStyle1;
				var txt1:TextField = skin.onHook.txt1 as TextField;
				txt1.htmlText = HtmlUtils.createHtmlStr(txt1.textColor,StringConst.INSTRUCTION_13,12,false,2,FontFamily.FONT_NAME,true);
				txt1.mouseEnabled = true;
				txt1.styleSheet = GameStyleSheet.linkStyle1;
			}
			else
			{
				skin.onHook.visible = false;
			}
			//
			if(npcCfgData)
			{
				skin.txtNpcName.text = npcCfgData.name;
				/*skin.txtDialog.text = npcCfgData.default_dialog;*/
			}
		}
		
		private function cloneTxt():TextField
		{
			var txt:TextField = _skin.danger.dangerTxt_00;
			var textField:TextField = new TextField();
			var defaultTextFormat:TextFormat = txt.defaultTextFormat;
			textField.defaultTextFormat = defaultTextFormat;
			textField.setTextFormat(defaultTextFormat);
			textField.autoSize = txt.autoSize;
			textField.filters = txt.filters;
			textField.height = txt.height;
			textField.width = txt.width;
			textField.multiline = txt.multiline;
			textField.wordWrap = txt.wordWrap;
			textField.textColor = txt.textColor;
			textField.selectable = txt.selectable;
			return textField;
		}
		
		private function setTextMouseEnabled(mc:McPanelTrans):void
		{
			var i:int;
			for(i = 0;i<mc.safe.numChildren;i++)
			{
				if(mc.safe.getChildAt(i) is TextField)
				{
					(mc.safe.getChildAt(i) as TextField).mouseEnabled = false;
				}
			}
			for(i = 0;i<mc.danger.numChildren;i++)
			{
				if(mc.danger.getChildAt(i) is TextField)
				{
					(mc.danger.getChildAt(i) as TextField).mouseEnabled = false;
				}
			}
			for(i = 0;i<mc.challenge.numChildren;i++)
			{
				if(mc.challenge.getChildAt(i) is TextField)
				{
					(mc.challenge.getChildAt(i) as TextField).mouseEnabled = false;
				}
			}
			for(i = 0;i<mc.onHook.numChildren;i++)
			{
				if(mc.onHook.getChildAt(i) is TextField)
				{
					(mc.onHook.getChildAt(i) as TextField).mouseEnabled = false;
				}
			}
		}
		/**
		 *传送文本的顺序 
		 * @param a
		 * @param b
		 * @return 
		 */		
		private function sortTeleportOrder(a:NpcTeleportCfgData,b:NpcTeleportCfgData):int
		{
			if(a.order < b.order)
			{
				return -1;
			}
			else if(a.order > b.order)
			{
				return 1;
			}
			return 1;
		}
		
		public function get dic():Dictionary
		{
			return _dic;
		}
		
		override public function destroy():void
		{
			InterObjCollector.instance.removeByGroupId(PanelConst.TYPE_TRANS);
			TeleportDatamanager.instance.detach(this);
			if(_mouseEvent)
			{
				_mouseEvent.destoryEvent();
				_mouseEvent = null;
			}
			super.destroy();
		}
	}
}