package com.view.gameWindow.panel.panels.trailer
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.TaskTrailerCfgData;
	import com.model.configData.cfgdata.TaskTrailerRewardCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.util.FilterUtil;
	import com.view.gameWindow.util.HtmlUtils;
	
	import mx.utils.StringUtil;

	public class TrailerHandler
	{

		private var _panel:TrailerPanel;
		private var _skin:MCTrailerPanel;
		private var isInit:Boolean;
		private var oldQuality:int;
		public function TrailerHandler(panel:TrailerPanel)
		{
			this._panel = panel;
			_skin=panel.skin as MCTrailerPanel;
			isInit=false;
		}
		
		public function showRefreshResult():void
		{
			var trailerData:TrailerData = TrailerDataManager.getInstance().trailerData;
			var name:String = TrailerConst.names[trailerData.quality-1];
			var nameColor:int=TrailerConst.colors[trailerData.quality-1];
			if(trailerData.quality>oldQuality)
			{
				Alert.message(HtmlUtils.createHtmlStr(nameColor,StringUtil.substitute(StringConst.TRAILER_HINT_STRING_012,name)));
			}else
			{
				var ri:int = int(Math.random()*StringConst.TRAILER_HINT_STRING_015.length);
				Alert.message(HtmlUtils.createHtmlStr(0x777777,StringConst.TRAILER_HINT_STRING_015[ri]));
			}
			oldQuality=trailerData.quality;
		}
		
		public function updatePanel():void
		{
			var trailerData:TrailerData = TrailerDataManager.getInstance().trailerData;
			var name:String = TrailerConst.names[trailerData.quality-1];
			var nameColor:int=TrailerConst.colors[trailerData.quality-1];
			
			_skin.txtv1.htmlText=HtmlUtils.createHtmlStr(nameColor,name);
			_skin.txtv2.text=trailerData.count+"/"+trailerData.totalCount;
			_skin.txtv3.text=StringConst.TRAILER_STRING_21;
			if(isInit==false)
			{
//				if(trailerData.quality>oldQuality)
//				{
//					Alert.message(HtmlUtils.createHtmlStr(nameColor,StringUtil.substitute(StringConst.TRAILER_HINT_STRING_012,name)));
//				}else
//				{
//					var ri:int = int(Math.random()*StringConst.TRAILER_HINT_STRING_015.length);
//					Alert.message(HtmlUtils.createHtmlStr(0x777777,StringConst.TRAILER_HINT_STRING_015[ri]));
//				}
				oldQuality=trailerData.quality;
			}
			isInit=true;
			var strRefresh:String = trailerData.refreshCount+"/3"+StringConst.DUNGEON_PANEL_0006;
			if(trailerData.refreshCount>3)
			{
				strRefresh="3/3"+StringConst.DUNGEON_PANEL_0006;
			}
			_skin.txtv4.text=strRefresh;
			var trailerRewardCfgData:TaskTrailerRewardCfgData = ConfigDataManager.instance.trailerRewardCfgData(RoleDataManager.instance.lv);
			var taskTrailerCfgData:TaskTrailerCfgData = ConfigDataManager.instance.taskTrailerCfgData(trailerData.quality);
			var reStr:String="";
			if(trailerRewardCfgData.exp>0)
			{
				reStr+=StringConst.DUNGEON_PANEL_0015+":"+(trailerRewardCfgData.exp*taskTrailerCfgData.reward_rate/100)+"  ";
			}
			if(trailerRewardCfgData.bind_coin>0)
			{
				reStr+=StringConst.DUNGEON_PANEL_0014+":"+(trailerRewardCfgData.bind_coin*taskTrailerCfgData.reward_rate/100);
			}
			if(trailerRewardCfgData.get_gongxun>0)
			{
				reStr+="\n"+StringConst.INCOME_0017+":"+(trailerRewardCfgData.get_gongxun*taskTrailerCfgData.reward_rate/100);
			}
			_skin.txtv5.text=reStr;
			
			for(var i:int=1;i<=5;i++)
			{
				if(i>trailerData.quality)
				{
					_skin["tr"+i].filters=[FilterUtil.getGrayfiltes()];
				}else
				{
					_skin["tr"+i].filters=null;
					if(i==trailerData.quality)
					{
//						_skin["tr"+i].filters=[FilterUtil.getClolorFilterByColor(nameColor)];
						_skin.car_effect.x=_skin["tr"+i].x+112;
						_skin.car_effect.y=_skin["tr"+i].y+66;
					}
				}
			}
		}
		
		public function destroy():void
		{
			
		}
	}
}