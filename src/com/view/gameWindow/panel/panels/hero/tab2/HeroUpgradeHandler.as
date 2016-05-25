package com.view.gameWindow.panel.panels.hero.tab2
{
	import com.greensock.TweenLite;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.DungeonCfgData;
	import com.model.configData.cfgdata.HeroGradeCfgData;
	import com.model.configData.cfgdata.HeroMeridiansCfgData;
	import com.model.configData.cfgdata.LevelCfgData;
	import com.model.configData.cfgdata.SkillCfgData;
	import com.model.consts.JobConst;
	import com.model.consts.SexConst;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.dungeon.DgnDataManager;
	import com.view.gameWindow.panel.panels.dungeon.DungeonData;
	import com.view.gameWindow.panel.panels.dungeonTower.DgnTowerDataManger;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.specialRing.upgrade.TipArrow;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.css.GameStyleSheet;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.display.Shape;
	import flash.events.TextEvent;
	import flash.utils.Dictionary;
	
	import mx.utils.StringUtil;

	public class HeroUpgradeHandler
	{
		private var _panel:HeroUpgradeTab;
		private var _skin:MCHeroUpgradeTab;
		private var _lineShape:Shape;
		private var _nodeVec:Vector.<HeroUpgradeNode>;
		private var _skillCell:IconCellEx
		
		public var mCHeroUpgradeAlert:MCHeroUpgradeAlert;
		private var arrow:TipArrow;
		private var isInit:Boolean;
		
		public function HeroUpgradeHandler(panel:HeroUpgradeTab)
		{
			this._panel = panel;
			_skin=panel.skin as MCHeroUpgradeTab;
			_lineShape=new Shape();
			_skin.addChild(_lineShape);
			_nodeVec=new Vector.<HeroUpgradeNode>();
			_skillCell=new IconCellEx(_skin,29,44,48,48);
			mCHeroUpgradeAlert = new MCHeroUpgradeAlert();
			mCHeroUpgradeAlert.x=240;
			mCHeroUpgradeAlert.y=170;
			mCHeroUpgradeAlert.txt2.addEventListener(TextEvent.LINK,onClickLinkFunc);
			arrow = new TipArrow();
			isInit=true;
		}
		
		protected function onClickLinkFunc(event:TextEvent):void
		{
			var heroUpgradeData:HeroUpgradeData = HeroDataManager.instance.heroUpgradeData;
			var heroGradeCfgData:HeroGradeCfgData = ConfigDataManager.instance.heroGradeCfgData(heroUpgradeData.grade+1);
			if(heroGradeCfgData==null)return;
			var dungeon:int = heroGradeCfgData.dungeon;
			var cfgDt:DungeonCfgData = ConfigDataManager.instance.dungeonCfgDataId(dungeon);
			var limitLv:int = cfgDt ? cfgDt.level : int.MAX_VALUE;
			var limitReincarn:int = cfgDt ? cfgDt.reincarn : int.MAX_VALUE;
			var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(limitReincarn,limitLv);
			if(heroUpgradeData.grade>=RoleDataManager.instance.reincarn)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringUtil.substitute(StringConst.HERO_UPGRADE_1021,heroUpgradeData.grade+1));
				return;
			}
			if(!checkReincarnLevel)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DGN_TOWER_0034);
				return;
			}
			var dgnDt:DungeonData = DgnDataManager.instance.getDgnDt(heroGradeCfgData.dungeon);
			var complete:int = dgnDt ? dgnDt.daily_enter_count : 0;
			var total:int = cfgDt ? cfgDt.free_count + cfgDt.toll_count : 0;
			if(complete >= total)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DGN_TOWER_0033);
				return;
			}
			var expGain:int = DgnTowerDataManger.instance.expGain;
			if(expGain)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DGN_TOWER_0026);
				return;
			}
			HeroDataManager.instance.enterHeroUpgardeDun();
			PanelMediator.instance.switchPanel(PanelConst.TYPE_HERO);
		}
		
		public function updatePanel():void
		{
			initMatter();
			initNote();
			drawLine();
			initAttr();
			initSkill();
			
			checkFB();
		}
		
		private function checkFB():void
		{
			var heroUpgradeData:HeroUpgradeData = HeroDataManager.instance.heroUpgradeData;
			mCHeroUpgradeAlert.parent&&mCHeroUpgradeAlert.parent.removeChild(mCHeroUpgradeAlert);
			if(heroUpgradeData.meridians!=10)return;
			_skin.addChild(mCHeroUpgradeAlert);
			mCHeroUpgradeAlert.txt1.text=StringConst.HERO_UPGRADE_1017;
			var heroGradeCfgData:HeroGradeCfgData = ConfigDataManager.instance.heroGradeCfgData(heroUpgradeData.grade+1);
			if(heroGradeCfgData==null)return;
			var dungeon:int = heroGradeCfgData.dungeon;
			var dungeonCfgDataId:DungeonCfgData = ConfigDataManager.instance.dungeonCfgDataId(dungeon);
			var gress:String="<font color='#ff0000'>(0/1)</font>";
			var createHtmlStr:String = HtmlUtils.createHtmlStr(0xffe1aa,StringUtil.substitute(StringConst.HERO_UPGRADE_1018,dungeonCfgDataId.name,gress));
			mCHeroUpgradeAlert.txt2.styleSheet=GameStyleSheet.linkStyle;
			mCHeroUpgradeAlert.txt2.htmlText=createHtmlStr;
		}
		
		private function initMatter():void
		{
			var heroUpgradeData:HeroUpgradeData = HeroDataManager.instance.heroUpgradeData;
			var heroGradeCfgData:HeroGradeCfgData = ConfigDataManager.instance.heroGradeCfgData(heroUpgradeData.grade);
			var heroMeridiansCfgData:HeroMeridiansCfgData = ConfigDataManager.instance.heroMeridiansCfgData(heroUpgradeData.grade,heroUpgradeData.meridians);
			var heroNextGradeCfgData:HeroGradeCfgData = ConfigDataManager.instance.heroGradeCfgData(heroUpgradeData.grade+1);
			var levelCfgData:LevelCfgData = ConfigDataManager.instance.levelCfgData(HeroDataManager.instance.lv);
			var sex:int = HeroDataManager.instance.sex;
			_skin.current_bg.resUrl="hero/"+heroGradeCfgData.grade_lv_base+ResourcePathConstants.POSTFIX_PNG;
			_skin.current_txt.resUrl="hero/grade_"+heroUpgradeData.grade+ResourcePathConstants.POSTFIX_PNG;
			if(sex==SexConst.TYPE_MALE)
			{
				_skin.hero_bg.resUrl="hero/"+heroGradeCfgData.grade_figure_man+ResourcePathConstants.POSTFIX_PNG;
			}else
			{
				_skin.hero_bg.resUrl="hero/"+heroGradeCfgData.grade_figure_woman+ResourcePathConstants.POSTFIX_PNG;
			}
			_skin.hero_base.resUrl="hero/"+heroGradeCfgData.grade_base+ResourcePathConstants.POSTFIX_JPG;
			
			if(heroNextGradeCfgData==null)
			{
				_skin.next_bg.resUrl="hero/"+heroGradeCfgData.grade_lv_base+ResourcePathConstants.POSTFIX_PNG;
				_skin.next_txt.resUrl="hero/grade_"+heroUpgradeData.grade+ResourcePathConstants.POSTFIX_PNG;
			}else
			{
				_skin.next_bg.resUrl="hero/"+heroNextGradeCfgData.grade_lv_base+ResourcePathConstants.POSTFIX_PNG;
				_skin.next_txt.resUrl="hero/grade_"+(heroUpgradeData.grade+1)+ResourcePathConstants.POSTFIX_PNG;
			}
//			_skin.txtv1.htmlText=HtmlUtils.createHtmlStr(0xa56238,StringConst.HERO_UPGRADE_1020+"<font color='#ffe1aa'>"+getLevelMax(heroUpgradeData.grade)+"</font>");
//			_skin.txtv2.htmlText=HtmlUtils.createHtmlStr(0xa56238,StringConst.HERO_UPGRADE_1020+"<font color='#ffe1aa'>"+getLevelMax(heroUpgradeData.grade+1)+"</font>");
			var gress:Number = int(heroUpgradeData.exp/levelCfgData.hero_exp/10*1000)/1000;
			if(isInit)
			{
				_skin.mcGress.scaleX=gress;
				isInit=false;
			}
			else
			{
				TweenLite.killTweensOf(_skin.mcGress);
				TweenLite.to(_skin.mcGress,1,{scaleX:gress});
			}
			var num:Number = levelCfgData.hero_exp*10;
			num = num>2000000000?2000000000:num;
			_skin.txt_gress.text=heroUpgradeData.exp+"/"+num;
			ToolTipManager.getInstance().attachByTipVO(_skin.mcGress,ToolTipConst.TEXT_TIP,HtmlUtils.createHtmlStr(0xa56238,StringConst.HERO_UPGRADE_1022));
		}
		
		private function getLevelMax(level:int):int
		{
			var levelCfgArr:Dictionary = ConfigDataManager.instance.levelCfgArr();
			var returnLevel:int=0;
			for each(var cfg:LevelCfgData in levelCfgArr)
			{
				if(level==cfg.hero_grade)
				{
					returnLevel=cfg.level;
				}
			}
			return returnLevel+1;
		}
		
		private function initSkill():void
		{
			var heroUpgradeData:HeroUpgradeData = HeroDataManager.instance.heroUpgradeData;
			var heroGradeCfgData:HeroGradeCfgData = ConfigDataManager.instance.heroGradeCfgData(heroUpgradeData.grade+1);

			var skillCfg:SkillCfgData;
			var job:int = HeroDataManager.instance.job;
			if(job==JobConst.TYPE_ZS)
			{
				skillCfg=ConfigDataManager.instance.skillCfgData1(heroGradeCfgData.soldier_skill_id);
			}else if(job==JobConst.TYPE_FS)
			{
				
				skillCfg=ConfigDataManager.instance.skillCfgData1(heroGradeCfgData.mage_skill_id);
			}else
			{
				skillCfg=ConfigDataManager.instance.skillCfgData1(heroGradeCfgData.taolist_skill_id);
			}
			IconCellEx.setItemBySkill(_skillCell,skillCfg);
			ToolTipManager.getInstance().attach(_skillCell);
		}
		
		private function initNote():void
		{
			var heroUpgradeData:HeroUpgradeData = HeroDataManager.instance.heroUpgradeData;
			for(var i:int=1;i<11;i++)
			{
				var heroMeridiansCfgData:HeroMeridiansCfgData = ConfigDataManager.instance.heroMeridiansCfgData(heroUpgradeData.grade,i);
				var node:HeroUpgradeNode;
				if(_nodeVec.length>=i)
				{
					node=_nodeVec[i-1];
				}else
				{
					node=new HeroUpgradeNode();
					_skin.addChild(node);
					_nodeVec.push(node);
				}
				node.setNode(heroMeridiansCfgData,heroUpgradeData.meridians);
				var sex:int = HeroDataManager.instance.sex;
				var posArray:Array = heroMeridiansCfgData.meridians_pos.split("|");
				var split:Array = posArray[sex-1].split(":");
				node.x=split[0];
				node.y=split[1];
			}
			addTipArrow();
		}
		
		private function addTipArrow():void
		{
			// TODO Auto Generated method stub
			if(arrow.parent)
				arrow.parent.removeChild(arrow);
			var heroUpgradeData:HeroUpgradeData = HeroDataManager.instance.heroUpgradeData;
			var heroMeridiansCfgData:HeroMeridiansCfgData = ConfigDataManager.instance.heroMeridiansCfgData(heroUpgradeData.grade,heroUpgradeData.meridians+1);
			if(!heroMeridiansCfgData)
				return;
			var sex:int = HeroDataManager.instance.sex;
			var posArray:Array = heroMeridiansCfgData.meridians_pos.split("|");
			var split:Array = posArray[sex-1].split(":");
			var retraction:int = (heroUpgradeData.meridians==0||heroUpgradeData.meridians==3)?-1:2;
			arrow.x = int(split[0]);
			arrow.y = int(split[1])+30-retraction;
			_skin.addChild(arrow);
			
		}
		
		private function clearNode():void
		{
			while(_nodeVec.length>0)
			{
				var node:HeroUpgradeNode = _nodeVec.shift();
				node.destroy();
				node.parent&&node.parent.removeChild(node);
				node=null;
			}
		}
		
		private function drawLine():void
		{
			var heroUpgradeData:HeroUpgradeData = HeroDataManager.instance.heroUpgradeData;
			var heroGradeCfgData:HeroGradeCfgData = ConfigDataManager.instance.heroGradeCfgData(heroUpgradeData.grade);
			
			_lineShape.graphics.clear();
			var color:int=int("0x"+heroGradeCfgData.route_color);
			for(var i:int=1;i<10;i++)
			{
				if(i<heroUpgradeData.meridians)
				{
					_lineShape.graphics.lineStyle(2,color);
				}else
				{
					_lineShape.graphics.lineStyle(2,0x666666);
				}
				var heroMeridiansCfgData:HeroMeridiansCfgData = ConfigDataManager.instance.heroMeridiansCfgData(heroUpgradeData.grade,i);
				var heroNextMeridiansCfgData:HeroMeridiansCfgData = ConfigDataManager.instance.heroMeridiansCfgData(heroUpgradeData.grade,i+1);
				var sex:int = HeroDataManager.instance.sex;
				var posArray:Array = heroMeridiansCfgData.meridians_pos.split("|");
				var point:Array = posArray[sex-1].split(":");
				var posArray1:Array = heroNextMeridiansCfgData.meridians_pos.split("|");
				var point1:Array = posArray1[sex-1].split(":");
				_lineShape.graphics.moveTo(int(point[0]),int(point[1]));
				_lineShape.graphics.lineTo(int(point1[0]),int(point1[1]));
			}
			_lineShape.graphics.endFill();
		}
		
		private function initAttr():void
		{
			var heroUpgradeData:HeroUpgradeData = HeroDataManager.instance.heroUpgradeData;
			var job:int = HeroDataManager.instance.job;
			var attrs:Vector.<String>=new Vector.<String>();
			var gradeSum:Number = heroUpgradeData.grade*10+heroUpgradeData.meridians;
			_skin.txtAttr1.htmlText="";
			_skin.txtAttr1.scaleY=1;
			_skin.txtAttr2.htmlText="";
			_skin.txtAttr2.scaleY=1;
			for(var i:int=0;i<=gradeSum;i++)
			{
				var grade:int;
				var order:int;
				if(i/10>0&&i%10==0)
				{
					grade=i/10-1;
					order=10;
				}else
				{
					grade=i/10;
					order=i%10;
				}
					
				var heroMeridiansCfgData:HeroMeridiansCfgData = ConfigDataManager.instance.heroMeridiansCfgData(grade,order);
				if(heroMeridiansCfgData==null)continue;
				if(job==JobConst.TYPE_ZS)
				{
					attrs.push(heroMeridiansCfgData.soldier_attr);
				}else if(job==JobConst.TYPE_FS)
				{
					attrs.push(heroMeridiansCfgData.mage_attr);
				}else
				{
					attrs.push(heroMeridiansCfgData.taolist_attr);
				}
			}
			
			if(attrs.length>0)
			{
				var attrsVec:Vector.<String> = CfgDataParse.getAttHtmlStringArray2(attrs);
				for (var s:int=0;s<attrsVec.length;s++)
				{
					if(s%2==0)
					{
						_skin.txtAttr1.htmlText+=attrsVec[s]+"\n";
					}else
					{
						_skin.txtAttr2.htmlText+=attrsVec[s]+"\n";
					}
				}
			}
			attrs.splice(0,attrs.length);
			attrs=null;
		}
		
		public function destroy():void
		{
			ToolTipManager.getInstance().detach(_skin.mcGress);
			mCHeroUpgradeAlert.txt2.removeEventListener(TextEvent.LINK,onClickLinkFunc);
			mCHeroUpgradeAlert.parent&&mCHeroUpgradeAlert.parent.removeChild(mCHeroUpgradeAlert);
			mCHeroUpgradeAlert=null;
			ToolTipManager.getInstance().detach(_skillCell);
			if(_skillCell)
			{
				_skillCell.destroy();
			}
			_skillCell=null;
			clearNode();
			if(arrow)
			{
				arrow.parent&&arrow.parent.removeChild(arrow);
			}
			if(_lineShape)
			{
				_lineShape.parent&&_lineShape.parent.removeChild(_lineShape);
			}
			_lineShape=null;
		}
	}
}