package
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.consts.HeadConst;
    import com.model.consts.JobConst;
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.panels.prompt.McPanel2BtnPrompt;
    import com.view.gameWindow.util.Cover;
    import com.view.gameWindow.util.UtilSetBrightness;
    import com.view.newMir.INewMir;
    import com.view.newMir.sound.SoundManager;
    import com.view.newMir.sound.constants.SoundIds;
    import com.view.selectRole.ISelectRole;
    import com.view.selectRole.Panel2BtnPromotMouseHandle;
    import com.view.selectRole.SelectRoleData;
    import com.view.selectRole.SelectRoleDataManager;
    
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageQuality;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.system.Security;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.ui.Keyboard;

    public class SelectRole extends Sprite implements ISelectRole
	{
		private var _rsrLoader:RsrLoader;
		
		private var _newMir:INewMir;
		private var _skin:McSelectRoles;
		private var _width:int;
		private var _height:int;
		private var _lastClickBtn:MovieClip;
		private var selectRoleDataManager:SelectRoleDataManager = SelectRoleDataManager.getInstance();
		private var vector:Vector.<TextField>;
		private var vectorData:Vector.<SelectRoleData>; 
		private var vectorRole:Vector.<MovieClip>;
		private var vectorSelectRole:Vector.<MovieClip>;
		private var _numChildren:int;
		private var mcPanelBtnPrompt:McPanel2BtnPrompt;
		private var rect:Rectangle;
		
		public function SelectRole()
		{
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandle);
		}
		
		private function addToStageHandle(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandle);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.BEST;
			stage.stageFocusRect = false;//tab键不会出现黄色的框框
            stage.addEventListener(KeyboardEvent.KEY_UP, onKeyBoardEvt, false, 0, true);
			initData();
		}

        private function onKeyBoardEvt(event:KeyboardEvent):void
        {
            if (event.keyCode == Keyboard.ENTER)
            {
                if (_newMir)
                    _newMir.enterGame();
            }
        }
		
		private function initData():void
		{
			_skin = new McSelectRoles();
			addChild(_skin);
			//
			initSkinData();
			//
			loadSkin();
			//
			getRoleInfo();
			//
			_skin.addEventListener(MouseEvent.CLICK,clickHandle);
			
			SoundManager.getInstance().playBgSound(SoundIds.SOUND_ID_LOGIN);
		}
		
		private function initSkinData():void
		{
			vectorRole = Vector.<MovieClip>([_skin.roleHead_0,_skin.roleHead_1]);
			vectorData = selectRoleDataManager.selectRoleDatas;
			var roleNum:int = vectorData.length;
			for(var i:int = 0;i<roleNum;i++)
			{
				vectorRole[i].resUrl = HeadConst.getHead(vectorData[i].job,vectorData[i].sex);
			}
			//
			_skin.roleHead_0.visible = vectorData.length >= 1;
			_lastClickBtn = _skin.roleHead_0;
			selectRoleDataManager.selectCid = selectRoleDataManager.selectRoleDatas[0].cId;
			_skin.roleHead_1.visible = vectorData.length >= 2;
			_skin.mc.creatRoleBtn.visible = !_skin.roleHead_1.visible;
		}
		
		private function loadSkin():void
		{
			_rsrLoader = new RsrLoader();
			_rsrLoader.addCallBack(_skin.roleHead_0,function (mc:MovieClip):void
			{
				mc.mouseEnabled = true;
                mc.doubleClickEnabled = true;
                mc.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick, false, 0, true);
			});
			_rsrLoader.addCallBack(_skin.roleHead_1,function (mc:MovieClip):void
			{
				mc.mouseEnabled = true;
				UtilSetBrightness.setBrightness(_skin.roleHead_1,-.3);
                mc.doubleClickEnabled = true;
                mc.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick, false, 0, true);
			});
			_rsrLoader.load(_skin,ResourcePathConstants.IMAGE_SELECTROLE_FOLDER_LOAD);
		}

        private function onDoubleClick(event:MouseEvent):void
        {
            if (_newMir)
            {
                _newMir.enterGame();
            }
        }
		
		private function getRoleInfo():void
		{
			var i:int;
			var j:int;
			_numChildren = vectorData.length;
            vector = Vector.<TextField>([_skin.txt, _skin.txt2]);
			for(i = 0;i<_numChildren; i+=1)
			{
				var textFormat:TextFormat = vector[i].defaultTextFormat;
                textFormat.bold = true;
				if(vectorData[i].rein>0)
				{
					vector[i].text = vectorData[i].name + "\t[" + vectorData[i].rein+"转]"+vectorData[i].level + "级\t" + JobConst.jobName(vectorData[i].job);
				}else
				{
                	vector[i].text = vectorData[i].name + "\t\t" + vectorData[i].level + "级\t" + JobConst.jobName(vectorData[i].job);
				}
			}
			
			for(j = 1;j >= _numChildren;j-=1)
			{
				vectorRole[j].visible = false;
			}
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			var mc:MovieClip = evt.target as MovieClip;
			switch(mc)
			{
				case _skin.mc.creatRoleBtn:
					_newMir.dealCreateRole();
					break;
				case _skin.mc.inGameBtn:
					_newMir.enterGame();
					break;
				case _skin.roleHead_0:
					_skin.selectRoleEffect.x = 505;
					_lastClickBtn = mc;
					UtilSetBrightness.setBrightness(_skin.roleHead_0,0);
					UtilSetBrightness.setBrightness(_skin.roleHead_1,-.3);
					selectRoleDataManager.selectCid = selectRoleDataManager.selectRoleDatas[0].cId;
					break;
				case _skin.roleHead_1:
					_skin.selectRoleEffect.x = 1085;
					_lastClickBtn = mc;
					UtilSetBrightness.setBrightness(_skin.roleHead_0,-.3);
					UtilSetBrightness.setBrightness(_skin.roleHead_1,0);
					if(selectRoleDataManager.selectRoleDatas.length <= 1)
					{
						selectRoleDataManager.selectCid = selectRoleDataManager.selectRoleDatas[0].cId;
					}
					else
					{
						selectRoleDataManager.selectCid = selectRoleDataManager.selectRoleDatas[1].cId;
					}	
					break;
				case _skin.mc.deleteRoleBtn:
					addPrompt();
					break;
			}
		}
		/**
		 *增加删除角色提示 
		 * 
		 */		
		private function addPrompt():void
		{
			var cover:Cover = new Cover(0xff0000,0);
			mcPanelBtnPrompt = new McPanel2BtnPrompt();
			var rsrLoad:RsrLoader = new RsrLoader();
			var mouseEvent:Panel2BtnPromotMouseHandle = new Panel2BtnPromotMouseHandle();
			addChild(cover);
			rsrLoad.load(mcPanelBtnPrompt,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
			mcPanelBtnPrompt.txt.htmlText = "\n<p align='" + "center" + "'>" + StringConst.PROMPT_PANEL_0010 + "</p>";
			mcPanelBtnPrompt.sureTxt.text = StringConst.PROMPT_PANEL_0012;
			mcPanelBtnPrompt.cancelTxt.text = StringConst.PROMPT_PANEL_0013;
			mcPanelBtnPrompt.sureTxt.mouseEnabled = false;
			mcPanelBtnPrompt.cancelTxt.mouseEnabled = false;
			addChild(mcPanelBtnPrompt);
			rect = new Rectangle(0,0,mcPanelBtnPrompt.width,mcPanelBtnPrompt.height);
			mcPanelBtnPrompt.x = int((_width - rect.width)*.5);
			mcPanelBtnPrompt.y = int((_height - rect.height)*.5);
			mouseEvent.addEvent(mcPanelBtnPrompt,cover,function():void
			{
				sendDel();
				deleteRole();
			});
		}
		
		public function resize(newWidth:int, newHeight:int):void
		{
			_width = newWidth;
			_height = newHeight;
			_skin.x = (newWidth - _skin.width)/2;
			_skin.y = (newHeight - _skin.height)/2;
			_skin.mc.y = _height - 80-_skin.y;
			if(mcPanelBtnPrompt)
			{
				mcPanelBtnPrompt.x = int((_width - rect.width)*.5);
				mcPanelBtnPrompt.y = int((_height - rect.height)*.5);
			}
		}
		
		public function refreshData():void
		{
			vectorData = selectRoleDataManager.selectRoleDatas;
			_skin.selectRoleEffect.visible = vectorData.length >= 1;
			getRoleInfo();
			selectRoleDataManager.selectCid = vectorData[0].cId;
		}
		
		public function set newMir(value:INewMir):void
		{
			_newMir = value;
			SoundManager.getInstance().newMir = value;
		}
		
		private function sendDel():void
		{
			_newMir.delCharacter();
		}
		
		private function deleteRole():void
		{
			if(vectorData.length > 1)
			{
				if(_lastClickBtn == vectorRole[0])
				{
					vector[0].text = "";
					_skin.selectRoleEffect.x = 1085;
					//还需修改
					vectorData.splice(0,1);
				}
				else
				{
					vector[1].text = "";
					_skin.selectRoleEffect.x = 505;
					vectorData.splice(1,1);
				}
			}
			else
			{
				SelectRoleDataManager.getInstance().selectRoleDatas = null;
			}
			
			if(_lastClickBtn.parent)
			{
				_lastClickBtn.parent.removeChild(_lastClickBtn);
			}
			_skin.mc.creatRoleBtn.visible = true;
		}
		
		public function destroy():void
		{
			vectorSelectRole = null;
			vectorRole = null;
			vectorData = null;
			vector = null;
			_lastClickBtn = null;
			if(_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK,clickHandle);
                if (_skin.roleHead_0)
                {
                    _skin.roleHead_0.removeEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
                }
                if (_skin.roleHead_1)
                {
                    _skin.roleHead_1.removeEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
                }
			}
            if (stage)
            {
                stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyBoardEvt);
            }
			_skin = null;
			_newMir = null;
			if(parent)
			{
				parent.removeChild(this);
			}
			if(_rsrLoader)
			{
				_rsrLoader.destroy();
				_rsrLoader = null;
			}
		}
	}
}