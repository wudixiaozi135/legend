package com.view.gameWindow.panel.panels.guideSystem.action
{
	import com.model.configData.cfgdata.GuideCfgData;
	import com.view.gameWindow.panel.panels.guideSystem.UICenter;
	import com.view.gameWindow.panel.panels.guideSystem.completeCond.CompleteCondtion;
	import com.view.gameWindow.panel.panels.guideSystem.constants.GuideCondTypes;
	
	import flash.geom.Rectangle;
	
	/**
	 * @author wqhk
	 * 2014-10-27
	 */
	public class ActionFactory implements IActionFactory
	{
		public function ActionFactory()
		{
		}
		
		public function getAction(data:GuideCfgData):GuideAction
		{
			var re:GuideAction = null;
			var parsed:Array = [];
			
			switch(data.action_type)
			{
				case ActionType.OPEN:
					re = new OpenPanelAction(UICenter.getUINameFromMenu(data.target_panel),data.target_tab-1);
					break;
				case ActionType.ATTACH:
					if(data.hit_area)
					{
						parsed = data.hit_area.split(":");
					}
					var area:Rectangle = null;
					var areaType:int = 0;
					if(parsed.length == 4)
					{
						area = new Rectangle(parsed[0],parsed[1],parsed[2],parsed[3]);
						areaType = data.hit_area_type;
					}
					var panelName:String = UICenter.getUINameFromMenu(data.target_panel);
					
					if(data.cond_type == GuideCondTypes.GCT_TASK && data.cond_param && UICenter.isCanSkip(panelName))//感觉加了这个后一下乱了好多
					{
						parsed = data.cond_param.split(":");
						if(parsed && parsed.length == 2)
						{
							re = new AttachIgnorePanelAction(parsed[0],parsed[1],panelName,data.target_tab-1,areaType,
											area,data.arrow_rotation,data.hit_area_show);
						}
					}
					
					if(!re)
					{
						re = new AttachPanelAction(panelName,data.target_tab-1,areaType,
										area,data.arrow_rotation,data.hit_area_show);
					}
					break;
				case ActionType.CLOSE:
					re = new ClosePanelAction(UICenter.getUINameFromMenu(data.target_panel));
					break;
				case ActionType.MONSTER_SUMMON_CK:
					var monsterInfo:Array = data.action_param.split(":");
					if(monsterInfo && monsterInfo.length == 4)
					{
						re = new MapMonsterSummonCKAction(monsterInfo[0],monsterInfo[1],monsterInfo[2],monsterInfo[3]);
					}
					break;
				case ActionType.PLAYER_POS_CK:
					var playerInfo:Array = data.action_param.split(":");
					if(playerInfo && playerInfo.length == 3)
					{
						re = new MapPlayerPosCKAction(playerInfo[0],playerInfo[1],playerInfo[2]);
					}
					break;
				case ActionType.MOVIE:
					var movieId:int = parseInt(data.action_param);
					if(movieId > 0)
					{
						re = new PlayMovieAction(movieId);
					}
					break;
			}
			
			return re;
		}
		
		
	}
}