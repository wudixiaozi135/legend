package com.view.gameWindow.panel.panels.guideSystem.action
{
	import com.model.configData.cfgdata.GuideCfgData;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.panels.guideSystem.UICenter;
	import com.view.gameWindow.panel.panels.guideSystem.completeCond.CompleteCondtion;
	import com.view.gameWindow.panel.panels.guideSystem.completeCond.CondDef;
	import com.view.gameWindow.panel.panels.guideSystem.constants.GuideCondTypes;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.geom.Rectangle;
	
	/**
	 * @author wqhk
	 * 2014-12-13
	 */
	public class ActionFactory2 implements IActionFactory
	{
		private var _completeCond:CompleteCondtion;
		
		public function ActionFactory2()
		{
			_completeCond = new CompleteCondtion();
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
					var tip:String = "";
					if(parsed.length > 3)
					{
						area = new Rectangle(parsed[0],parsed[1],parsed[2],parsed[3]);
						areaType = data.hit_area_type;
						if(parsed.length > 4)
						{
							tip = CfgDataParse.pareseDesToStr(parsed[4],0xffe1aa);
						}
					}
					var panelName:String = UICenter.getUINameFromMenu(data.target_panel);
					if(UICenter.isTaskTrace(data.target_panel)) //不严谨的判断 和处理 ，这里把任务追踪的触发参数 cond_param 用来定位,但其实是没关联的。
					{
						if(data.cond_type == GuideCondTypes.GCT_TASK)
						{
							var taskParams:Array = data.cond_param.split(":");
							if(taskParams && taskParams.length == 2)
							{
								panelName = panelName + ":" + taskParams[0];
							}
						}
					}
					var attachAction:AttachPanelCondAction = new AttachPanelCondAction(panelName,data.target_tab-1,areaType,
													area,data.arrow_rotation,data.hit_area_show,tip,data.effect_url,data.effect_x,data.effect_y);
					var action_param:String = data.cond_type == GuideCondTypes.GCT_JOINTATTACK ? CondDef.O_JOINT_ATTACK : data.action_param;
					attachAction.cond = _completeCond.parse(action_param);
					re = attachAction;
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
				case ActionType.SEND_FAMILY_MAIL:
					re = new SendFamilyMailAction();
					break;
				case ActionType.RUN_NPC:
					re = new RunNpcAction(parseInt(data.action_param));
					break;
			}
			
			return re;
		}
		
		
	}
}