package com.view.gameWindow.panel.panels.skill
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.SkillCfgData;
	import com.model.consts.JobConst;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.mainUi.subuis.bottombar.actBar.ActionBarData;
	import com.view.gameWindow.mainUi.subuis.bottombar.actBar.ActionBarDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.skill.constants.SkillConstants;
	import com.view.gameWindow.panel.panels.specialRing.SpecialRingData;
	import com.view.gameWindow.panel.panels.specialRing.SpecialRingDataManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.filters.ColorMatrixFilter;
	
	import mx.utils.StringUtil;

	/**
	 * 技能栏类
	 * @author Administrator
	 */	
	public class PanelSkillItem extends McPanelSkillItem implements IUrlBitmapDataLoaderReceiver
	{
		public static const pageNum:int = 6;
		public static var mat:Array =[0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0];
		public static var colorMat:ColorMatrixFilter = new ColorMatrixFilter(mat);
		
		private var _cellW:int = 48,_cellH:int = 48;
		private var _urlBitmapDataLoader:UrlBitmapDataLoader;
		private var _bitmap:Bitmap;
		private var _skillData:SkillData;
		private var _group_id:int;
		private var _skillCfgData:SkillCfgData;

		private var _url:String;
		
		public function PanelSkillItem()
		{
			super();
			var rsrLoader:RsrLoader = new RsrLoader();
			addCallBack(rsrLoader);
			rsrLoader.load(this,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
			
			var tipVO:TipVO = new TipVO();
			tipVO.tipType = ToolTipConst.SKILL_TIP;
			tipVO.tipData = getTipData;
			ToolTipManager.getInstance().hashTipInfo(mcIcon,tipVO);
			ToolTipManager.getInstance().attach(mcIcon);
		}
		
		public function getTipData():Object
		{
			return _skillCfgData;
		}
		
		public function getTipType():int
		{
			return ToolTipConst.SKILL_TIP;
		}
		
		public function get groupId():int
		{
			return _group_id;
		}
		
		public function get isBD():Boolean
		{
			if(!_skillData)
			{
				return false;
			}
			var skillCfgData:SkillCfgData = ConfigDataManager.instance.skillCfgData(0,0,_skillData.group_id,_skillData.level);
			return skillCfgData.type == SkillConstants.BD;
		}
		
		private function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(mcBtnIcon,function (mc:MovieClip):void
			{
				mc.mouseEnabled = false;
				if(_skillData)
				{
					mc.visible = true;
					var job:int = getJob();
					var entity_type:int = SkillDataManager.instance.entity_type;
					var skillCfgData:SkillCfgData = ConfigDataManager.instance.skillCfgData(job,entity_type,_skillData.group_id,_skillData.level);
					var actionBarData:ActionBarData = ActionBarDataManager.instance.actionBarData(_skillData.group_id);
					if(actionBarData && !actionBarData.isPreinstall)
					{
						mc.visible = true;
						mc.gotoAndStop(actionBarData.key+1);
					}
					else
					{
						mc.gotoAndStop(1);
						mc.visible = false;
					}
				}
				else
				{
					mc.visible = false;
				}
			});
			rsrLoader.addCallBack(btn,function (mc:MovieClip):void
			{
				if(_skillData)
				{
					mc.visible = true;
					var job:int = getJob();
					var entity_type:int = SkillDataManager.instance.entity_type;
					var skillCfgData:SkillCfgData = ConfigDataManager.instance.skillCfgData(job,entity_type,_skillData.group_id,_skillData.level);
					if(skillCfgData.type == SkillConstants.ZD)
					{
						btn.mouseEnabled = true;
					}
					else
					{
						btn.mouseEnabled = false;
					}
				}
				else
				{
					mc.visible = false;
				}
			});
		}
		
		public function openSkillSet():void
		{
			var skillData:SkillData = SkillDataManager.instance.skillData(_group_id);
			if(skillData)
			{
				SkillDataManager.instance.selectSkillData = skillData;
			}
			PanelMediator.instance.switchPanel(PanelConst.TYPE_SKILL_SET);
		}
		
		public function switchHeroSkillState():void
		{
			var open:int = _skillData.open;
			SkillDataManager.instance.switchHeroSkillState(_group_id,1-open);
		}
		
		public function get isUnactivated():Boolean
		{
			return _skillData == null;
		}
		
		public function get isInCd():Boolean
		{
			var skillCfgData:SkillCfgData = SkillDataManager.instance.skillCfgData(_group_id);
			return !SkillDataManager.instance.checkSkillCd(skillCfgData);
		}
		
		public function getBitmap():Bitmap
		{
			var bitmap:Bitmap = new Bitmap(_bitmap.bitmapData,"auto",true);
			bitmap.width = _bitmap.width;
			bitmap.height = _bitmap.height;
			return bitmap;
		}
		
		public function refreshData(skillCfgData:SkillCfgData):void
		{
			_group_id = skillCfgData.group_id;
			var skillData:SkillData = SkillDataManager.instance.skillData(_group_id);
			if(!skillData)
			{
				setUnlearn(skillCfgData);
			}
			else
			{
				setSkillData(skillData);
			}
		}
		
		private function setUnlearn(skillCfgData:SkillCfgData):void
		{
			_skillData = null;
			_skillCfgData = skillCfgData;
			initText(skillCfgData);
			loadPic(skillCfgData.icon);
			mcBtnIcon.visible = false;
			btn.visible = false;
			txtUnactivated.visible = true;
			mcIcon.filters = [colorMat];
		}
		
		private function setSkillData(skillData:SkillData):void
		{
			_skillData = skillData;
			_skillCfgData = _skillData.skillCfgDt;
			mcBtnIcon.visible = true;
			btn.visible = true;
			txtUnactivated.visible = false;
			mcIcon.filters = null;
			var job:int = getJob();
			var entity_type:int = SkillDataManager.instance.entity_type;
			if(entity_type == SkillConstants.TYPE_ROLE)
			{
				setRoleSkillData(job,entity_type);
			}
			else if(entity_type == SkillConstants.TYPE_HERO)
			{
				setHeroSkillData(job,entity_type);
			}
		}
		
		private function setRoleSkillData(job:int,entity_type:int):void
		{
			var manager:ConfigDataManager = ConfigDataManager.instance;
			var skillCfgData:SkillCfgData = manager.skillCfgData(job,entity_type,_skillData.group_id,_skillData.level);
			skillCfgData ||= manager.skillCfgData(JobConst.TYPE_NO,entity_type,_skillData.group_id,_skillData.level);
			initText(skillCfgData);
			loadPic(skillCfgData.icon);
			var actionBarData:ActionBarData = ActionBarDataManager.instance.actionBarData(_skillData.group_id);
			if(actionBarData && !actionBarData.isPreinstall)
			{
				mcBtnIcon.visible = true;
				mcBtnIcon.gotoAndStop(actionBarData.key+1);
			}
			else
			{
				mcBtnIcon.gotoAndStop(1);
				mcBtnIcon.visible = false;
			}
			if(skillCfgData.type == SkillConstants.ZD)
			{
				txtUnactivated.visible = false;
				txtUnactivated.text = StringConst.SKILL_PANEL_0012;
				btn.mouseEnabled = true;
			}
			else
			{
				txtUnactivated.visible = true;
				txtUnactivated.text = StringConst.SKILL_PANEL_0015;
				btn.mouseEnabled = false;
			}
		}
		
		private function setHeroSkillData(job:int,entity_type:int):void
		{
			var skillCfgData:SkillCfgData = ConfigDataManager.instance.skillCfgData(job,entity_type,_skillData.group_id,_skillData.level);
			initText(skillCfgData);
			loadPic(skillCfgData.icon);
			mcBtnIcon.gotoAndStop(1);
			mcBtnIcon.visible = false;
			txtUnactivated.visible = true;
			if(skillCfgData.type == SkillConstants.ZD)
			{
				btn.mouseEnabled = true;
			}
			else
			{
				btn.mouseEnabled = false;
			}
			if(_skillData.open)
			{
				txtUnactivated.text = StringConst.SKILL_PANEL_0016;
			}
			else
			{
				txtUnactivated.text = StringConst.SKILL_PANEL_0017;
			}
		}
		
		/**初始化文本*/
		private function initText(skillCfgData:SkillCfgData):void
		{
			if(!skillCfgData)
			{
				return;
			}
			var lv:int,rein:int,job:int,entity_type:int,nextSkillCfgDt:SkillCfgData,itemCfgData:ItemCfgData,scaleX:Number;
			txtName.text = skillCfgData.name;
			txtState.text ="";
			txtLv.text = StringConst.SKILL_PANEL_0008 + skillCfgData.level;
			txtUnactivated.mouseEnabled = false;
			mcProgress.visible = false;
			txtNeed.text = "";
			if(!_skillData)
			{
//				mcProgress.visible = true;
//				mcProgress.txt.text = 0+"/"+0;
//				(mcProgress.mcMask as MovieClip).scaleX = 0;
				if(skillCfgData.ring_id||skillCfgData.joint_halo_id)// 如果需要特戒或者光环激活
				{
					txtUnactivated.text = StringConst.SKILL_PANEL_0012;
				}else
				{
					txtUnactivated.text = StringConst.SKILL_PANEL_0026;
				}
			}
			else
			{
				txtState.text = StringConst.SKILL_PANEL_0009;
				txtUnactivated.text = StringConst.SKILL_PANEL_0012;
				txtState.textColor = 0xd4a460;
				job = getJob();
				entity_type = SkillDataManager.instance.entity_type;
				var manager:ConfigDataManager = ConfigDataManager.instance;
				nextSkillCfgDt = manager.skillCfgData(job,entity_type,_skillData.group_id,skillCfgData.level+1);
				nextSkillCfgDt ||= manager.skillCfgData(JobConst.TYPE_NO,entity_type,_skillData.group_id,skillCfgData.level+1)
				if(!nextSkillCfgDt)//技能已满级
				{
					txtState.text = StringConst.SKILL_PANEL_0011;
					txtState.textColor = 0xac3710;
				}
				else//技能未满级
				{
					if(nextSkillCfgDt.ring_id)//有特戒等级需求
					{
						var dt:SpecialRingData = SpecialRingDataManager.instance.getDataById(nextSkillCfgDt.ring_id);
						txtNeed.text = dt.specialRingCfgData.name + StringConst.SKILL_PANEL_0018 + nextSkillCfgDt.ring_level;
					}
					else if(!nextSkillCfgDt.proficiency)//无熟练度需求
					{
						if(!nextSkillCfgDt.player_level)//无等级需求
						{
							if(nextSkillCfgDt.book)//有技能书需求
							{
								itemCfgData = manager.itemCfgData(nextSkillCfgDt.book);
								if(itemCfgData)
									txtNeed.text = itemCfgData.name;
								else
									txtNeed.text = "";
								txtNeed.textColor = 0xff0000;
							}
						}
						else//有等级需求
						{
							lv = RoleDataManager.instance.lv;
							rein=RoleDataManager.instance.reincarn;
							if(nextSkillCfgDt.view_type==EntityTypes.ET_HERO)
							{
								lv=HeroDataManager.instance.lv;
								rein=HeroDataManager.instance.grade;
							}
							if(nextSkillCfgDt.player_reincarn>=rein&&lv < nextSkillCfgDt.player_level)//等级不够
							{
								var lvStr:String;
								if(nextSkillCfgDt.player_reincarn>0)
								{
									lvStr = StringUtil.substitute(StringConst.TEAM_PANEL_00025,nextSkillCfgDt.player_reincarn,nextSkillCfgDt.player_level);
								}else
								{
									lvStr=nextSkillCfgDt.player_level+StringConst.ROLE_PROPERTY_PANEL_0072;
								}
								if(nextSkillCfgDt.view_type==EntityTypes.ET_PLAYER)
								{
									txtNeed.text = StringConst.SKILL_PANEL_0010+lvStr;
								}else
								{
									txtNeed.text = StringConst.SKILL_PANEL_0028+lvStr;
								}
								txtNeed.textColor = 0xff0000;
							}
						}
//						else//无技能书需求，错误
//						{
//							trace("PanelSkillItem.initText(skillCfgData) "+txtName.text+txtLv.text+"学习技能配置信息错误");
//						}
					}
					else//需要熟练度
					{
						if(_skillData.proficiency < skillCfgData.proficiency)//熟练度未满
						{
							mcProgress.visible = true;
							mcProgress.txt0.text = _skillData.proficiency+"";
							mcProgress.txt2.text = "/";
							mcProgress.txt1.text = skillCfgData.proficiency+"";
							scaleX = _skillData.proficiency/skillCfgData.proficiency;
							(mcProgress.mcMask as MovieClip).scaleX = scaleX < 0 ? 0 : (scaleX > 1 ? 1 : scaleX);
						}
						else//熟练度已满
						{
							if(!nextSkillCfgDt.player_level)//无等级需求
							{
								if(nextSkillCfgDt.book)//有技能书需求
								{
									itemCfgData = manager.itemCfgData(nextSkillCfgDt.book);
									if(itemCfgData)
										txtNeed.text = itemCfgData.name;
									else
										txtNeed.text = "";
									txtNeed.textColor = 0xff0000;
								}
							}
							else//有等级需求
							{
								lv = RoleDataManager.instance.lv;
								if(lv < nextSkillCfgDt.player_level)//等级不够
								{
									mcProgress.visible = true;
									mcProgress.txt0.text = _skillData.proficiency+"";
									mcProgress.txt2.text = "/";
									mcProgress.txt1.text = skillCfgData.proficiency+"";
									scaleX = _skillData.proficiency/skillCfgData.proficiency;
									(mcProgress.mcMask as MovieClip).scaleX = scaleX < 0 ? 0 : (scaleX > 1 ? 1 : scaleX);
								}
								else
								{
									itemCfgData = manager.itemCfgData(nextSkillCfgDt.book);
									if(itemCfgData)
										txtNeed.text = itemCfgData.name;
									else
										txtNeed.text = "";
									txtNeed.textColor = 0xff0000;
								}
							}
						}
					}
				}
			}
		}
		
		private function getJob():int
		{
			var entity_type:int = SkillDataManager.instance.entity_type;
			if(entity_type == SkillConstants.TYPE_ROLE)
			{
				var job:int = RoleDataManager.instance.job;
			}
			else if(entity_type == SkillConstants.TYPE_HERO)
			{
				job = HeroDataManager.instance.job;
			}
			else
			{
				job = RoleDataManager.instance.job;
				trace("PanelSkillItem.setSkillData entity_type:"+entity_type);
			}
			return job;
		}
		
		/**加载技能图标*/
		private function loadPic(icon:String):void
		{
			var url:String = ResourcePathConstants.IMAGE_ICON_SKILL_FOLDER_LOAD+icon+ResourcePathConstants.POSTFIX_PNG;
			if(url && url != _url)
			{
				_url = url;
				_urlBitmapDataLoader = new UrlBitmapDataLoader(this);
				_urlBitmapDataLoader.loadBitmap(_url);
			}
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			destoryLoader();
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			if(!bitmapData || (_url && url != _url))
			{
				return;
			}
			if(_bitmap)
			{
				if(_bitmap.parent)
				{
					mcIcon.removeChild(_bitmap);
				}
				if(_bitmap.bitmapData)
				{
					_bitmap.bitmapData.dispose();
				}
				_bitmap = null;
			}
			if(!_bitmap&&mcIcon)
			{
				_bitmap = new Bitmap(bitmapData,"auto",true);
				mcIcon.addChild(_bitmap);
			}
			if(_bitmap)
			{
				_bitmap.bitmapData.draw(bitmapData,null,null,null,null,true);
				_bitmap.width = _cellW;
				_bitmap.height = _cellH;
			}
			destoryLoader();
		}
		
		public function setNull():void
		{
			_skillCfgData = null;
			if(_bitmap)
			{
				mcIcon.removeChild(_bitmap);
				_bitmap.bitmapData.dispose();
				_bitmap = null;
			}
			_skillData = null;
			_url = "";
		}
		
		public function destoryLoader():void
		{
			if(_urlBitmapDataLoader)
				_urlBitmapDataLoader.destroy();
			_urlBitmapDataLoader = null;
		}
		
		public function destory():void
		{
			ToolTipManager.getInstance().detach(mcIcon);
			setNull();
			destoryLoader();
		}
		
	}
}