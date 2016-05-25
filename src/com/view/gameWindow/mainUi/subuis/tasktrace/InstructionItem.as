package com.view.gameWindow.mainUi.subuis.tasktrace
{
	import com.model.business.fileService.UrlSwfLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlSwfLoaderReceiver;
	import com.model.configData.cfgdata.TaskCfgData;
	import com.model.consts.DungeonConst;
	import com.model.consts.FontFamily;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelTab;
	import com.view.gameWindow.panel.panels.dungeon.DgnDataManager;
	import com.view.gameWindow.panel.panels.expStone.ExpStoneDataManager;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.mall.constant.MallTabType;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	import com.view.gameWindow.panel.panels.trailer.TrailerData;
	import com.view.gameWindow.panel.panels.trailer.TrailerDataManager;
	import com.view.gameWindow.scene.GameFlyManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author wqhk
	 * 2014-11-15
	 */
	public class InstructionItem extends Sprite implements IUrlSwfLoaderReceiver
	{
		public static const HEIGHT:int = 22;
		private var txt:TextField;
		private var numTxt:TextField;
		private var _type:int;
		private var _isFly:Boolean;
		private var _icon:Sprite;
		private var _height:Number;
		
		public function get type():int
		{
			return _type;
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		public function InstructionItem(type:int,head:String,name:String,link:String,isFly:Boolean)
		{
			super();
			
			_height = HEIGHT;
			
			_type = type;
			this.isFly = isFly;
			
			txt = new TextField();
			var defaultTextFormat:TextFormat = txt.defaultTextFormat;
			defaultTextFormat.font = FontFamily.FONT_NAME;
			txt.defaultTextFormat = defaultTextFormat;
			txt.setTextFormat(defaultTextFormat);
			txt.selectable = false;
			
			var value:String = HtmlUtils.createHtmlStr(0x00b0f0,"["+head+"]");
			value += HtmlUtils.createHtmlStr(0xffc000,name+" ");
			value += HtmlUtils.createHtmlStr(0x00ff00,link,12,false,2,FontFamily.FONT_NAME,true,"linkEvent");
			txt.htmlText = value;
						
			
			numTxt = new TextField();
			defaultTextFormat = numTxt.defaultTextFormat;
			defaultTextFormat.font = FontFamily.FONT_NAME;
			numTxt.defaultTextFormat = defaultTextFormat;
			numTxt.setTextFormat(defaultTextFormat);
			numTxt.selectable = false;
			numTxt.htmlText = HtmlUtils.createHtmlStr(0xbfbfbf,"0/0");
			
			txt.height = HEIGHT;
			txt.width = txt.textWidth + 5;
			addChild(txt);
			
			numTxt.height = HEIGHT;
			numTxt.x = txt.x + txt.width + 5;
			numTxt.width = numTxt.textWidth + 5;
			addChild(numTxt);
			
			txt.filters = [new GlowFilter(0,1,3,3,10)];
			numTxt.filters = [new GlowFilter(0,1,3,3,10)];
			
			txt.addEventListener(TextEvent.LINK,linkHandler);
			
			if(isFly)
			{
				_icon = new Sprite();
				_icon.buttonMode = true;
				_icon.addEventListener(MouseEvent.CLICK, cloudClickHandle, false, 0, true);

				var swfLoader:UrlSwfLoader = new UrlSwfLoader(this);//小飞鞋资源
				swfLoader.loadSwf(ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD + "common/flyShoe" + ResourcePathConstants.POSTFIX_SWF);
				
				updateFlyVisible();
				updateFlyPos();

				addChild(_icon);
			}
		}
		
		public function updateText(head:String,name:String,link:String):void
		{
			var value:String = HtmlUtils.createHtmlStr(0x00b0f0,"["+head+"]");
			value += HtmlUtils.createHtmlStr(0xffc000,name+" ");
			value += HtmlUtils.createHtmlStr(0x00ff00,link,12,false,2,FontFamily.FONT_NAME,true,"linkEvent");
			txt.htmlText = value;
			txt.height = HEIGHT;
			txt.width = txt.textWidth + 5;
			
			numTxt.height = HEIGHT;
			numTxt.x = txt.x + txt.width + 5;
			numTxt.width = numTxt.textWidth + 5;
		}
		
		private function updateFlyPos():void
		{
			if(isFly)
			{
				var rec:Rectangle = txt.getCharBoundaries(numTxt.text.length-1);
				_icon.x = numTxt.x + rec.x + rec.width;
				_icon.y = numTxt.y + rec.y - 10;  //为了保证小飞鞋居中对齐，
			}
		}
		
		public function updateFlyVisible():void
		{
			if(isFly)
			{
				_icon.visible = RoleDataManager.instance.isCanFly > 0 && FlyEffectMediator.instance.isDoFiy == false;
			}else
			{
				if (_icon)
				{
					_icon.visible = false;
				}
			}
		}
		
		private function linkHandler(e:Event):void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			e.stopPropagation();
			this.dispatchEvent(e);
		}
		
		private function cloudClickHandle(e:Event):void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			this.dispatchEvent(new Event("cloudClick"));
		}
		
		public var isVisibleChange:Boolean = false;
		
		public function setNum(num:int,maxNum:int):void
		{
			numTxt.htmlText = HtmlUtils.createHtmlStr(0xbfbfbf,num+"/"+maxNum);
			numTxt.width = numTxt.textWidth + 5;
			
			if(num >= maxNum)
			{
				if(visible)
				{
					visible = false;
					isVisibleChange = true;
				}
			}
			else
			{
				if(!visible)
				{
					visible = true;
					isVisibleChange = true;
				}
			}
			
			updateFlyPos();
		}
		
		public function setMaxNum(num:int,maxNum:int):void
		{
			numTxt.htmlText = HtmlUtils.createHtmlStr(0xbfbfbf,num+"/"+maxNum);
			numTxt.width = numTxt.textWidth + 5;
			
			updateFlyPos();
		}
		
		public static function linkHandler(type:int):void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			switch(type)
			{
				case 1:
//					Alert.warning(StringConst.PROMPT_PANEL_0007);
					PanelMediator.instance.openPanel(PanelConst.TYPE_MALL);
					var mall:IPanelTab = PanelMediator.instance.openedPanel(PanelConst.TYPE_MALL) as IPanelTab;
					if(mall)
					{
						mall.setTabIndex(MallTabType.TYPE_TICKET);
					}
					break;
				case 2:
					var trailerData:TrailerData = TrailerDataManager.getInstance().trailerData;
					var cfgData:TaskCfgData = TrailerDataManager.getInstance().getTasktrailerCfg();
					if(trailerData.state==TaskStates.TS_DOING||trailerData.state==TaskStates.TS_CAN_SUBMIT)
					{
						AutoJobManager.getInstance().setAutoTargetData(cfgData.end_npc,EntityTypes.ET_NPC);
					}else
					{
						AutoJobManager.getInstance().setAutoTargetData(cfgData.start_npc,EntityTypes.ET_NPC);
					}
					break;
//				case 3:
//					AutoSystem.instance.stopAuto();
//					var dgn:Object = DgnDataManager.instance.getDgnInfo(DungeonConst.FUNC_TYPE_NORMAL);
//					AutoJobManager.getInstance().setAutoTargetData(dgn.npcId,EntityTypes.ET_NPC);
//					break;
				case 4:
					PanelMediator.instance.openPanel(PanelConst.TYPE_DAILY);
					break;
				case 5:
					AutoSystem.instance.stopAuto();
					AutoJobManager.getInstance().setAutoTargetData(TOWER_NPC,EntityTypes.ET_NPC);
					break;
			}
		}
		
		public function isUnlock():Boolean
		{
			switch(type)
			{
				case 1:
					return GuideSystem.instance.isUnlock(UnlockFuncId.EXP_STONE) && ExpStoneDataManager.instance.type > 2;
					break;
				case 2:
					return GuideSystem.instance.isUnlock(UnlockFuncId.BODYGUARD_TASK);
					break;
				case 3:
					return false;// GuideSystem.instance.isUnlock(UnlockFuncId.DUNGEON_EQUIP);
					break;
				case 4:
					return GuideSystem.instance.isUnlock(UnlockFuncId.DAILY_VIT);
					break;
				case 5:
					return GuideSystem.instance.isUnlock(UnlockFuncId.DUNGEON_TOWER);
					break;
			}
			
			return false;
		}
		
		private static const TOWER_NPC:int = 10424;
		public static function cloudHandler(type:int):void
		{
			switch(type)
			{
				case 1:
					break;
				case 2:
					var cfgData:TaskCfgData = TrailerDataManager.getInstance().getTasktrailerCfg();
					if(cfgData==null)return;
					GameFlyManager.getInstance().flyToMapByNPC(cfgData.start_npc);
					break;
				case 3:
//					Alert.warning(StringConst.PROMPT_PANEL_0007);
					var dgn:Object = DgnDataManager.instance.getDgnInfo(DungeonConst.FUNC_TYPE_NORMAL);
					AutoJobManager.getInstance().setAutoTargetData(dgn.npcId,EntityTypes.ET_NPC);
					GameFlyManager.getInstance().flyToMapByNPC(dgn.npcId);
					break;
				case 4:
					Alert.warning(StringConst.PROMPT_PANEL_0007);
					break;
				case 5:
					GameFlyManager.getInstance().flyToMapByNPC(TOWER_NPC);
					break;
			}
		}
		
		public static function create(type:int):InstructionItem
		{
			var item:InstructionItem;
			switch(type)
			{
				case 1:
					item = new InstructionItem(type,StringConst.TIP_EXP,StringConst.INSTRUCTION_0,StringConst.TIP_ACQUIRE,false);
					break;
				case 2:
					item = new InstructionItem(type,StringConst.GOLD_COIN,"",StringConst.INSTRUCTION_1,true);
					break;
				case 3:
					item = new InstructionItem(type,StringConst.DUNGEON_PANEL_0013,"",StringConst.INSTRUCTION_2,true);
					break;
				case 4:
					item = new InstructionItem(type,StringConst.INCOME_0005,"",StringConst.INSTRUCTION_3,false);
					break;
				case 5:
					item = new InstructionItem(type,StringConst.TIP_EXP,"",StringConst.INSTRUCTION_4,true);
			}
			return item;
		}

		public function get isFly():Boolean
		{
			return _isFly;
		}

		public function set isFly(value:Boolean):void
		{
			_isFly = value;
		}

		public function swfReceive(url:String, swf:Sprite, info:Object):void
		{
			if (_icon && !_icon.contains(swf))
			{
				_icon.addChild(swf);
			}
		}

		public function swfProgress(url:String, progress:Number, info:Object):void
		{
		}

		public function swfError(url:String, info:Object):void
		{
		}
	}
}