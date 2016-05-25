package com.view.gameWindow.flyEffect.subs
{
	import com.model.configData.cfgdata.SkillCfgData;
	import com.view.gameWindow.flyEffect.FlyEffectBase;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
	import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
	import com.view.gameWindow.mainUi.subuis.bottombar.actBar.ActionBarCellType;
	import com.view.gameWindow.mainUi.subuis.bottombar.actBar.ActionBarData;
	import com.view.gameWindow.mainUi.subuis.bottombar.actBar.ActionBarDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.skill.constants.SkillConstants;
	import com.view.gameWindow.panel.panels.thingNew.McSkillNew;
	import com.view.gameWindow.panel.panels.thingNew.skillNew.PanelSkillNew;
	import com.view.gameWindow.util.cell.IconCellSkill;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class FlyEffectSkillNew extends FlyEffectBase
	{
		private var _panelIndex:int;
		private var _key:int;
		private var _isSetEmpty:Boolean;

		private var _groupId:int;
		
		public function FlyEffectSkillNew(layer:Sprite,panelIndex:int)
		{
			_panelIndex = panelIndex;
			super(layer);
			initialize();
		}
		
		private function initialize():void
		{
			var panel:PanelSkillNew = PanelMediator.instance.openedPanel(PanelConst.TYPE_SKILL_NEW,_panelIndex) as PanelSkillNew;
			if(!panel)
			{
				return;
			}
			var bottomBar:BottomBar = MainUiMediator.getInstance().bottomBar as BottomBar;
			if(!bottomBar)
			{
				return;
			}
			//
			var skin:McSkillNew = panel.skin as McSkillNew;
			var mc:MovieClip = skin.mc;
			var point:Point = new Point(mc.x,mc.y);
			fromLct = skin.localToGlobal(point);
			//
			var skin1:McMainUIBottom = bottomBar.skin as McMainUIBottom;
			var mc1:MovieClip;
			_key = getCellKey(panel);
			if(_key == -1)
			{
				mc1 = skin1.skillBtn;
			}
			else
			{
				mc1 = skin1["btnKey"+_key];
			}
			point.x = mc1.x;
			point.y = mc1.y;
			toLct = mc1.parent.localToGlobal(point);
			//
			target = panel.cellCopyBmp();
		}
		
		private function getCellKey(panel:PanelSkillNew):int
		{
			var cell:IconCellSkill = panel.cell;
			if(!cell)
			{
				return -1;
			}
			var cfgDt:SkillCfgData = cell.cfgDt;
			if(!cfgDt)
			{
				return -1;
			}
			_groupId = cfgDt.group_id;
			if(cfgDt.type == SkillConstants.ZD)
			{
				var manager:ActionBarDataManager = ActionBarDataManager.instance;
				var dt:ActionBarData = manager.actionBarData(_groupId);
				if(dt && !dt.isPreinstall && dt.type == ActionBarCellType.TYPE_SKILL)//技能栏上有该技能
				{
					_isSetEmpty = false;
					/*trace("FlyEffectSkillNew.getCellKey(panel) 1key:"+key);*/
					return dt.key;
				}
				else
				{
					_isSetEmpty = true;
					var key:int = manager.getEmptyKey();
					if(key != -1)
					{
						manager.preinstallSkill(key);
					}
					/*trace("FlyEffectSkillNew.getCellKey(panel) 2key:"+key);*/
					return key;
				}
			}
			else
			{
				/*trace("FlyEffectSkillNew.getCellKey(panel) 3key:"+key);*/
				return -1;
			}
		}
		
		override protected function onComplete():void
		{
			if(_key == -1)
			{
				/*PanelMediator.instance.openPanel(PanelConst.TYPE_SKILL);*/
			}
			else
			{
				if(_isSetEmpty)
				{
					ActionBarDataManager.instance.sendSetSkillData(_key,_groupId);
				}
			}
			/*trace("FlyEffectSkillNew.onComplete() _key:"+_key+",_isSetEmpty:"+_isSetEmpty);*/
			super.onComplete();
		}
	}
}