package com.view.gameWindow.scene.entity.model.base
{
	import com.view.gameWindow.scene.entity.constants.ActionTypes;
	import com.view.gameWindow.scene.entity.model.imageItem.ImageItem;
	

	public class EntityModel
	{
		public static const N_DIRECTION_1:int = 1;
		public static const N_DIRECTION_5:int = 5;
		public static const N_DIRECTION_8:int = 8;
		
		protected var _hairUrl:String;
		protected var _largeWingUrl:String;
		protected var _smallWingUrl:String;
		protected var _clothUrl:String;
		protected var _weaponUrl:String;
		protected var _weaponEffectUrl:String;
		protected var _handEffectUrl:String;
		protected var _shieldUrl:String;
		
		protected var _mountType:int;
		/**
		 *  可以显示，但是不一定完全准备好了。比如关联坐骑的模型，坐骑未下载好的时候，available，但是没有ready
		 */		
		protected var _available:Boolean;
		protected var _nUse:int;
		
		protected var _nDirection:int;
		
		protected var _unReadyImageItems:Vector.<ImageItem>;//当该数组为空时说明已经全部准备好了
		protected var _imageItems:Vector.<ImageItem>;
		
		protected var _nFrame:int;
		protected var _width:int;
		protected var _height:int;
		protected var _directions:int;
		protected var _modelHeight:int;
		protected var _shadowOffset:int;
		protected var _idle:int;
		protected var _run:int;
		protected var _hurt:int;
		protected var _dead:int;
		protected var _pattack:int;
		protected var _mattack:int;
		protected var _rushidle:int;
		protected var _rush:int;
		protected var _walk:int;
		protected var _unknow1:int;
		protected var _jointattack:int;
		protected var _sunbathe:int;
		protected var _footsie:int;
		protected var _massage:int;
		protected var _beMassage:int;
		protected var _unknow2:int;
		protected var _unknow3:int;
		protected var _unknow4:int;
		protected var _unknow5:int;
		protected var _unknow6:int;
		protected var _gather:int;
		protected var _reveal:int;
		protected var _unknow8:int;
		protected var _unknow9:int;
		protected var _unknow10:int;
		protected var _unknow11:int;
		protected var _unknow12:int;
		protected var _unknow13:int;
		protected var _unknow14:int;
		protected var _unknow15:int;
		protected var _unknow16:int;
		
		protected var _idleFrameRate:int;
		protected var _runFrameRate:int;
		protected var _hurtFrameRate:int;
		protected var _deadFrameRate:int;
		protected var _pattackFrameRate:int;
		protected var _mattackFrameRate:int;
		protected var _rushidleFrameRate:int;
		protected var _rushFrameRate:int;
		protected var _walkFrameRate:int;
		protected var _unknow1FrameRate:int;
		protected var _jointattackFrameRate:int;
		protected var _sunbatheFrameRate:int;
		protected var _footsieFrameRate:int;
		protected var _massageFrameRate:int;
		protected var _beMassageFrameRate:int;
		protected var _unknow2FrameRate:int;
		protected var _unknow3FrameRate:int;
		protected var _unknow4FrameRate:int;
		protected var _unknow5FrameRate:int;
		protected var _unknow6FrameRate:int;
		protected var _gatherFrameRate:int;
		protected var _revealFrameRate:int;
		protected var _unknow8FrameRate:int;
		protected var _unknow9FrameRate:int;
		protected var _unknow10FrameRate:int;
		protected var _unknow11FrameRate:int;
		protected var _unknow12FrameRate:int;
		protected var _unknow13FrameRate:int;
		protected var _unknow14FrameRate:int;
		protected var _unknow15FrameRate:int;
		protected var _unknow16FrameRate:int;
		
		protected var _idleStart:int;
		protected var _runStart:int;
		protected var _hurtStart:int;
		protected var _deadStart:int;
		protected var _pattackStart:int;
		protected var _mattackStart:int;
		protected var _rushidleStart:int;
		protected var _rushStart:int;
		protected var _walkStart:int;
		protected var _unknow1Start:int;
		protected var _jointattackStart:int;
		protected var _sunbatheStart:int;
		protected var _footsieStart:int;
		protected var _massageStart:int;
		protected var _beMassageStart:int;
		protected var _unknow2Start:int;
		protected var _unknow3Start:int;
		protected var _unknow4Start:int;
		protected var _unknow5Start:int;
		protected var _unknow6Start:int;
		protected var _gatherStart:int;
		protected var _revealStart:int;
		
		protected var _idleEnd:int;
		protected var _runEnd:int;
		protected var _hurtEnd:int;
		protected var _deadEnd:int;
		protected var _pattackEnd:int;
		protected var _mattackEnd:int;
		protected var _rushidleEnd:int;
		protected var _rushEnd:int;
		protected var _walkEnd:int;
		protected var _unknow1End:int;
		protected var _jointattackEnd:int;
		protected var _sunbatheEnd:int;
		protected var _footsieEnd:int;
		protected var _massageEnd:int;
		protected var _beMassageEnd:int;
		protected var _unknow2End:int;
		protected var _unknow3End:int;
		protected var _unknow4End:int;
		protected var _unknow5End:int;
		protected var _unknow6End:int;
		protected var _gatherEnd:int;
		protected var _revealEnd:int;
		
		protected var _baseLayer:EntityModel;
		
		public var blendModeType:int;
		
		public function EntityModel()
		{
//			_ready = false;
			_available = false;
			_nUse = 0;
		}
		
//		public function get ready():Boolean
//		{
//			return _ready;
//		}
		
		public function checkReadyByActionIdAndDirection(actionId:int, direction:int):Boolean
		{
			return false;
		}
		
		public function get available():Boolean
		{
			return _available;
		}
		
		public function get nUse():int
		{
			return _nUse;
		}
		
		public function set nUse(value:int):void
		{
			_nUse = value;
			
			if (_nUse <= 0)
			{
				destroy();
			}
		}
		
		public function isMatch(clothUrl:String, hairUrl:String, largeWingUrl:String, smallWingUrl:String, weaponUrl:String, weaponEffectUrl:String, handEffectUrl:String, shieldUrl:String):Boolean
		{
			return (_clothUrl == clothUrl || !_clothUrl && !clothUrl)
				&& (_hairUrl == hairUrl || !_hairUrl && !hairUrl)
				&& (_largeWingUrl == largeWingUrl || !_largeWingUrl && !largeWingUrl)
				&& (_smallWingUrl == smallWingUrl || !_smallWingUrl && !smallWingUrl)
				&& (_weaponUrl == weaponUrl || !_weaponUrl && !weaponUrl)
				&& (_weaponEffectUrl == weaponEffectUrl || !_weaponEffectUrl && !weaponEffectUrl)
				&& (_handEffectUrl == handEffectUrl || !_handEffectUrl && !handEffectUrl)
				&& (_shieldUrl == shieldUrl || !_shieldUrl && !shieldUrl);
		}
		
		public function init():void
		{
		}
		
		public function getImageItemByFrame(iFrame:int):ImageItem
		{
			try{
				if (_imageItems && iFrame < _imageItems.length)
				{
					return _imageItems[iFrame];
				}
				return null;
			}
			catch(e:Error)
			{
				trace("_wingUrl = " + _largeWingUrl);
				trace("_wingUrl = " + _hairUrl);
				trace("_clothUrl = " + _clothUrl);
				trace("_weaponUrl = " + _weaponUrl);
				trace("_shieldUrl = " + _shieldUrl);
				trace(e.message + " in EntityModel.getImageItemByFrame");
				
			}
			return null;
		}
		
		public function get clothUrl():String
		{
			return _clothUrl;
		}
		
		public function get nFrame():int
		{
			return _nFrame;
		}
		
		public function get width():int
		{
			return _width;
		}
		
		public function get height():int
		{
			return _height;
		}
		
		public function get directions():int
		{
			return _directions;
		}
		
		public function get modelHeight():int
		{
			return _modelHeight;
		}
		
		public function get shadowOffset():int
		{
			return _shadowOffset;
		}
		
		public function get idle():int
		{
			return _idle;
		}
		
		public function get run():int
		{
			return _run;
		}
		
		public function get hurt():int
		{
			return _hurt;
		}
		
		public function get dead():int
		{
			return _dead;
		}
		
		public function get pattack():int
		{
			return _pattack;
		}
		
		public function get mattack():int
		{
			return _mattack;
		}
		
		public function get rushidle():int
		{
			return _rushidle;
		}
		
		public function get rush():int
		{
			return _rush;
		}
		
		public function get walk():int
		{
			return _walk;
		}
		
		public function get unknow1():int
		{
			return _unknow1;
		}
		
		public function get jointattack():int
		{
			return _jointattack;
		}
		
		public function get sunbathe():int
		{
			return _sunbathe;
		}
		
		public function get footsie():int
		{
			return _footsie;
		}
		
		public function get massage():int
		{
			return _massage;
		}
		
		public function get beMassage():int
		{
			return _beMassage;
		}
		
		public function get unknow2():int
		{
			return _unknow2;
		}
		
		public function get unknow3():int
		{
			return _unknow3;
		}
		
		public function get unknow4():int
		{
			return _unknow4;
		}
		
		public function get unknow5():int
		{
			return _unknow5;
		}
		
		public function get unknow6():int
		{
			return _unknow6;
		}
		
		public function get gather():int
		{
			return _gather;
		}
		
		public function get reveal():int
		{
			return _reveal;
		}
		
		public function get idleFrameRate():int
		{
			return _idleFrameRate;
		}
		
		public function get runFrameRate():int
		{
			return _runFrameRate;
		}
		
		public function get hurtFrameRate():int
		{
			return _hurtFrameRate;
		}
		
		public function get deadFrameRate():int
		{
			return _deadFrameRate;
		}
		
		public function get pattackFrameRate():int
		{
			return _pattackFrameRate;
		}
		
		public function get mattackFrameRate():int
		{
			return _mattackFrameRate;
		}
		
		public function get rushidleFrameRate():int
		{
			return _rushidleFrameRate;
		}
		
		public function get rushFrameRate():int
		{
			return _rushFrameRate;
		}
		
		public function get walkFrameRate():int
		{
			return _walkFrameRate;
		}
		
		public function get unknow1FrameRate():int
		{
			return _unknow1FrameRate;
		}
		
		public function get jointattackFrameRate():int
		{
			return _jointattackFrameRate;
		}
		
		public function get sunbatheFrameRate():int
		{
			return _sunbatheFrameRate;
		}
		
		public function get footsieFrameRate():int
		{
			return _footsieFrameRate;
		}
		
		public function get massageFrameRate():int
		{
			return _massageFrameRate;
		}
		
		public function get beMassageFrameRate():int
		{
			return _beMassageFrameRate;
		}
		
		public function get unknow2FrameRate():int
		{
			return _unknow2FrameRate;
		}
		
		public function get unknow3FrameRate():int
		{
			return _unknow3FrameRate;
		}
		
		public function get unknow4FrameRate():int
		{
			return _unknow4FrameRate;
		}
		
		public function get unknow5FrameRate():int
		{
			return _unknow5FrameRate;
		}
		
		public function get unknow6FrameRate():int
		{
			return _unknow6FrameRate;
		}
		
		public function get gatherFrameRate():int
		{
			return _gatherFrameRate;
		}
		
		public function get revealFrameRate():int
		{
			return _revealFrameRate;
		}
		
		public function get idleStart():int
		{
			return _idleStart;
		}
		
		public function get runStart():int
		{
			return _runStart;
		}
		
		public function get hurtStart():int
		{
			return _hurtStart;
		}
		
		public function get deadStart():int
		{
			return _deadStart;
		}
		
		public function get pattackStart():int
		{
			return _pattackStart;
		}
		
		public function get mattackStart():int
		{
			return _mattackStart;
		}
		
		public function get rushidleStart():int
		{
			return _rushidleStart;
		}
		
		public function get rushStart():int
		{
			return _rushStart;
		}
		
		public function get walkStart():int
		{
			return _walkStart;
		}
		
		public function get unknow1Start():int
		{
			return _unknow1Start;
		}
		
		public function get jointattackStart():int
		{
			return _jointattackStart;
		}
		
		public function get sunbatheStart():int
		{
			return _sunbatheStart;
		}
		
		public function get footsieStart():int
		{
			return _footsieStart;
		}
		
		public function get massageStart():int
		{
			return _massageStart;
		}
		
		public function get beMassageStart():int
		{
			return _beMassageStart;
		}
		
		public function get unknow2Start():int
		{
			return _unknow2Start;
		}
		
		public function get unknow3Start():int
		{
			return _unknow3Start;
		}
		
		public function get unknow4Start():int
		{
			return _unknow4Start;
		}
		
		public function get unknow5Start():int
		{
			return _unknow5Start;
		}
		
		public function get unknow6Start():int
		{
			return _unknow6Start;
		}
		
		public function get gatherStart():int
		{
			return _gatherStart;
		}
		
		public function get revealStart():int
		{
			return _revealStart;
		}
		
		public function get idleEnd():int
		{
			return _idleEnd;
		}
		
		public function get runEnd():int
		{
			return _runEnd;
		}
		
		public function get hurtEnd():int
		{
			return _hurtEnd;
		}
		
		public function get deadEnd():int
		{
			return _deadEnd;
		}
		
		public function get pattackEnd():int
		{
			return _pattackEnd;
		}
		
		public function get mattackEnd():int
		{
			return _mattackEnd;
		}
		
		public function get rushidleEnd():int
		{
			return _rushidleEnd;
		}
		
		public function get rushEnd():int
		{
			return _rushEnd;
		}
		
		public function get walkEnd():int
		{
			return _walkEnd;
		}
		
		public function get unknow1End():int
		{
			return _unknow1End;
		}
		
		public function get jointattackEnd():int
		{
			return _jointattackEnd;
		}
		
		public function get sunbatheEnd():int
		{
			return _sunbatheEnd;
		}
		
		public function get footsieEnd():int
		{
			return _footsieEnd;
		}
		
		public function get massageEnd():int
		{
			return _massageEnd;
		}
		
		public function get beMassageEnd():int
		{
			return _beMassageEnd;
		}
		
		public function get unknow2End():int
		{
			return _unknow2End;
		}
		
		public function get unknow3End():int
		{
			return _unknow3End;
		}
		
		public function get unknow4End():int
		{
			return _unknow4End;
		}
		
		public function get unknow5End():int
		{
			return _unknow5End;
		}
		
		public function get unknow6End():int
		{
			return _unknow6End;
		}
		
		public function get gatherEnd():int
		{
			return _gatherEnd;
		}
		
		public function get revealEnd():int
		{
			return _revealEnd;
		}
		
		protected function initInfoBySelf():void
		{
			_idleStart=0;
			_idleEnd=_idle-1;
			_runStart = _idleEnd + 1;
			_runEnd = _runStart + _run - 1;
			_hurtStart = _runEnd + 1;
			_hurtEnd = _hurtStart + _hurt - 1;
			_deadStart = _hurtEnd + 1;
			_deadEnd = _deadStart + _dead - 1;
			_pattackStart = _deadEnd + 1;
			_pattackEnd = _pattackStart + _pattack - 1;
			_mattackStart = _pattackEnd + 1;
			_mattackEnd = _mattackStart + _mattack - 1;
			_rushidleStart = _mattackEnd + 1;
			_rushidleEnd = _rushidleStart + _rushidle - 1;
			_rushStart = _rushidleEnd + 1;
			_rushEnd = _rushStart + _rush - 1;
			_walkStart = _rushEnd + 1;
			_walkEnd = _walkStart + _walk - 1;
			_unknow1Start = _walkEnd + 1;
			_unknow1End = _unknow1Start + _unknow1 - 1;
			_jointattackStart = _unknow1End + 1;
			_jointattackEnd = _jointattackStart + _jointattack - 1;
			_sunbatheStart = _jointattackEnd + 1;
			_sunbatheEnd = _sunbatheStart + _sunbathe - 1;
			_footsieStart = _sunbatheEnd + 1;
			_footsieEnd = _footsieStart + _footsie - 1;
			_massageStart = _footsieEnd + 1;
			_massageEnd = _massageStart + _massage - 1;
			_beMassageStart = _massageEnd + 1;
			_beMassageEnd = _beMassageStart + _beMassage - 1;
			_unknow2Start = _beMassageEnd + 1;
			_unknow2End = _unknow2Start + _unknow2 - 1;
			_unknow3Start = _unknow2End + 1;
			_unknow3End = _unknow3Start + _unknow3 - 1;
			_unknow4Start = _unknow3End + 1;
			_unknow4End = _unknow4Start + _unknow4 - 1;
			_unknow5Start = _unknow4End + 1;
			_unknow5End = _unknow5Start + _unknow5 - 1;
			_unknow6Start = _unknow5End + 1;
			_unknow6End = _unknow6Start + _unknow6 - 1;
			_gatherStart = _unknow6End + 1;
			_gatherEnd = _gatherStart + _gather - 1;
			_revealStart = _gatherEnd + 1;
			_revealEnd = _revealStart + _reveal - 1;
		}
		
		protected function iFrameToActionId(iFrame:int):int
		{
			var dirFrame:int = iFrame - int(iFrame / _nFrame) * _nFrame;
			if (dirFrame <= _idleEnd)
			{
				return ActionTypes.IDLE;
			}
			else if (dirFrame <= _runEnd)
			{
				return ActionTypes.RUN;
			}
			else if (dirFrame <= _hurtEnd)
			{
				return ActionTypes.HURT;
			}
			else if (dirFrame <= _deadEnd)
			{
				return ActionTypes.DIE;
			}
			else if (dirFrame <= _pattackEnd)
			{
				return ActionTypes.PATTACK;
			}
			else if (dirFrame <= _mattackEnd)
			{
				return ActionTypes.MATTACK;
			}
			else if (dirFrame <= _rushidleEnd)
			{
				return ActionTypes.RUSH_IDLE;
			}
			else if (dirFrame <= _rushEnd)
			{
				return ActionTypes.RUSH;
			}
			else if (dirFrame <= _walkEnd)
			{
				return ActionTypes.WALK;
			}
			else if (dirFrame <= _unknow1End)
			{
				return ActionTypes.UNKNOW1;
			}
			else if (dirFrame <= _jointattackEnd)
			{
				return ActionTypes.JOINT_ATTACK;
			}
			else if (dirFrame <= _sunbatheEnd)
			{
				return ActionTypes.SUNBATHE;
			}
			else if (dirFrame <= _footsieEnd)
			{
				return ActionTypes.FOOTSIE;
			}
			else if (dirFrame <= _massageEnd)
			{
				return ActionTypes.MASSAGE;
			}
			else if (dirFrame <= _beMassageEnd)
			{
				return ActionTypes.BE_MASSAGE;
			}
			else if (dirFrame <= _unknow2End)
			{
				return ActionTypes.UNKNOW2;
			}
			else if (dirFrame <= _unknow3End)
			{
				return ActionTypes.UNKNOW3;
			}
			else if (dirFrame <= _unknow4End)
			{
				return ActionTypes.UNKNOW4;
			}
			else if (dirFrame <= _unknow5End)
			{
				return ActionTypes.UNKNOW5;
			}
			else if (dirFrame <= _unknow6End)
			{
				return ActionTypes.UNKNOW6;
			}
			else if (dirFrame <= _gatherEnd)
			{
				return ActionTypes.GATHER;
			}
			else if (dirFrame <= _revealEnd)
			{
				return ActionTypes.REVEAL;
			}
			return ActionTypes.IDLE;
		}
		
		protected function getActionStartFrame(actionId:int):int
		{
			switch (actionId)
			{
				case ActionTypes.IDLE:
					return _idleStart;
				case ActionTypes.RUN:
					return _runStart;
				case ActionTypes.HURT:
					return _hurtStart;
				case ActionTypes.DIE:
					return _deadStart;
				case ActionTypes.PATTACK:
					return _pattackStart;
				case ActionTypes.MATTACK:
					return _mattackStart;
				case ActionTypes.RUSH_IDLE:
					return _rushidleStart;
				case ActionTypes.RUSH:
					return _rushStart;
				case ActionTypes.WALK:
					return _walkStart;
				case ActionTypes.JOINT_ATTACK:
					return _jointattackStart;
				case ActionTypes.SUNBATHE:
					return _sunbatheStart;
				case ActionTypes.FOOTSIE:
					return _footsieStart;
				case ActionTypes.MASSAGE:
					return _massageStart;
				case ActionTypes.BE_MASSAGE:
					return _beMassageStart;
				case ActionTypes.UNKNOW2:
					return _unknow2Start;
				case ActionTypes.UNKNOW3:
					return _unknow3Start;
				case ActionTypes.UNKNOW4:
					return _unknow4Start;
				case ActionTypes.UNKNOW5:
					return _unknow5Start;
				case ActionTypes.UNKNOW6:
					return _unknow6Start;
				case ActionTypes.GATHER:
					return _gatherStart;
				case ActionTypes.REVEAL:
					return _revealStart;
			}
			return 0;
		}
		
		protected function getNActionFrame(actionId:int):int
		{
			switch (actionId)
			{
				case ActionTypes.IDLE:
					return _idle;
				case ActionTypes.RUN:
					return _run;
				case ActionTypes.HURT:
					return _hurt;
				case ActionTypes.DIE:
					return _dead;
				case ActionTypes.PATTACK:
					return _pattack;
				case ActionTypes.MATTACK:
					return _mattack;
				case ActionTypes.RUSH_IDLE:
					return _rushidle;
				case ActionTypes.RUSH:
					return _rush;
				case ActionTypes.WALK:
					return _walk;
				case ActionTypes.JOINT_ATTACK:
					return _jointattack;
				case ActionTypes.SUNBATHE:
					return _sunbathe;
				case ActionTypes.FOOTSIE:
					return _footsie;
				case ActionTypes.MASSAGE:
					return _massage;
				case ActionTypes.BE_MASSAGE:
					return _beMassage;
				case ActionTypes.UNKNOW2:
					return _unknow2;
				case ActionTypes.UNKNOW3:
					return _unknow3;
				case ActionTypes.UNKNOW4:
					return _unknow4;
				case ActionTypes.UNKNOW5:
					return _unknow5;
				case ActionTypes.UNKNOW6:
					return _unknow6;
				case ActionTypes.GATHER:
					return _gather;
				case ActionTypes.REVEAL:
					return _reveal;
			}
			return 0;
		}
		
		protected function initInfoByBase():void
		{
		}
		
		protected function clearImageItems():void
		{
			if (_imageItems)
			{
				for each (var imageItem:ImageItem in _imageItems)
				{
					if (imageItem)
					{
						imageItem.destroy();
					}
				}
				_imageItems.length = 0;
				_imageItems = null;
			}
		}
		
		public function destroy():void
		{
			clearImageItems();
			_available = false;
		}
	}
}