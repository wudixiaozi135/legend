package com.view.gameWindow.tips.rollTip
{
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.panels.wing.IWingBlessPoint;
    import com.view.gameWindow.tips.rollTip.rollTips.RollTipError;
    import com.view.gameWindow.tips.rollTip.rollTips.RollTipNFKilling;
    import com.view.gameWindow.tips.rollTip.rollTips.RollTipPlacard;
    import com.view.gameWindow.tips.rollTip.rollTips.RollTipProperty;
    import com.view.gameWindow.tips.rollTip.rollTips.RollTipReward;
    import com.view.gameWindow.tips.rollTip.rollTips.RollTipSystem;
    import com.view.newMir.NewMirMediator;
    
    import flash.display.Sprite;

    public class RollTipMediator
	{
		private static var _instance:RollTipMediator;
		public static function get instance():RollTipMediator
		{
			if(!_instance)
				_instance = new RollTipMediator(new PrivateClass());
			return _instance;
		}
		
		private var _layer:Sprite;
		private var _placards:Vector.<RollTipPlacard>;
		private var _rewards:Vector.<RollTipReward>;
		private var _systems:Vector.<RollTipSystem>;
		private var _nfKillings:Vector.<RollTipNFKilling>;
		private var _bottomTip:RollTip;
		
		public function get rewards():Vector.<RollTipReward>
		{
			return _rewards;
		}
		
		
		public function RollTipMediator(pc:PrivateClass)
		{
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			_placards = new Vector.<RollTipPlacard>();
			_rewards = new Vector.<RollTipReward>();
			_systems = new Vector.<RollTipSystem>();
			_nfKillings = new Vector.<RollTipNFKilling>();
		}
		
		public function initData(layer:Sprite):void
		{
			_layer = layer;
		}
		
		public function removeBottom():void
		{
			if(_bottomTip)
			{
				_bottomTip.onComplete();
				_bottomTip = null;
			}
		}
		
		/**
		 * @param isBottom true 一直沉底 只简单做只有一条信息沉底 ，而且现在只有SYSTEM会沉底
		 */
		public function showRollTip(type:int,text:String,isBottom:Boolean = false):void
		{
			var isNewBottom:Boolean = type == RollTipType.SYSTEM && isBottom;
			if(isNewBottom)
			{
				removeBottom();
			}
			
			var rollTip:RollTip = initRollTip(type,text);
			if(rollTip)
			{
				rollTip.isBottom = isBottom;
				initPos(type,rollTip);
				if(isNewBottom)
				{
					_bottomTip = rollTip;
				}
				doDeal(type,rollTip);
			}
		}
		
		private function initRollTip(type:int,text:String):RollTip
		{
			switch(type)
			{
				case RollTipType.PLACARD:
					return new RollTipPlacard(text);
				case RollTipType.SYSTEM:
					return new RollTipSystem(text);
				case RollTipType.REWARD:
					return new RollTipReward(text);
				case RollTipType.PROPERTY:
					return new RollTipProperty(text);
				case RollTipType.NFKILLING:
					return new RollTipNFKilling(text);
                case RollTipType.PROPERTY_WING_BLESS:
                    return new RollTipProperty(text);
				default:
				case RollTipType.ERROR:
					return new RollTipError(text);
			}
		}
		
		public function resize():void
		{
			if(_bottomTip)
			{
				_bottomTip.x = Math.round((_layer.stage.stageWidth - _bottomTip.width)*.5);
				_bottomTip.y = Math.round(_layer.stage.stageHeight - 220);
			}
		}
		
		private function initPos(type:int,rollTip:RollTip):void
		{
			switch(type)
			{
				case RollTipType.PLACARD:
					rollTip.x = Math.round((_layer.stage.stageWidth - rollTip.width)*.5);
					rollTip.y = 150;
					break;
				case RollTipType.SYSTEM:
					rollTip.x = Math.round((_layer.stage.stageWidth - rollTip.width)*.5);
					rollTip.y = Math.round(_layer.stage.stageHeight - 220 - (_bottomTip ? RollTipSystem.SPACING : 0)) ;
					break;
				case RollTipType.ERROR:
					rollTip.x = Math.round(_layer.mouseX - rollTip. width*.5);
					rollTip.y = Math.round(_layer.mouseY - rollTip.height);
					if(rollTip.x<0)
						rollTip.x =0;
					else if(rollTip.x+rollTip.width>_layer.stage.stageWidth)
						rollTip.x = _layer.stage.stageWidth - rollTip.width;
					break;
				case RollTipType.REWARD:
					rollTip.x = Math.round((_layer.stage.stageWidth - rollTip.width)*.5);
					rollTip.y = Math.round((_layer.stage.stageHeight - rollTip.height)*.5);
					break;
				case RollTipType.PROPERTY:
					rollTip.x = Math.round((_layer.stage.stageWidth - rollTip.width)*.5 +200);
					rollTip.y = Math.round((_layer.stage.stageHeight - rollTip.height)*.5);
					break;
				case RollTipType.NFKILLING:
					rollTip.x = 0;
					var theY:int = NewMirMediator.getInstance().gameWindow.mainUiMediator.chatFrame.theY;
					rollTip.y = Math.round(theY - rollTip.height);
					break;
                case RollTipType.PROPERTY_WING_BLESS:
                    var wingPoint:IWingBlessPoint = NewMirMediator.getInstance().gameWindow.panelMediator().openedPanel(PanelConst.TYPE_WING) as IWingBlessPoint;
                    if (wingPoint && wingPoint.point)
                    {
                        rollTip.x = wingPoint.point.x + 50;
                        rollTip.y = wingPoint.point.y - 20;
                    }
                    break;
				default:
					break;
			}
			_layer.addChild(rollTip);
		}
		
		private function getRightTip(list:*):RollTip
		{
			for each(var tip:RollTip in list)
			{
				if(!tip.isBottom)
				{
					return tip;
				}
			}
			
			return list[0];
		}
		
		private function doDeal(type:int,rollTip:RollTip):void
		{
			var rollTipExist:RollTip,rollTipRemove:RollTip;
			if(type == RollTipType.PLACARD)
			{
				if(_placards.length >= 3)
				{
					rollTipRemove = _placards[0];
					rollTipRemove.onComplete();
				}
				for each(rollTipExist in _placards)
				{
					rollTipExist.move();
				}
				_placards.push(rollTip);
			}
			else if(type == RollTipType.REWARD)
			{
				if(_rewards.length >= 5)
				{
					rollTipRemove = _rewards[0];
					rollTipRemove.onComplete();
				}
				for each(rollTipExist in _rewards)
				{
					rollTipExist.move();
				}
				_rewards.push(rollTip);
			}
			else if(type == RollTipType.SYSTEM)
			{
				if(_systems.length >= 4)
				{
					rollTipRemove = getRightTip(_systems);
					rollTipRemove.onComplete();
				}
				for each(rollTipExist in _systems)
				{
					rollTipExist.move();
				}
				_systems.push(rollTip);
			}
			else if(type == RollTipType.NFKILLING)
			{
				if(_nfKillings.length >= 2)
				{
					rollTipRemove = _nfKillings[0];
					rollTipRemove.onComplete();
				}
				for each(rollTipExist in _nfKillings)
				{
					rollTipExist.move();
				}
				_nfKillings.push(rollTip);
			}
			rollTip.deal();
		}
		
		public function removeRolltip(rollTip:RollTip):void
		{
			var indexOf:int;
			if(rollTip is RollTipPlacard)
			{
				indexOf = _placards.indexOf(rollTip);
				if(indexOf != -1)
				{
					_placards.splice(indexOf,1);
				}
			}
			else if(rollTip is RollTipReward)
			{
				indexOf = _rewards.indexOf(rollTip);
				if(indexOf != -1)
				{
					_rewards.splice(indexOf,1);
				}
			}
			else if(rollTip is RollTipSystem)
			{
				indexOf = _systems.indexOf(rollTip);
				if(indexOf != -1)
				{
					_systems.splice(indexOf,1);
				}
			}
			else if(rollTip is RollTipNFKilling)
			{
				indexOf = _nfKillings.indexOf(rollTip);
				if(indexOf != -1)
				{
					_nfKillings.splice(indexOf,1);
				}
			}
		}
	}
}

class PrivateClass{}