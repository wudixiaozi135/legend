package com.view.gameWindow.mainUi.subuis.broadcast
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.BroadcastCfgData;
	import com.model.dataManager.TeleportDatamanager;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.mainUi.subuis.chatframe.ChatDataManager;
	import com.view.gameWindow.panel.panels.guideSystem.UICenter;
	import com.view.gameWindow.panel.panels.guideSystem.action.OpenPanelAction;
	import com.view.gameWindow.rollTip.McSystemTip;
	import com.view.gameWindow.scene.GameFlyManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.util.TimeUtils;
	import com.view.gameWindow.util.UtilText;
	import com.view.gameWindow.util.css.GameStyleSheet;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import mx.utils.StringUtil;

	public class SystemBroAdcast extends Sprite
	{

		private var marqueeText:TextField;

		private var broadcasted:Vector.<int>;

		private var skin:MovieClip;

		private var _cfg:BroadcastCfgData;

		public function SystemBroAdcast()
		{
		}
		
		public function init(layer:Sprite):void
		{
			skin = new McSystemTip();
			var rsrLoader:RsrLoader = new RsrLoader();
			rsrLoader.load(skin,ResourcePathConstants.IMAGE_ROLLTIP_FOLDER_LOAD);
			layer.addChild(this);
			this.addChild(skin);
			this.x=(layer.width-800)*0.5;
			initMarqueeText();
			broadcasted = new Vector.<int>();
			checkBroAdcast();
			removeBroadId();
			this.mouseEnabled=false;
		}
		
		private function removeBroadId():void
		{
			setTimeout(function ():void
			{
				broadcasted.length>0&&broadcasted.shift();
				removeBroadId();
			},60000);
		}
		
		private function initMarqueeText():void
		{
			skin.width=800;
			skin.mouseEnabled=skin.mouseChildren=false;
			marqueeText = UtilText.getText();
			marqueeText.wordWrap=false;
			marqueeText.styleSheet=GameStyleSheet.linkStyle;
			marqueeText.addEventListener(TextEvent.LINK,onClickLink);
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0xffffff);
			shape.graphics.drawRect(0,0,800,20);
			shape.graphics.endFill();
			marqueeText.x=800;
			marqueeText.y = 5;
			this.addChild(marqueeText);
			this.addChild(shape);
			marqueeText.mask=shape;
		}
		
		private function onClickLink(event:TextEvent):void
		{
			if(_cfg)
			{
				if(_cfg.link_type==5)
				{
					TeleportDatamanager.instance.setTargetEntity(_cfg.npc_id,EntityTypes.ET_NPC);
					GameFlyManager.getInstance().flyToMapByNPC(_cfg.npc_id);
				}else
				{
					new OpenPanelAction(UICenter.getUINameFromMenu(_cfg.link_content+"")).act();
				}
			}
		}
		
		private function checkBroAdcast():void
		{
			this.visible=false;
			
			var dic:Dictionary = ConfigDataManager.instance.broadcastCfgData();
			for each(var cfg:BroadcastCfgData in dic)
			{
				if(checkData(cfg)&&broadcasted.indexOf(cfg.id)==-1)
				{
					broadcasted.push(cfg.id);
					this.visible=true;
					broadcastShow(cfg);
					break;
				}
			}
			
			if(this.visible==false)
			{
				setTimeout(function ():void
				{
					checkBroAdcast();
				},30000);
			}
		}
		
		private function broadcastShow(cfg:BroadcastCfgData):void
		{
			this._cfg = cfg;
			var replaceStr:String = cfg.text.replace("|panel","<font color='#d4a460'><u><a href='event:on'>"+cfg.link_text+"</a></u></font>");
			replaceStr= replaceStr.replace("|npc","<font color='#d4a460'><u><a href='event:npc'>"+cfg.link_text+"</a></u></font>");
			var htmlStr:String = CfgDataParse.pareseDesToStr(replaceStr);
			marqueeText.x=800;
			marqueeText.htmlText=htmlStr;
			TweenMax.to(marqueeText,cfg.duration_show||5,{x:-marqueeText.width,ease:Linear.easeNone,onComplete:checkBroAdcast});
			
			/**很乱的一段引用*/
			var str:String = cfg.text.replace("panel","").replace("npc","");
			if(_cfg.link_type==4)
			{
				ChatDataManager.instance.sendSystemNotice("<p>" +  StringUtil.substitute(CfgDataParse.pareseDesToXml(str),"","")
					+ "<link event='openPanel' data='" +cfg.link_content  + "|0|0" + "' color='0x00ff00'>" + cfg.link_text+ "</link>" + "</p>");
			}else
			{
				ChatDataManager.instance.sendSystemNotice("<p>" +  StringUtil.substitute(CfgDataParse.pareseDesToXml(str),"","")
					+ "<link event='flyNPC' data='"+_cfg.npc_id+ "</link>" + "</p>");
			}
		}
		
		private function checkData(cfg:BroadcastCfgData):Boolean
		{
			if(!TimeUtils.beyondTime(cfg.begin_day.toString(),cfg.end_day.toString()))
			{
				if(!TimeUtils.checkTimeInterval(cfg.start_time,cfg.duration,cfg.interval))
				{
					return true;
				}
			}
			return false;
		}
		
		public function resize(newWidth:int, newHeight:int):void
		{
			this.x=(newWidth-800)*0.5;
		}
	}
}