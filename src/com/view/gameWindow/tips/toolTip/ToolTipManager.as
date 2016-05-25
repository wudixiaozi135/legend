package com.view.gameWindow.tips.toolTip
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.consts.ToolTipConst;
    import com.model.gameWindow.mem.MemEquipData;
    import com.model.gameWindow.mem.MemEquipDataManager;
    import com.view.gameWindow.tips.toolTip.interfaces.IToolTipClient;
    
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.utils.Dictionary;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;

    /**
	 * tip统一管理类
	 * @author jhj
	 */
	public class ToolTipManager
	{
		private static var _instance:ToolTipManager;
		public static function getInstance():ToolTipManager
		{
			return _instance ||= new ToolTipManager(new PrivateClass());
		}
		
		private var _downObj:DisplayObject;
		private var _stage:Stage;
		/**要显示tip对象管理 */		
		private var _map:Dictionary;
		/**没有实现tip接口的tip数据 */		
		private var _tipInfo:Dictionary;
		private var _tipType:int;
		private var _timeId:int = 0;

		public function ToolTipManager(instance:PrivateClass)
		{
			_map = new Dictionary();
			_tipInfo = new Dictionary();
		}
		
		public function setStage(stage:Stage):void
		{
			_stage=stage;
		}
		/**
		 * 使用tipVO注册tip
		 * @param cls
		 * @param tipType
		 * @param tipData
		 * @param tipDataValue 若tipData为函数则该值为对应传入的参数
		 * @param completeTipeType 0 为不同装备类型比对   1为同种装备的不同强化等级比对
		 * @param downHide 是否添加down事件，true添加
		 */		
		public function attachByTipVO(cls:DisplayObject,tipType:int,tipData:Object,tipDataValue:* = null,completeTipeType:int = 0,downHide:Boolean=true,tipCount:int = 1):TipVO
		{
			var tipVO:TipVO = new TipVO();
			tipVO.tipType = tipType;
			tipVO.tipData = tipData;
			tipVO.tipDataValue = tipDataValue;
			tipVO.completeTipeType = completeTipeType;
			tipVO.tipCount = tipCount;
			hashTipInfo(cls,tipVO);
			attach(cls,downHide);
			return tipVO;
		}
		/**
		 * 注册要显示tip的对象
		 * @param cls
		 * @param downHide 是否在按下鼠标的时候隐藏
		 * @param mouseOverHide 当鼠标移动到气泡上的时候是否隐藏
		 */		
		public function attach(cls:DisplayObject,downHide:Boolean=true,mouseOverHide:Boolean=true):void
		{
			if(!cls||_map[cls])
			{
				return;
			}
			_map[cls] = cls;
			if(mouseOverHide)
			{
				cls.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler, false, 0 ,true);
			}
			else
			{
				cls.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler2, false, 0 ,true);
			}
			cls.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler, false, 0, true);
			if(downHide)
			{
				cls.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler, false, 0, true);
			}
		}
		/**
		 * 注销要显示tip的对象 
		 * @param cls
		 */		
		public function detach(cls:DisplayObject,isInside:Boolean = false):void
		{
			if(_map[cls])
			{
				var tipType:int = getTipType(cls);
				if(tipType == ToolTipConst.NONE_TIP)
				{
					return;
				}
				
				if(getToolTip(tipType).target == cls)
				{
					removeTip(tipType);
				}
				
				delete _map[cls];
				cls.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
				cls.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
				cls.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler2);
				cls.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
				
				if(!isInside && _tipInfo[cls])
				{
					delete _tipInfo[cls];
				}
			}
		}
		/**
		 * 储存自定义的tip
		 * @param cls
		 * @param tipVO
		 */		
		public function hashTipInfo(cls:DisplayObject, tipVO:TipVO):void
		{
			if(_tipInfo[cls])
			{
				delete _tipInfo[cls];
			}
			_tipInfo[cls] = tipVO;
		}
		/**
		 * 显示对应的tip 
		 * @param event
		 */		
		private function onMouseMoveHandler(event:MouseEvent):void
		{
			var cls:DisplayObject = event.currentTarget as DisplayObject;
            var needPixelCheck:Boolean = isNeedPixelCheck(cls);
            if (needPixelCheck)
			{
				var mc:MovieClip = cls as MovieClip;
				if(mc && mc.numChildren)
				{
                    var mousePixelOn:Boolean = isMousePixelOn(mc);
                    if (!mousePixelOn)
					{
						onMouseOutHandler(event);
						return;
					}
				}
			}
			var tipData:Object = getTipData(cls);
			var tipCount:int = getTipCount(cls);
			_tipType = getTipType(cls);
			var tipDataValue:* = getTipDataValue(cls);
			if(tipData is Function)
			{
				var func:Function = tipData as Function;
				tipData = tipDataValue != null ? func(tipDataValue) : func();
			}
			if(!tipData)
			{   
				trace("ToolTipManager.onMouseMoveHandler(event) 无效的tipData"+cls);
				return;
			}
			
			var toolTip:BaseTip = getToolTip(_tipType);
			if(!toolTip)
			{
				trace("ToolTipManager.onMouseMoveHandler(event) 无效的tip类型:"+_tipType);
				return;
			}
			//if(toolTip.target==cls)return;
			toolTip.target = cls;
			if(_tipType == ToolTipConst.EQUIP_BASE_TIP || _tipType == ToolTipConst.EQUIP_BASE_TIP_HERO)
			{
				equipTipHandler(toolTip, tipData, cls);
			}
			else
			{
				showTip(toolTip, tipData,tipCount);
			}
		}
		/**是否划过（像素级）*/
		private function isMousePixelOn(mc:MovieClip):Boolean
		{
            var bitmap:Bitmap = mc.getChildAt(0) as Bitmap;
			if(bitmap && bitmap.bitmapData)
			{
				var mx:Number = bitmap.mouseX*bitmap.scaleX;//返回相对图像的起始点位置
				var my:Number = bitmap.mouseY*bitmap.scaleY;
				var result:Boolean = mx > 0 && mx <= bitmap.width && my > 0 && my <= bitmap.height && bitmap.bitmapData;
				if (result)
				{
					try
					{
						result = result && bitmap.bitmapData.getPixel32(bitmap.mouseX, bitmap.mouseY) != 0;
					}
					catch (error:Error)
					{
						
					}
				}
				return result;
			}
			else
			{
				return false;
			}
		}
		/**
		 * 装备tip处理
		 * 可能有装备比对现象 
		 * @param toolTip
		 * @param tipData
		 */		
		private function equipTipHandler(toolTip:BaseTip, tipData:Object, cls:DisplayObject):void
		{
			var tipVO:TipVO = _tipInfo[cls];
			var memEquipData2:MemEquipData;
			if(!tipVO || tipVO.completeTipeType == 0)
			{
				var equipId:int = tipData is MemEquipData ? MemEquipData(tipData).baseId : EquipCfgData(tipData).id;
				var type:int = ConfigDataManager.instance.equipCfgData(equipId).type;
				if(_tipType == ToolTipConst.EQUIP_BASE_TIP)
				{
					memEquipData2 = MemEquipDataManager.instance.equipedMemEquipDataByType(type);
				}
				else if(_tipType == ToolTipConst.EQUIP_BASE_TIP_HERO)
				{
					memEquipData2 = MemEquipDataManager.instance.equipedMemEquipDataByType(type,true);
				}
			}
			else if(tipVO.completeTipeType == 1)
			{
				memEquipData2 = MemEquipDataManager.instance.memEquipData(tipData.bornSid,tipData.onlyId);
			}
				
			if(memEquipData2)
			{
				var isSameEquip:Boolean = false;
				if(tipData is MemEquipData)
				{
					var bornSid:int = MemEquipData(tipData).bornSid;
					var onlyId:int = MemEquipData(tipData).onlyId;
					var baseId:int = MemEquipData(tipData).baseId;
					if(bornSid == memEquipData2.bornSid && onlyId == memEquipData2.onlyId)
					{
						isSameEquip = true
					}
				}
				
				if(!toolTip.getData())
				{
					toolTip.setData(tipData);
					if(!isSameEquip)
					{
						ToolTipLayMediator.getInstance().setVisible(toolTip, true);
					}
				}
				
				var completeTip:EquipBaseTip = getToolTip(_tipType == ToolTipConst.EQUIP_BASE_TIP ?ToolTipConst.COMPLETE_EQUIP_BASE_TIP:ToolTipConst.COMPLETE_HERO_EQUIP_BASE_TIP) as EquipBaseTip;
				if(!completeTip.getData())
				{  
				   completeTip.setData(memEquipData2);
				   completeTip.setEquipedFlag();
				   if(toolTip is EquipBaseTip)
				   {
				   		EquipBaseTip(toolTip).setCompareEquipTip(completeTip);
				   }
				   ToolTipLayMediator.getInstance().setVisible(completeTip, true);
				}
				 
				changePosition(toolTip,completeTip,isSameEquip);
			}
			else 
			{	
				showTip(toolTip,tipData);
			}
		}
		
		public function updateTipData(target:DisplayObject):void
		{
			var tipType:int = getTipType(target);
			var toolTip:BaseTip = getToolTip(tipType);
			
			if(toolTip && toolTip.target && toolTip.target == target && toolTip.visible && toolTip.parent)
			{
				var cls:DisplayObject = toolTip.target;
				var tipData:Object = getTipData(cls);
				var tipDataValue:* = getTipDataValue(cls);
				if(tipData is Function)
				{
					var func:Function = tipData as Function;
					tipData = tipDataValue != null ? func(tipDataValue) : func();
				}
				if(!tipData)
				{   
					return;
				}
				
				if(toolTip.getData()!=tipData)
				{
					toolTip.setData(tipData);
				}
			}
		}
		/**
		 * 显示特定的tip 
		 * @param toolTip
		 * @param tipData
		 */		
		private function showTip(toolTip:BaseTip,tipData:Object,tipCount:int = 1):void
		{
			//坐标定位
			var pointX:int = _stage.mouseX + 15;
			var pointY : int = _stage.mouseY+10;
			toolTip.x = pointX;
			toolTip.y = pointY;
			//区域判断
			if(pointX+toolTip.width>_stage.stageWidth)
			{
				toolTip.x = _stage.stageWidth-toolTip.width-5;
			}
			else
			{
				toolTip.x = pointX;
			}
			
			if(pointY+toolTip.height>_stage.stageHeight)
			{
				toolTip.y = _stage.stageHeight-toolTip.height-5;
			}
			else
			{
				toolTip.y = pointY;
			}
			
			if(toolTip.getData()==tipData)
			{
				/*trace("ToolTipManager.showTip(toolTip, tipData, tipCount) isSame");*/
				return;
			}
			/*trace("ToolTipManager.showTip(toolTip, tipData, tipCount) isNotSame");*/
			toolTip.setCount(tipCount);
			toolTip.setData(tipData);
			ToolTipLayMediator.getInstance().setVisible(toolTip,true);
		} 
		
		public function removeTip(tipType:int):void
		{
			if(tipType == ToolTipConst.NONE_TIP)
			{
				return;
			}
			
			ToolTipLayMediator.getInstance().remove(tipType);
			
			if(tipType == ToolTipConst.EQUIP_BASE_TIP || tipType == ToolTipConst.EQUIP_BASE_TIP_HERO)
			{
				ToolTipLayMediator.getInstance().remove(ToolTipConst.COMPLETE_EQUIP_BASE_TIP);
				ToolTipLayMediator.getInstance().remove(ToolTipConst.COMPLETE_HERO_EQUIP_BASE_TIP);
//				ToolTipLayMediator.getInstance().remove(_tipType == ToolTipConst.EQUIP_BASE_TIP ?ToolTipConst.COMPLETE_EQUIP_BASE_TIP:ToolTipConst.COMPLETE_HERO_EQUIP_BASE_TIP);
			}
		}
		/**
		 * tip比对重置坐标 
		 * @param toolTip
		 * @param completeTip
		 */		
		private function changePosition(toolTip:BaseTip, completeTip:BaseTip, isSameEquip:Boolean = false):void
		{
			var SX:Number = _stage.mouseX+25;
			var SY:Number = _stage.mouseY+20;
			var width:Number = isSameEquip ? completeTip.width : toolTip.width+completeTip.width;
			var height:Number = isSameEquip ? completeTip.height : Math.max(toolTip.height, completeTip.height);
			if(SY+Math.max(toolTip.height, completeTip.height)>_stage.stageHeight)
			{
				SY = _stage.stageHeight-height-5;
			}
			if(SX+width>_stage.stageWidth)
			{
				SX = _stage.mouseX-width-25;
				
				completeTip.x = SX;
				completeTip.y = SY;
				
				if(!isSameEquip)
				{
					toolTip.x = completeTip.x+completeTip.width;
					toolTip.y = completeTip.y;
				}
			}
			else
			{
				
				if(!isSameEquip)
				{
					toolTip.x = SX;
					toolTip.y = SY;
					completeTip.x = toolTip.x+toolTip.width;
					completeTip.y = toolTip.y;
				}
				else
				{
					completeTip.x = SX;
					completeTip.y = SY;
				}
			}
		}
		/**
		 * 隐藏对应的tip 
		 * @param event
		 */		
		private function onMouseOutHandler(event:MouseEvent):void
		{
			var cls:DisplayObject = event.currentTarget as DisplayObject;
			cls.removeEventListener(MouseEvent.ROLL_OUT,onMouseOutHandler);
			removeTip(getTipType(cls));
		}
		/**
		 * 隐藏对应的tip 
		 * @param event
		 */		
		private function onMouseOutHandler2(event:MouseEvent):void
		{
			clearTimeout(_timeId);
			_timeId=setTimeout(hideTipFunc,300,event.currentTarget);
		}
		
		private function hideTipFunc(cls:DisplayObject):void
		{
			var mask:BaseTip=getToolTip(getTipType(cls));
			
			var checkHide:Boolean=mask.mouseX>0&&mask.mouseX<=mask.width&&mask.mouseY>0&&mask.mouseY<=mask.height;
			if(checkHide)return;
			cls.removeEventListener(MouseEvent.ROLL_OUT,onMouseOutHandler2);
			removeTip(getTipType(cls));
		}
		/**
		 * 隐藏对应的tip
		 * 取消tip监听
		 * @param event
		 */		
		private function onMouseDownHandler(event:MouseEvent):void
		{
			/*trace("鼠标按下");*/
		    onMouseOutHandler(event);
			_downObj = event.currentTarget as DisplayObject;
			detach(_downObj,true);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler, false, 0, true);
		}
		
		private function onMouseUpHandler(event:MouseEvent):void
		{
			/*trace("鼠标放开");*/
			var target:DisplayObject = event.target as DisplayObject;
			ToolTipLayMediator.getInstance().removeAllTip();
			attach(_downObj);
			_stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);
			_downObj = null;
		}
		
		private function getTipType(cls:DisplayObject):int
		{
			if(cls is IToolTipClient)
			{
				return IToolTipClient(cls).getTipType();
			}
			else
			{
				var tipVo:TipVO = _tipInfo[cls];
				if(tipVo)
				{
					return tipVo.tipType;
				}
				else
				{
					return ToolTipConst.NONE_TIP;
				}
			}
		}
		
		private function getTipData(cls:DisplayObject):Object
		{
			if(cls is IToolTipClient)
			{
				return IToolTipClient(cls).getTipData();
			}
			else
			{
				var tipVo:TipVO = _tipInfo[cls];
				if(tipVo)
				{
					return tipVo.tipData;
				}
				else
				{
					return null;
				}
			}
		}
		
		private function getTipCount(cls:DisplayObject):int
		{
			if(cls is IToolTipClient)
			{
				return IToolTipClient(cls).getTipCount();
			}
			else
			{
				var tipVo:TipVO = _tipInfo[cls];
				if(tipVo)
				{
					return tipVo.tipCount;
				}
				else
				{
					return 1;
				}
			}
		}
		
		private function isNeedPixelCheck(cls:DisplayObject):Boolean
		{
			if(cls is IToolTipClient)
			{
				return false;
			}
			else
			{
				var tipVo:TipVO = _tipInfo[cls];
				if(tipVo)
				{
					return tipVo.isNeedPixelCheck;
				}
				else
				{
					return false;
				}
			}
		}
		
		private function getTipDataValue(cls:DisplayObject):*
		{
			if(cls is IToolTipClient)
			{
				return null;
			}
			else
			{
				var tipVo:TipVO = _tipInfo[cls];
				if(tipVo)
				{
					return tipVo.tipDataValue;
				}
				else
				{
					return null;
				}
			}
		}
		
		private function getToolTip(tipType:int):BaseTip
		{
			return ToolTipLayMediator.getInstance().getToolTip(tipType);
		}
	}
}
class PrivateClass{}