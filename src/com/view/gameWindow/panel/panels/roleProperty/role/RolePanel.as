package com.view.gameWindow.panel.panels.roleProperty.role
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.AttrCfgData;
    import com.model.consts.EffectConst;
    import com.model.consts.JobConst;
    import com.model.consts.RolePropertyConst;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.view.gameWindow.panel.panels.closet.ClosetDataManager;
    import com.view.gameWindow.panel.panels.propIcon.RolePropIconGroup;
    import com.view.gameWindow.panel.panels.roleProperty.McRole;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.RoleModelHandle;
    import com.view.gameWindow.panel.panels.roleProperty.cell.EquipCellHandle;
    import com.view.gameWindow.panel.panels.roleProperty.cell.FashionCellHandle;
    import com.view.gameWindow.scene.entity.EntityLayerManager;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.NumPic;
    import com.view.gameWindow.util.UIEffectLoader;
    import com.view.gameWindow.util.propertyParse.CfgDataParse;
    import com.view.gameWindow.util.tabsSwitch.TabBase;
    
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormat;

    public class RolePanel extends TabBase implements IRolePanel
	{
		private var _mcRoleProperty:McRole;
		private var _mc:MovieClip;
		private var _equipCellHandle:EquipCellHandle;
		private var _fashionCellHandle:FashionCellHandle;
		private var _roleModelHandle:RoleModelHandle;
		private var _roleMouseHandle:RoleMouseHandle;
		private var _effectLoader:UIEffectLoader;
		private var _menuCheck:HideFactionMenu;
		private var _array:Array;
		private var _roleDatamanager:RoleDataManager = RoleDataManager.instance;

		private var _numPic:NumPic;

		private var rolePropIconGroup:RolePropIconGroup;
		
		
		public function RolePanel()
		{
			mouseEnabled = false;
			super();
		}
		
		override protected function initSkin():void
		{
			_skin = new McRole();
			addChild(_skin);
			_mcRoleProperty = _skin as McRole;
			_mcRoleProperty.mouseEnabled = false;
			_mc = new MovieClip();
			_mcRoleProperty.addChild(_mc);
			_mc.x = 226 -40;
			_mc.y = 475 -55;
			_skin.mouseEnabled = false;
			
			rolePropIconGroup = new RolePropIconGroup();
			rolePropIconGroup.x=240;
			rolePropIconGroup.y=14;
            _array = [];
			initHideItem();	
			_menuCheck = new HideFactionMenu();
			_menuCheck.data = _array;
			addChild(_menuCheck);
			_menuCheck.visible = false;
			_menuCheck.x = 70;
			_menuCheck.y = 450;
			_mcRoleProperty.addChild(rolePropIconGroup);
		}
		
		private function changeHideFactionModel():void
		{
			_roleDatamanager.sendHideFactionData(_roleDatamanager.hideFactionData.getData());
			EntityLayerManager.getInstance().firstPlayer.changeModel();
			_roleModelHandle.changeModel();
		}
		
		private function initHideItem():void
		{
			var _hideFactionSettingItem:HideFactionSettingItem = new HideFactionSettingItem();
			_hideFactionSettingItem.label = StringConst.ROLE_PROPERTY_PANEL_0083;
			_hideFactionSettingItem.checked = Boolean(_roleDatamanager.hideFactionData.hideHuanwu);
			_hideFactionSettingItem.selectedFun = function():void
			{
				_roleDatamanager.hideFactionData.hideHuanwu = 1;
				changeHideFactionModel();
            };
			_hideFactionSettingItem.cancleSelectedFun = function():void
			{
				_roleDatamanager.hideFactionData.hideHuanwu = 0;
				changeHideFactionModel();
            };
			_array.push(_hideFactionSettingItem);
			_hideFactionSettingItem = new HideFactionSettingItem();
			_hideFactionSettingItem.label = StringConst.ROLE_PROPERTY_PANEL_0084;
			_hideFactionSettingItem.checked = Boolean(_roleDatamanager.hideFactionData.hideShizhuang);
			_hideFactionSettingItem.selectedFun = function():void
			{
				_roleDatamanager.hideFactionData.hideShizhuang = 1;
				changeHideFactionModel();
            };
			_hideFactionSettingItem.cancleSelectedFun = function():void
			{
				_roleDatamanager.hideFactionData.hideShizhuang = 0;
				changeHideFactionModel();
            };
			_array.push(_hideFactionSettingItem);
			_hideFactionSettingItem = new HideFactionSettingItem();
			_hideFactionSettingItem.label = StringConst.ROLE_PROPERTY_PANEL_0085;
			_hideFactionSettingItem.checked = Boolean(_roleDatamanager.hideFactionData.hideChibang);
			_hideFactionSettingItem.selectedFun = function():void
			{
				_roleDatamanager.hideFactionData.hideChibang = 1;
				changeHideFactionModel();
            };
			_hideFactionSettingItem.cancleSelectedFun = function():void
			{
				_roleDatamanager.hideFactionData.hideChibang = 0;
				changeHideFactionModel();
            };
			_array.push(_hideFactionSettingItem);
			_hideFactionSettingItem = new HideFactionSettingItem();
			_hideFactionSettingItem.label = StringConst.ROLE_PROPERTY_PANEL_0086;
			_hideFactionSettingItem.checked = Boolean(_roleDatamanager.hideFactionData.hideDouli);
			_hideFactionSettingItem.selectedFun = function():void
			{
				_roleDatamanager.hideFactionData.hideDouli = 1;
				changeHideFactionModel();
            };
			_hideFactionSettingItem.cancleSelectedFun = function():void
			{
				_roleDatamanager.hideFactionData.hideDouli = 0;
				changeHideFactionModel();
            };
			_array.push(_hideFactionSettingItem);
			
		}
		
		override protected function initData():void
		{
			initText();
			_equipCellHandle = new EquipCellHandle();
			_equipCellHandle.initData(_mcRoleProperty);
			_fashionCellHandle = new FashionCellHandle();
			_fashionCellHandle.initData(_mcRoleProperty);
			_fashionCellHandle.visible = false;

            _roleMouseHandle = new RoleMouseHandle(_mcRoleProperty, this);
			_roleMouseHandle.equipCellHandle = _equipCellHandle;
			_roleMouseHandle.fashionCellHandle = _fashionCellHandle;

			_roleModelHandle = new RoleModelHandle(_mcRoleProperty.mcModel);
			var sprite:Sprite = new Sprite();
			sprite.x = 220;
			sprite.y = 495;
			sprite.mouseEnabled = false;
			sprite.mouseChildren = false;
			addChild(sprite);
			_effectLoader = new UIEffectLoader(sprite,-40,-60,1,1,EffectConst.RES_FIGHTNUM);
		}
		
		private function initText():void
		{
			var i:int,j:int;
			var _textFormat:TextFormat;
			var txtArr:Vector.<TextField> = searchText(_mcRoleProperty.mcRight,"txt_",0,4,2);
			var strArr:Vector.<String> =  Vector.<String>([StringConst.ROLE_PROPERTY_PANEL_0001,StringConst.ROLE_PROPERTY_PANEL_0002,StringConst.ROLE_PROPERTY_PANEL_0003,StringConst.ROLE_PROPERTY_PANEL_0004,
				StringConst.ROLE_PROPERTY_PANEL_0005,StringConst.ROLE_PROPERTY_PANEL_0006,StringConst.ROLE_PROPERTY_PANEL_0007,StringConst.ROLE_PROPERTY_PANEL_0008,StringConst.ROLE_PROPERTY_PANEL_0009,
				StringConst.ROLE_PROPERTY_PANEL_0010,StringConst.ROLE_PROPERTY_PANEL_0011,StringConst.ROLE_PROPERTY_PANEL_0012,StringConst.ROLE_PROPERTY_PANEL_0013,StringConst.ROLE_PROPERTY_PANEL_0014,
				StringConst.ROLE_PROPERTY_PANEL_0015,StringConst.ROLE_PROPERTY_PANEL_0016,StringConst.ROLE_PROPERTY_PANEL_0017,StringConst.ROLE_PROPERTY_PANEL_0018,StringConst.ROLE_PROPERTY_PANEL_0059]);
			for(i=0; i<txtArr.length;i++)
			{
				_textFormat = txtArr[i].defaultTextFormat;
				txtArr[i].defaultTextFormat = _textFormat;
				txtArr[i].setTextFormat(_textFormat);
				txtArr[i].text = strArr[i];
			}
			
			_textFormat = _mcRoleProperty.hideFashion.defaultTextFormat;
			_textFormat.underline = true;
			_mcRoleProperty.hideFashion.defaultTextFormat = _textFormat;
			_mcRoleProperty.upFight.defaultTextFormat = _textFormat;
			_mcRoleProperty.hideFashion.setTextFormat(_textFormat);
			_mcRoleProperty.hideFashion.text = StringConst.ROLE_PROPERTY_PANEL_0020;
		}

		override public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_CHEST_INFO)
			{
				_fashionCellHandle.refresh();
			}
			else
			{
				refreshAttr();
				_equipCellHandle.refreshEquips();
				refreshHpMpBar();
				_roleModelHandle.changeModel();
			}
			if(!_numPic)
			{
				_numPic = new NumPic();
				_numPic.init("fight_",RoleDataManager.instance.getRoleMaxAttack().toString(),_mc);
			}
			if(RoleDataManager.instance.getRoleMaxAttack() == RoleDataManager.instance.oldFightNum)
			{
				return;
			}
			_numPic.destory();
			_numPic.init("fight_",RoleDataManager.instance.getRoleMaxAttack().toString(),_mc);
		}
		
		private function refreshAttr():void
		{
			var txtArr:Vector.<TextField>,attrs:Array,attr:Object,i:int;
			_mcRoleProperty.nameText.text = RoleDataManager.instance.name;
			_mcRoleProperty.factionText.text = "";
			txtArr = searchText(_mcRoleProperty.mcRight,"numText_",0,8,2);
			var jobName:String = JobConst.jobName(RoleDataManager.instance.job);
			var lv:String = (RoleDataManager.instance.reincarn?StringConst.ROLE_HEAD_0002.replace("X",String(RoleDataManager.instance.reincarn)):"") + RoleDataManager.instance.lv+"";
			var hp:String = RoleDataManager.instance.attrHp+"/"+RoleDataManager.instance.attrMaxHp;
			var mp:String = RoleDataManager.instance.attrMp+"/"+RoleDataManager.instance.attrMaxMp;
			var phscDmg:String = RoleDataManager.instance.minPhscDmg+"-"+RoleDataManager.instance.maxPhscDmg;
			var mgcDmg:String = RoleDataManager.instance.minMgcDmg+"-"+RoleDataManager.instance.maxMgcDmg;
			var trailDmg:String = RoleDataManager.instance.minTrailDmg+"-"+RoleDataManager.instance.maxTrailDmg;
			var phscDfns:String = RoleDataManager.instance.minPhscDfns+"-"+RoleDataManager.instance.maxPhscDfns;
			var mgcDfns:String = RoleDataManager.instance.minMgcDfns+"-"+RoleDataManager.instance.maxMgcDfns;
			attrs = [jobName,lv,hp,mp,phscDmg,mgcDmg,trailDmg,phscDfns,mgcDfns,
				RolePropertyConst.ROLE_PROPERTY_ACCURATE_ID,RolePropertyConst.ROLE_PROPERTY_AGILE_ID,RolePropertyConst.ROLE_PROPERTY_LUCKY_ID,RolePropertyConst.ROLE_PROPERTY_DAMNATION_ID,
				RolePropertyConst.ROLE_PROPERTY_CRIT_ID,RolePropertyConst.ROLE_PROPERTY_ATTACK_SPEED_ID,RolePropertyConst.ROLE_PROPERTY_HEART_HURT_ID,RolePropertyConst.ROLE_PROPERTY_DAMAGE_UP,
				RolePropertyConst.ROLE_PROPERTY_MOVE_SPEED_ID,RolePropertyConst.ROLE_INTERNAL_PKVALUE_ID];
			for each(attr in attrs)
			{
				var textField:TextField = txtArr[i];
				if(attr is String)
				{
					textField.text = attr as String;
				}
				else if(attr is int)
				{
					var attrType:int = attr as int;
					var value:int = RoleDataManager.instance.getAttrValueByType(attrType);
					var cfgDt:AttrCfgData = ConfigDataManager.instance.attrCfgData(attrType);
					if(cfgDt.percentage)
					{
						textField.text = CfgDataParse.getPercentValue(value) + "%";
					}
					else
					{
						textField.text = "+"+value+"";
					}
					ToolTipManager.getInstance().attachByTipVO(textField,ToolTipConst.TEXT_TIP,getTipData,attrType);
				}
				else
				{
					textField.text = "";
				}
				i++;
			}
		}
		
		private function getTipData(attrType:int):String
		{
			var cfgDt:AttrCfgData = ConfigDataManager.instance.attrCfgData(attrType);
			if(cfgDt)
			{
				return CfgDataParse.pareseDesToStr(cfgDt.tips);
			}
			else
			{
				return "";
			}
		}
		/**刷新血条蓝条*/
		private function refreshHpMpBar():void
		{
			var mcMask:MovieClip,attr:int,attrMax:int;
			mcMask = _mcRoleProperty.mcRight.mcHp.mcMask as MovieClip;
			attr = RoleDataManager.instance.attrHp;
			attrMax = RoleDataManager.instance.attrMaxHp;
			mcMask.scaleX = attr/attrMax;
			mcMask = _mcRoleProperty.mcRight.mcMp.mcMask as MovieClip;
			attr = RoleDataManager.instance.attrMp;
			attrMax = RoleDataManager.instance.attrMaxMp;
			mcMask.scaleX = attr/attrMax;
		}
		
		public function switchRoleInfoBewteenCloset():void
		{
			_mcRoleProperty.changeBtn.selected = false;
			_roleMouseHandle.switchRoleInfoBewteenCloset();
		}
		
		override public function destroy():void
		{
			if(rolePropIconGroup)
			{
				rolePropIconGroup.destroy();
				rolePropIconGroup=null;
			}
			if(_numPic)
			{
				_numPic.destory();
				_numPic=null;
			}
			if(_roleMouseHandle)
			{
				_roleMouseHandle.destroy();
				_roleMouseHandle = null;
			}
			if(_equipCellHandle)
			{
				_equipCellHandle.destory();
				_equipCellHandle = null;
			}
			if(_fashionCellHandle)
			{
				_fashionCellHandle.destroy();
				_fashionCellHandle = null;
			}
			if(_roleModelHandle)
			{
				_roleModelHandle.destroy();
				_roleModelHandle = null;
			}
			if(_effectLoader)
			{
				_effectLoader.destroy();
				_effectLoader = null;
			}
			
//			var i:int,l:int = _skin.numChildren;
//			for (i=0;i<l;i++) 
//			{
//				var textField:TextField = _skin.getChildAt(i) as TextField;
//				if(textField)
//				{
//					ToolTipManager.getInstance().detach(textField);
//				}
//			}
			
			var txtArr:Vector.<TextField> = searchText(_mcRoleProperty.mcRight,"numText_",0,8,2);
			for each(var text:TextField in txtArr)
			{
				ToolTipManager.getInstance().detach(text);
			}
			
			if(_menuCheck)
			{
				_menuCheck.parent&&_menuCheck.parent.removeChild(_menuCheck);
				_menuCheck.destroy();
			}
			_menuCheck = null;
			while(_array.length>0)
			{
				var hideFactionSettingItem:HideFactionSettingItem = _array.shift() as HideFactionSettingItem;
				hideFactionSettingItem&&hideFactionSettingItem.destroy();
				hideFactionSettingItem=null;	
			}
			_array=null;
			
			if (_mcRoleProperty)
			{
				_mcRoleProperty = null;
			}
			
			if(_mc)
			{
				_mc.parent&&_mc.parent.removeChild(_mc);
				_mc=null;
			}

			super.destroy();
		}

        public function get menuCheck():HideFactionMenu
        {
            return _menuCheck;
        }
		
		override protected function attach():void
		{
			RoleDataManager.instance.attach(this);
			ClosetDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			RoleDataManager.instance.detach(this);
			ClosetDataManager.instance.detach(this);
			super.detach();
		}	
	}
}