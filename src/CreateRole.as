package
{
	import com.core.toArray;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.NameWordCfgData;
	import com.model.consts.JobConst;
	import com.model.consts.SexConst;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.createRole.ICreateRole;
	import com.view.gameWindow.panel.panels.guardSystem.GuardManager;
	import com.view.gameWindow.panel.panels.prompt.McPanel1BtnPrompt;
	import com.view.gameWindow.util.TimerManager;
	import com.view.gameWindow.util.UtilSetBrightness;
	import com.view.newMir.INewMir;
	import com.view.newMir.NewMirMediator;
	import com.view.newMir.prompt.PanelPromptData;
	import com.view.newMir.prompt.SimplePromptPanel;
	import com.view.newMir.sound.SoundManager;
	import com.view.newMir.sound.constants.SoundIds;
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
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	public class CreateRole extends Sprite implements ICreateRole
	{
		private var _rsrLoader:RsrLoader;
		
		private var _newMir:INewMir;
		private var _skin:McCreateRoles;

		private var _lastClickBtn:MovieClip,_job:int,_sex:int;
		private var _width:int;
		private var _height:int;
		private var mcPanelBtnPrompt:McPanel1BtnPrompt;
		private var rect:Rectangle;
		private var _time:int = 25;
		private var isAuto:Boolean = false;
		private const TOTAL_CHARACTER_LENGTH:int = 14;//游戏名字不能超过7个汉字
		public function CreateRole()
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
			
			initData();
            stage.addEventListener(KeyboardEvent.KEY_UP, onKeyBoardEvt, false, 0, true);
		}

        private function onKeyBoardEvt(event:KeyboardEvent):void
        {
            if (event.keyCode == Keyboard.ENTER)
            {
                enterGame();
            }
        }
		
		private function initData():void
		{
            this.mouseEnabled = false;
			_skin = new McCreateRoles();
			addChild(_skin);
			_rsrLoader = new RsrLoader();
			addCallBack(_rsrLoader);
			_rsrLoader.load(_skin,ResourcePathConstants.IMAGE_CREATEROLE_FOLDER_LOAD);
			_skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			_skin.contain.txt.addEventListener(Event.CHANGE, onChangeTxt, false, 0, true);
            _skin.contain.mouseEnabled = false;
			rollName();
			resetTime();
			SoundManager.getInstance().playBgSound(SoundIds.SOUND_ID_LOGIN);
		}

        private function onDoubleClick(event:MouseEvent):void
        {
            switch (event.target)
            {
                case _skin.roleBtn_00:
                case _skin.roleBtn_01:
                    enterGame();
                    break;
                default :
                    break;
            }
        }

		private var _isChineseReg:RegExp = /[^u4E00-u9FA5]/;

		private function onChangeTxt(event:Event):void
		{
			var roleName:String = _skin.contain.txt.text;
			var totalNum:int;
			var tempName:Array = [];
			var i:int = 0, len:int = 0;
			var name:String = "";
			for (i = 0, len = roleName.length; i < len; i++)
			{
				var char:String = roleName.charAt(i);
				var result:Boolean = _isChineseReg.test(char);
				result ? totalNum += 2 : totalNum++;
				tempName[totalNum] = char;
			}

			for (i = 0, len = tempName.length; i < len; i++)
			{
				if (i <= TOTAL_CHARACTER_LENGTH)
				{
					if (tempName[i])
					{
						name += tempName[i];
					}
				}
			}
			if (name.length > 0)
				_skin.contain.txt.text = name;
			resetTime();
		}
		
		private function addCallBack(rsrLoader:RsrLoader):void
		{
			var vector:Vector.<MovieClip> = Vector.<MovieClip>([_skin.contain.btnZhan,_skin.contain.btnFa,_skin.contain.btnDao]);
			_sex = Math.ceil(Math.random()*2);
			_job = Math.ceil(Math.random()*3);
			rsrLoader.addCallBack(_skin.selectRoleEffect,function (mc:MovieClip):void
			{
				if(_skin)
				{
					if (_sex == SexConst.TYPE_MALE)
					{
						_skin.selectRoleEffect.x = 485;
					} else if (_sex == SexConst.TYPE_FEMALE)
					{
						_skin.selectRoleEffect.x = _skin.roleBtn_01.x + 80;
					}
					_skin.selectRoleEffect.y = 811;
				}
			});
			rsrLoader.addCallBack(_skin.contain.btnReturn,function (mc:MovieClip):void
			{
				if(_skin)
				{
					_skin.contain.btnReturn.visible = SelectRoleDataManager.getInstance().selectRoleDatas != null;
				}
			});
			rsrLoader.addCallBack(_skin.roleBtn_01,function(mc:MovieClip):void
			{
				if(_skin)
				{
                    mc.doubleClickEnabled = true;
					_skin.roleBtn_01.mouseEnabled = true;
					_skin.roleBtn_01.gotoAndStop(_job);
                    _skin.roleBtn_01.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick, false, 0, true);
				}
				if(_sex == SexConst.TYPE_MALE)
				{
					UtilSetBrightness.setBrightness(_skin.roleBtn_01,-.3);
				}
				else if(_sex == SexConst.TYPE_FEMALE)
				{
					UtilSetBrightness.setBrightness(_skin.roleBtn_01,0);
				}
			});
			rsrLoader.addCallBack(_skin.roleBtn_00,function(mc:MovieClip):void
			{
				if(_skin)
				{
					_skin.roleBtn_00.mouseEnabled = true;
                    mc.doubleClickEnabled = true;
					_skin.roleBtn_00.gotoAndStop(_job);
                    _skin.roleBtn_00.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick, false, 0, true);
				}
				if(_sex == SexConst.TYPE_MALE)
				{
					UtilSetBrightness.setBrightness(_skin.roleBtn_00,0);
				}
				else if(_sex == SexConst.TYPE_FEMALE)
				{
					UtilSetBrightness.setBrightness(_skin.roleBtn_00,-.3);
				}
			});
			rsrLoader.addCallBack(_skin.contain.btnZhan,function(mc:MovieClip):void
			{
				if(_skin)
				{
					_skin.contain.btnZhan.mouseEnabled = true;
					if(_job == JobConst.TYPE_ZS)
					{
						_skin.contain.btnZhan.selected = true;
					}
				}
			});
			rsrLoader.addCallBack(_skin.contain.btnFa,function(mc:MovieClip):void
			{
				if(_skin)
				{
					_skin.contain.btnFa.mouseEnabled = true;
					if(_job == JobConst.TYPE_FS)
					{
						_skin.contain.btnFa.selected = true;
					}
				}		
			});
			rsrLoader.addCallBack(_skin.contain.btnDao,function(mc:MovieClip):void
			{
				if(_skin)
				{
					_skin.contain.btnDao.mouseEnabled = true;
					if(_job == JobConst.TYPE_DS)
					{
						_skin.contain.btnDao.selected = true;
					}
				}
			});
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _skin.contain.btnRoll:
					rollName();
					break;
				case _skin.contain.btnEnter:
                    enterGame();
					break;
				case _skin.contain.btnReturn:
					_newMir.dealSelectRole();
					break;
				case _skin.contain.btnZhan:
					resetTime();
					_skin.roleBtn_00.gotoAndStop(1);
					_skin.roleBtn_01.gotoAndStop(1);
					selectJob(_skin.contain.btnZhan,JobConst.TYPE_ZS);
					break;
				case _skin.contain.btnFa:
					resetTime();
					_skin.roleBtn_00.gotoAndStop(2);
					_skin.roleBtn_01.gotoAndStop(2);
					selectJob(_skin.contain.btnFa,JobConst.TYPE_FS);
					break;
				case _skin.contain.btnDao:
					resetTime();
					_skin.roleBtn_00.gotoAndStop(3);
					_skin.roleBtn_01.gotoAndStop(3);
					selectJob(_skin.contain.btnDao,JobConst.TYPE_DS);
					break;
                default :
                    break;
                case _skin.roleBtn_00:
					resetTime();
                    _sex = SexConst.TYPE_MALE;
                    _skin.selectRoleEffect.x = 485;
                    UtilSetBrightness.setBrightness(_skin.roleBtn_00, 0);
                    UtilSetBrightness.setBrightness(_skin.roleBtn_01, -.3);
//					rollName();
                    break;
                case _skin.roleBtn_01:
					resetTime();
                    _sex = SexConst.TYPE_FEMALE;
					_skin.selectRoleEffect.x = _skin.roleBtn_01.x + 80;
                    UtilSetBrightness.setBrightness(_skin.roleBtn_00, -.3);
                    UtilSetBrightness.setBrightness(_skin.roleBtn_01, 0);
//					rollName();
                    break;
			}
		}

		private function resetTime():void
		{
//			var obj:Object =  TimeUtils.calcTime3(_time);
			TimerManager.getInstance().remove(updateTime);
			_time = 25;
			_skin.contain.timeText.text = 25 + StringConst.PROMPT_PANEL_0045;
			TimerManager.getInstance().add(1000,updateTime);
		}
		
		public function updateTime():void 
		{
			_time -= 1;
//			_rewardTime = getOnlineRewardCfg().seconds - _online;
//			var num:int = int(_rewardTime/60);
			if(_skin)
			{
				if(0 >= _time)
				{
					TimerManager.getInstance().remove(updateTime); 
					enterGame();
					isAuto= true;
					_skin.contain.timeText.text = _time + StringConst.PROMPT_PANEL_0045;
					_time = 25;
					return;
				}
				_skin.contain.timeText.text = _time + StringConst.PROMPT_PANEL_0045;
			}
		}
		
        private function enterGame():void
        {
            if (_skin)
            {
                if (GuardManager.getInstance().containBannedWord(_skin.contain.txt.text) == true)
                {
                    PanelPromptData.txtName = StringConst.PROMPT_PANEL_0001;
                    PanelPromptData.txtContent = StringConst.PROMPT_PANEL_0002;
                    PanelPromptData.txtBtn = StringConst.PROMPT_PANEL_0003;
                    var prompt:SimplePromptPanel = new SimplePromptPanel();
                    prompt.init(stage);
                    return;
                }
                _newMir.newCharacter(_skin.contain.txt.text, _sex, _job);
            }
        }
		
		private function selectJob(clickBtn:MovieClip,job:int):void
		{
			_skin.contain.btnZhan.selected = false;
			_skin.contain.btnFa.selected = false;
			_skin.contain.btnDao.selected = false;
			clickBtn.selected = true;
			_job = job;
		}
		
		private function rollName():void
		{
			if(_skin)
			{
				_skin.contain.txt.text = "";
				var lastNameConfig:Array = ConfigDataManager.instance.lastNameConfig;
				var maleNameConfig:Array = ConfigDataManager.instance.maleNameConfig;
				var femaleNameConfig:Array = ConfigDataManager.instance.femaleNameConfig;
				var nameWordConfig:Dictionary = ConfigDataManager.instance.nameWordConfig;
				var maleArr:Array = [], femaleArr:Array = [];
				toArray(nameWordConfig, maleArr, function (item:NameWordCfgData):Boolean
				{
					return item.sex != SexConst.TYPE_FEMALE;
				});
				toArray(nameWordConfig, femaleArr, function (item:NameWordCfgData):Boolean
				{
					return item.sex != SexConst.TYPE_MALE;
				});
				var randomName:String = "";
				while (true)
				{
					var randomValue:Number = Math.random();
					if(_sex == SexConst.TYPE_MALE)
					{
						if (randomValue > .5)
						{
							randomName = lastNameConfig[int(Math.random() * lastNameConfig.length)] + maleNameConfig[int(Math.random() * maleNameConfig.length)];
						} else
						{
							randomName = maleArr[int(Math.random() * maleArr.length)].word;
						}
					}
					else if(_sex == SexConst.TYPE_FEMALE)
					{
						if (randomValue > .5)
						{
							randomName = lastNameConfig[int(Math.random() * lastNameConfig.length)] + femaleNameConfig[int(Math.random() * femaleNameConfig.length)];
						} else
						{
							randomName = femaleArr[int(Math.random() * femaleArr.length)].word;
						}
					}
					if (GuardManager.getInstance().containBannedWord(randomName))
					{
						continue;
					}
					_skin.contain.txt.text = randomName;
					break;
				}
			}
		}
		
		public function resize(newWidth:int, newHeight:int):void
		{
			_width = newWidth;
			_height = newHeight;
			_skin.x = (_width - _skin.width)/2;
			_skin.y = (_height - _skin.height)/2;
			_skin.layer.y = -_skin.y;
			_skin.contain.y = _height - 317-_skin.y;
			if(mcPanelBtnPrompt)
			{
				mcPanelBtnPrompt.x = int((_width - rect.width)*.5);
				mcPanelBtnPrompt.y = int((_height - rect.height)*.5);
			}
		}
		
		public function refreshData():void
		{
			var vector:Vector.<MovieClip> = Vector.<MovieClip>([_skin.contain.btnZhan,_skin.contain.btnFa,_skin.contain.btnDao]);
			_sex = Math.ceil(Math.random()*2);
			_job = Math.ceil(Math.random()*3);
			_skin.contain.btnReturn.visible = SelectRoleDataManager.getInstance().selectRoleDatas != null;
		}
		
		public function set newMir(value:INewMir):void
		{
			_newMir = value;
			SoundManager.getInstance().newMir = value;
		}
		
		public function dealName():void
		{
			if(isAuto)
			{
				rollName();
				enterGame();
			}
			else
			{
				PanelPromptData.txtName = StringConst.PROMPT_PANEL_0001;
				PanelPromptData.txtContent = StringConst.PROMPT_PANEL_0004;
				PanelPromptData.txtBtn = StringConst.PROMPT_PANEL_0003;
				NewMirMediator.getInstance().showNameExist();
			}
			
		}
		
		public function destroy():void
		{
			rect = null;
			mcPanelBtnPrompt = null;
			_lastClickBtn = null;
			if(_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK,onClick);
				_skin.contain.txt.removeEventListener(Event.CHANGE, onChangeTxt);
                if (_skin.roleBtn_00)
                    _skin.roleBtn_00.removeEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
                if (_skin.roleBtn_01)
                    _skin.roleBtn_01.removeEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
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