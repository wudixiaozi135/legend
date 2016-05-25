package com.view.gameWindow.panel.panels.roleProperty.otherRole
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.AttrCfgData;
	import com.model.consts.ConstRoleType;
	import com.model.consts.EffectConst;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.dungeon.TextFormatManager;
	import com.view.gameWindow.panel.panels.roleProperty.McRole;
	import com.view.gameWindow.panel.panels.roleProperty.McRoleProperty;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipCellHandle;
	import com.view.gameWindow.panel.panels.roleProperty.role.RoleMouseHandle;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.NumPic;
	import com.view.gameWindow.util.UIEffectLoader;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class OtherRolePanel extends PanelBase implements IOtherRolePanel
	{
		private var _mcRoleProperty:McRole;
		private var _mc:MovieClip;
		private var _equipCellHandle:EquipCellHandle;
		private var _roleModelHandle:OtherRoleModelHandle;
		private var _roleMouseHandle:RoleMouseHandle;
		private var _effectLoader:UIEffectLoader;
		private var _mcBg:McRoleProperty;
		private var _Loader:RsrLoader;
		private var _cid:int;
		private var _sid:int;
		
		public function OtherRolePanel()
		{
			mouseEnabled = false;
			super();
			OtherPlayerDataManager.instance.attach(this);
		}
		
		public function get sid():int
		{
			return _sid;
		}

		public function set sid(value:int):void
		{
			_sid = value;
		}

		public function get cid():int
		{
			return _cid;
		}

		public function set cid(value:int):void
		{
			_cid = value;
		}

		override protected function initSkin():void
		{
			_mcBg = new McRoleProperty();
			_Loader = new RsrLoader();
			_Loader.load(_mcBg,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD,true);
			_skin = new McRole();
			_skin.x =40;
			_skin.y =55;
			addChild(_mcBg);
			_mcBg.addChild(_skin);
			_mcRoleProperty = _skin as McRole;
			_mcRoleProperty.mouseEnabled = false;
			_mc = new MovieClip();
			_mcRoleProperty.addChild(_mc);
			_mc.x = 226-40;
			_mc.y = 475-55;
			_skin.parent.mouseEnabled = false;
			_skin.mouseEnabled = false;
			setTitleBar(_mcBg.dragCell);
			_mcBg.btnNewLife.visible = false;
			_mcBg.btnProperty.visible = false;
			_mcBg.btnRole.visible = false;
			_mcRoleProperty.btnBg.visible = false;
			_mcRoleProperty.changeBtn.visible = false;
			_mcRoleProperty.mcRight.visible = false;
			_mcRoleProperty.mcHuanwuBg.visible=false;
			_mcRoleProperty.mcFashionBg.visible=false;
			_mcRoleProperty.mcWingBg.visible=false;
			_mcRoleProperty.mcDouliBg.visible=false;
			_mcRoleProperty.mcModel.mouseChildren = false;
			_mcRoleProperty.mcModel.mouseEnabled = false;
			_mcRoleProperty.mcSpoorBg.visible =false;
			_mcBg.addEventListener(MouseEvent.CLICK,clickHandle);
		}
		
		override protected function initData():void
		{
			initText();
			_equipCellHandle = new EquipCellHandle();
			_equipCellHandle.initData(_mcRoleProperty,ConstRoleType.OTHER_ROLE);
			
			_roleMouseHandle = new RoleMouseHandle(_mcRoleProperty);
			_roleMouseHandle.equipCellHandle = _equipCellHandle;
			
			_roleModelHandle = new OtherRoleModelHandle(_mcRoleProperty.mcModel);
			var sprite:Sprite = new Sprite();
			sprite.x = 220;
			sprite.y = 495;
			sprite.mouseEnabled = false;
			sprite.mouseChildren = false;
			addChild(sprite);
			_effectLoader = new UIEffectLoader(sprite,0,0,1,1,EffectConst.RES_FIGHTNUM);
		}
		
		private function clickHandle(event:MouseEvent):void
		{
			if(event.target == _mcBg.closeBtn)
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_OTHER_PLAYER);
			}

		}
		
		private function initText():void
		{
			_mcRoleProperty.hideFashion.text = "";
			_mcRoleProperty.upFight.text = "";
			_mcBg.rolePropertyText.text = StringConst.ROLE_PROPERTY_PANEL_0019;
			TextFormatManager.instance.setTextFormat(_mcBg.rolePropertyText,0xffe1aa,false,true);
		}
		
		override public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_QUERY_OTHER_PLAYER_INFO)
			{
				if(_cid == OtherPlayerDataManager.instance.cid && _sid == OtherPlayerDataManager.instance.sid)
				{
					var numPic:NumPic = new NumPic();
					_equipCellHandle.refreshEquips();
					_roleModelHandle.cid = _cid;
					_roleModelHandle.sid = _sid;
					_roleModelHandle.changeModel();
					numPic.init("fight_",OtherPlayerDataManager.instance._infoDic[_cid][_sid]["fightPower"].toString(),_mc);
					var str:String = " "+OtherPlayerDataManager.instance._infoDic[_cid][_sid]["level"]+StringConst.ROLE_HEAD_0001;
					_mcRoleProperty.nameText.text = OtherPlayerDataManager.instance._infoDic[_cid][_sid]["name"]+str;
					_mcRoleProperty.factionText.text = OtherPlayerDataManager.instance._infoDic[_cid][_sid]["familyName"];
				}			
			}
		}
		
		private function getTipData(attrType:int):String
		{
			var cfgDt:AttrCfgData = ConfigDataManager.instance.attrCfgData(attrType);
			if(cfgDt)
			{
				return HtmlUtils.createHtmlStr(0xffe1aa,cfgDt.tips);
			}
			else
			{
				return "";
			}
		}
		
		override public function destroy():void
		{
			OtherPlayerDataManager.instance.detach(this);
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
			
			_mcRoleProperty = null;
			var i:int,l:int = _skin.numChildren;
			for (i=0;i<l;i++) 
			{
				var textField:TextField = _skin.getChildAt(i) as TextField;
				if(textField)
				{
					ToolTipManager.getInstance().detach(textField);
				}
			}
			super.destroy();
		}
	}
}