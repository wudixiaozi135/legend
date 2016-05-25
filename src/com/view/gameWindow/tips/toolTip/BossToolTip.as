package com.view.gameWindow.tips.toolTip
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MonsterCfgData;
	import com.model.configData.cfgdata.WorldLevelMonsterCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.boss.BossModelHandle;
	import com.view.gameWindow.panel.panels.boss.classic.ClassicItemData;
	import com.view.gameWindow.panel.panels.welfare.OpenDayConsts;
	import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.TimeUtils;
	import com.view.gameWindow.util.TimerManager;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class BossToolTip extends BaseTip
	{
		public  const leftP:int = 200;
		
		public var mcContent:MovieClip;
		//private var _revive_time:int;
		private var _revive_time_text:TextField;
		private var _attInfoTxt:String;
		private var _bossMode:BossModelHandle;
		public function BossToolTip()
		{
			_skin = new BossTip();
			addChild(_skin);
			initView(_skin);
		}
		
		 
		override public function setData(obj:Object):void
		{
			_data = obj ;
			 
			var data:ClassicItemData =  obj as ClassicItemData;
			//_revive_time = _data.revive_time;
			 
			maxHeight += 10;
			setVariableProperty(data);
			height = maxHeight; 
		}
		
		private function setVariableProperty(data:ClassicItemData):void
		{
			 
		   // loadPic(ResourcePathConstants.IMAGE_BOSS_TIP_HEAD_LOAD+data.tip_url+".png");
			
			setTile(data.mapName,data.monsterCfgData.level);
			
			setBasic(data.monsterCfgData);
			setLeftAwards(data.reward_desc);
			setMapInfo(data.mapName);
			setFlushInfo(data.monsterCfgData);
			setAttInfo(data.hp,data.monsterCfgData.maxhp,data.killerSid,data.killerName,data.revive_time);
			setBossModel(data.monsterCfgData);
		}
		private function setTile(nameStr:String,lev:int):void
		{
			var htmlStr:String = HtmlUtils.createHtmlStr(0xffcc00,nameStr+'【'+lev.toString()+'】');
			// "<font color='#ffcc00'>"+nameStr+'【'+lev.toString()+'】'+"</font>";
			//var textF:TextField = addProperty(htmlStr,219,15);
			var textF:TextField = addProperty(htmlStr,175,17);
			//width = textF.x + textF.width +9;
			//height = textF.y + textF.height +10;
			//maxWidth += textF.textHeight;
		}
		
		private function setBossModel(data:MonsterCfgData):void
		{
			if(_bossMode)
				_bossMode.destroy();
			
			_bossMode = new BossModelHandle(_skin.bossContent);	
			_bossMode.data = data;
			_bossMode.changeModel();
			//_bossMode.setBitmapSize(150,150);
			maxHeight += 150;
			height = maxHeight;
		}
		override public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			super.urlBitmapDataReceive(url,bitmapData,info);
			_iconBmp.y = -25;
			_iconBmp.x = 0;
			_iconBmp.width = 147;
			_iconBmp.height = 157;
			maxHeight += _iconBmp.height;
			height = maxHeight; 
				
		}
		
		private function setBasic(data:MonsterCfgData):void
		{
			//StringConst.BOSS_PANEL_0008	
			var htmlStr:String =StringConst.BOSS_PANEL_0008+"\n"+StringConst.BOSS_PANEL_0009+"\n";
			htmlStr += StringConst.BOSS_PANEL_0010+data.maxhp.toString()+"\n";
			
			htmlStr += StringConst.BOSS_PANEL_0011+data.pattack_min.toString()+"-"+data.pattack_max.toString()+"\n";
			htmlStr += StringConst.BOSS_PANEL_0012+data.pdef_min.toString()+"-"+data.pdef_max.toString()+"\n";
			htmlStr += StringConst.BOSS_PANEL_0013+data.mdef_min.toString()+"-"+data.mdef_max.toString();
			htmlStr = HtmlUtils.createHtmlStr(0xffffff,htmlStr);
			var textF:TextField = addProperty(htmlStr,40,160);
			var format:TextFormat = new TextFormat();
			format.leading = 9;
			textF.setTextFormat(format);
			maxHeight += textF.textHeight+25;
			height = maxHeight ;  
		}
		
		private function setLeftAwards(data:String):void
		{
			var htmlStr:String = StringConst.BOSS_PANEL_0014+"\n";
			//var strArr:Array =  htmlStr.split("|");
			htmlStr += CfgDataParse.pareseDesToStr(data);
			//htmlStr = StringConst.BOSS_PANEL_0014+"\n"+"<font color='#00ff00'>"+strArr[0]+"</font>" +"<font color='ffcc00'>"+strArr[1]+"</font>";
			
			var textF:TextField = addProperty(htmlStr,leftP,40);
			var format:TextFormat = new TextFormat();
			format.leading = 7;
			textF.setTextFormat(format);
			textF.y = 105 - textF.height;
			var line:DelimiterLine = addSplitLine(leftP,105);
			line.width = 200;
			
		}
		
		private function setMapInfo(data:String):void
		{
			var htmlStr:String = StringConst.BOSS_PANEL_0015+"\n"+ "<font color='#ffffff'>"+data+"</font>";
			var textF:TextField = addProperty(htmlStr,leftP,120);
			
			var format:TextFormat = new TextFormat();
			format.leading = 7;
			textF.setTextFormat(format);
			var line:DelimiterLine = addSplitLine(leftP,165);
			line.width = 200;
		}
		
		private function setFlushInfo(cfgDt:MonsterCfgData):void
		{
			var time:int;
			var data:WorldLevelMonsterCfgData = ConfigDataManager.instance.worldLevelMonster(cfgDt.group_id);
			var openday:int = WelfareDataMannager.instance.openServiceDay+1;
			if(openday>data.min_open_day && openday<data.max_open_day)
				time = cfgDt.revive + data.revive_time;
			else
				time = cfgDt.revive;
			var htmlStr:String =StringConst.BOSS_PANEL_0017+"\n"+StringConst.BOSS_PANEL_0018.replace("XX",(int(time/60)).toString());;
			var textF:TextField = addProperty(htmlStr,leftP,180);
			var format:TextFormat = new TextFormat();
			format.leading = 7;
			textF.setTextFormat(format);
			var line:DelimiterLine = addSplitLine(leftP,225);
			line.width = 200;
		}
		
		private function setAttInfo(hp:int,maxhp:int,killerSid:int,killerName:String,revive_time:int):void
		{
			_attInfoTxt =  StringConst.BOSS_PANEL_0019 //+"   "+StringConst.BOSS_PANEL_0024;击杀状态
			var per:int = int(Math.floor((hp/maxhp)*100));
			var color:String = per == 100 ? '#00ff00':'#ff0000';
			
			if(per == 100)
			{
				_attInfoTxt += "<font color = '"+color+"'>" + StringConst.BOSS_PANEL_0026 +"</font>" +"\n";
			}
			else if(per>0)
			{
				_attInfoTxt += "<font color = '"+color+"'>" + StringConst.BOSS_PANEL_0024 + per.toString() +"%"+"</font>" +"\n";
			}
			else
			{
				_attInfoTxt += "<font color = '"+color+"'>" + StringConst.BOSS_PANEL_0027 + "</font>" +"\n";
			}
			var htmlStr:String = "";
			
			//htmlStr += StringConst.BOSS_PANEL_0020+"<font color =#ffcc00>"+ killerSid.toString()+ StringConst.BOSS_PANEL_0025 + killerName+"</font>" + StringConst.BOSS_PANEL_0021 +"\n";
			if(killerName !="" && revive_time > 0)
			{
				htmlStr += StringConst.BOSS_PANEL_0020 +"<font color ='#ffcc00'>"+ killerName+"</font>" + StringConst.BOSS_PANEL_0021 +"\n";
				htmlStr +=  StringConst.BOSS_PANEL_0022 + "<font color ='#ff0000'>"+ TimeUtils.formatS2(TimeUtils.calcTime2(revive_time)) +"</font>"+ StringConst.BOSS_PANEL_0023;
				TimerManager.getInstance().add(1000,updateTime2);
			}
			var format:TextFormat = new TextFormat();
			format.leading = 7;			
			_revive_time_text = addProperty(_attInfoTxt+htmlStr,leftP,235,format);
		
			//_revive_time_text.setTextFormat(format);
		}
		
		//倒计时的文本 击杀信息
		public function updateTime2():void
		{
			var data:ClassicItemData =  _data as ClassicItemData; 
			var htmlStr:String = "";
			
			if(data.killerName !="" && data.revive_time > 0)
			{
				htmlStr += StringConst.BOSS_PANEL_0020 +"<font color ='#ffcc00'>"+ data.killerName+"</font>" + StringConst.BOSS_PANEL_0021 +"\n";
				htmlStr +=  StringConst.BOSS_PANEL_0022 + "<font color ='#ff0000'>"+ TimeUtils.formatS2(TimeUtils.calcTime2(data.revive_time)) +"</font>"+ StringConst.BOSS_PANEL_0023;
				_revive_time_text.htmlText = _attInfoTxt + htmlStr;
			}
			
			if(0>=data.revive_time)
			{
				TimerManager.getInstance().remove(updateTime2);
			} 
			data.dealReviveTime();
		}
		
		override public function dispose():void
		{
			_data = null;
			_target = null;
			TimerManager.getInstance().remove(updateTime2);
			removeAllChild();
  
		}
	}
}