package com.view.gameWindow.panel.panelbase
{
    import com.greensock.TweenMax;
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.PanelFlyHandler;
    import com.view.newMir.NewMirMediator;
    import com.view.newMir.sound.SoundManager;
    import com.view.newMir.sound.constants.SoundIds;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.InteractiveObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;

    /**
	 * 基础面板类<br>若面板要设置为单例需要将isSingleton设置为true,且重写show(),hide()方法并把在该两个方法中注册移除数据类监听
	 * @author Administrator
	 */	
	public class PanelBase extends Sprite implements IPanelBase
	{
		public var isSingleton:Boolean;
		/**当面板为非唯一面板时，用于识别面板*/
		public var index:int;
		/**传入的参数*/
		public var args:Array;
		
		private var _rsrLoader:RsrLoader;
		
		private var _titleBar:InteractiveObject;
		private var _offsetX:int;
		private var _offsetY:int;
		
		protected var _panelRect:Rectangle;
		protected var _skin:MovieClip;
		private var _alphaTarget:Number;
		public var isMound:Boolean;
		public var openX:int;
		public var openY:int;
		public var flyX:int;
		public var flyY:int;
		public var moveing:Boolean;    //防止动画同轨
        public var canEscExit:Boolean;//按esc键可以关闭面板 默认都是可以关闭的
		
		public function PanelBase()
		{
			super();
			mouseEnabled = false;
			_alphaTarget = 1;
            canEscExit = true;
		}
		/**初始化界面<br>加载图片及SWF资源并刷新界面*/
		public function initView():void
		{
			rsrLoad();
			initData();
			setPostion();
			update();
		}
		/**初始资源加载*/
		private function rsrLoad():void
		{
			initSkin();
			_rsrLoader = new RsrLoader();
			addCallBack(_rsrLoader);
			_rsrLoader.load(_skin,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD,true);
		}
		/**初始化皮肤<br>初始化数据或添加需要加载资源的元件请在initData中添加*/
		protected function initSkin():void
		{
			//子类重写
			throw new Error(this+"继承自PanelBase，该子类必须覆盖重写initSkin方法");
		}
		
		/***
		 * 如果界面内有某个元件更新了，可以使用这个方法重新加载一次 
		 * @param mc 需要重新加载的元件
		 * */
		protected function loadNewSource(mc:MovieClip):void
		{
			_rsrLoader.loadItemRes(mc);
		}
		
		/**添加初始资源加载完成的回调函数*/
		protected function addCallBack(rsrLoader:RsrLoader):void
		{
			//有需要子类重写
		}
		/**初始化数据*/
		protected function initData():void
		{
			
		}

		/**初始化打开默认选项*/
		public function setSelectTabShow(tabIndex:int = -1):void
		{

		}
		public function setPostion():void
		{
			var rect:Rectangle = getPanelRect();
			var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
			var newX:int = int((newMirMediator.width - rect.width)*.5);
			x != newX ? x = newX : null;
			var newY:int = int((newMirMediator.height - rect.height)*.5);
			y != newY ? y = newY : null;
		}
		
		/**
		 * 该方法在子类中重写setPostion（）方法，然后调用传参挂载动画
		 */
		protected function isMount(bool:Boolean=false,popenX:int=0,popenY:int=0):void
		{
			isMound=bool;
			if(bool)
			{
				PanelFlyHandler.getInstance().mount(this);	
				this.openX=popenX;
				this.openY=popenY;
			}
		}
		
		public function update(proc:int = 0):void
		{
			
		}
		
		protected function setTitleBar(value:InteractiveObject):void
		{
			_titleBar = value;
			_titleBar.addEventListener(MouseEvent.MOUSE_DOWN, titleBarMouseDownHandle, false, 0, true);			
		}
		
		public function doFly():void
		{
			if(moveing)return;
			var numx:Number=Math.abs(flyX-this.x)/1000;
			var numy:Number=Math.abs(flyY-this.y)/1000;
			TweenMax.to(this,(numx+numy),{x:flyX,y:flyY});
		}
		
		private function titleBarMouseDownHandle(event:MouseEvent):void
		{
			_panelRect = getPanelRect();
			
			_offsetX = -mouseX;
			_offsetY = -mouseY;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandle, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandle, false, 0, true);
			
			if (parent.getChildIndex(this) != parent.numChildren - 1)
			{
				parent.setChildIndex(this, parent.numChildren - 1);
			}			
		}
		
		private function stageMouseMoveHandle(event:MouseEvent):void
		{
			_alphaTarget = 0.3;
			if (Math.abs(alpha - _alphaTarget) > 0.05)
			{
				addEventListener(Event.ENTER_FRAME, enterframeHandle, false, 0, true);
			}
			if (stage && _panelRect)
			{
				var tryX:int = stage.mouseX + _offsetX + _panelRect.x;
				var tryY:int = stage.mouseY + _offsetY + _panelRect.y;
				var zonghengchibiMediator:NewMirMediator = NewMirMediator.getInstance();
				var stageWidth:int = zonghengchibiMediator.width;
				var stageHeight:int = zonghengchibiMediator.height;
				
				if (tryX < 0)
				{
					tryX = 0;
				}
				else if (tryX > stageWidth - _panelRect.width)
				{
					tryX = stageWidth - _panelRect.width;
				}
				
				if (tryY < 0)
				{
					tryY = 0;
				}
				else if (tryY > stageHeight - _panelRect.height)
				{
					tryY = stageHeight - _panelRect.height;
				}
				
				x = tryX - _panelRect.x;
				y = tryY - _panelRect.y;
			}
			
			dragMouseMove();
		}
		/**重写后可以在拖动的时候调整新手引导等不属于面板，但是要跟面板位置同步的元素*/	
		protected function dragMouseMove():void
		{
			//GuideManager.getInstance().checkPanelMoving(this);
			//由子类继承实现
		}
		
		private function stageMouseUpHandle(event:MouseEvent):void
		{
			_alphaTarget = 1;
			addEventListener(Event.ENTER_FRAME, enterframeHandle, false, 0, true);
			if(stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandle);
				stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandle);
			}
		}
		
		private function enterframeHandle(event:Event):void
		{
			if (Math.abs(alpha - _alphaTarget) > 0.05)
			{
				alpha += (_alphaTarget - alpha) * 0.05 / Math.abs(_alphaTarget - alpha);
			}
			else
			{
				alpha = _alphaTarget;
				removeEventListener(Event.ENTER_FRAME, enterframeHandle);
			}
		}
		
		public function getPanelRect():Rectangle
		{
			/*var rect:Rectangle = _skin.getBounds(_skin);*/
			/*trace("``````````````````````rect.x:"+rect.x+",rect.y:"+rect.y+",rect.width:"+rect.width+",rect.height:"+rect.height);*/
			/*return rect;*/
			if(_skin==null)
			{
				return new Rectangle(0,0,0,0);
			}
			return new Rectangle(0,0,_skin.width,_skin.height);//由子类继承实现
		}
		/**当窗口改变大小时，保证面板还在窗口里面*/	
		public function resetPosInParent():void
		{
			if (!_panelRect)
			{
				_panelRect = getPanelRect();
			}
			
			var newX:int = x + _panelRect.x;
			var newY:int = y + _panelRect.y;
			var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
			var stageWidth:int = newMirMediator.width;
			var stageHeight:int = newMirMediator.height;
			if (newX < 0)
			{
				newX = 0;
			}
			else if (newX > stageWidth - _panelRect.width)
			{
				newX = stageWidth - _panelRect.width;
			}
			
			if (newY < 0)
			{
				newY = 0;
			}
			else if (newY > stageHeight - _panelRect.height)
			{
				newY = stageHeight - _panelRect.height;
			}
			
			if (x != newX - _panelRect.x)
			{
				x = newX - _panelRect.x;
			}
			if (y != newY - _panelRect.y)
			{
				y = newY - _panelRect.y;
			}
			
		}
		/**当窗口改变大小时，保证面板还在窗口里面*/	
		public function resetFlyPosInParent():void
		{
			if (!_panelRect)
			{
				_panelRect = getPanelRect();
			}
			var newX:int = flyX + _panelRect.x;
			var newY:int = flyY + _panelRect.y;
			var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
			var stageWidth:int = newMirMediator.width;
			var stageHeight:int = newMirMediator.height;
			if (newX < 0)
			{
				newX = 0;
			}
			else if (newX > stageWidth - _panelRect.width)
			{
				newX = stageWidth - _panelRect.width;
			}
			
			if (newY < 0)
			{
				newY = 0;
			}
			else if (newY > stageHeight - _panelRect.height)
			{
				newY = stageHeight - _panelRect.height;
			}
			
			if (flyX!= newX - _panelRect.x)
			{
				flyX = newX - _panelRect.x;
			}
			if (flyY != newY - _panelRect.y)
			{
				flyY = newY - _panelRect.y;
			}
		}
		/**搜索面板中的文本框 */		
		public function searchText(mc:MovieClip,str:String,strLength:int,searchLength:int,sufLeng:int):Vector.<TextField>
		{
			var leng:int = mc.numChildren;
			var index:int;
			var sortTxtArr:Vector.<TextField> = new Vector.<TextField>();
			var txtArr:Vector.<TextField> = new Vector.<TextField>();
			for(var i:int = 0;i<leng;i++)
			{
				var textField:TextField = mc.getChildAt(i) as TextField;
				if(textField)
				{
					var name2:String = textField.name;
					if(name2.substr(strLength,searchLength) == str)
					{
						index = int(name2.substr(searchLength,sufLeng));
						if(txtArr.length < index)
							txtArr.length = index;
						txtArr[index] = textField;
					}
				}
			}
			return txtArr;
		}
		
		public function get postion():Point
		{
			return new Point(x,y);
		}
		
		public function set postion(value:Point):void
		{
			x = value.x;
			y = value.y;
		}
		
		public function doContains(child:DisplayObject):Boolean
		{
			return contains(child);
		}
		
		public function isMouseOn():Boolean
		{
			if(!_skin)
			{
				return false;
			}
			var mx:Number = mouseX*scaleX;//返回相对图像的起始点位置
			var my:Number = mouseY*scaleY;
			var result:Boolean = mx > 0 && mx <= width && my > 0 && my <= height;
			return result;
		}
		
		public function get rsrLoader():RsrLoader
		{
			return _rsrLoader;
		}
		
		public function show(layer:Sprite):void
		{
			if(!parent)
			{
				layer.addChild(this);
				setPostion();
				SoundManager.getInstance().playEffectSound(SoundIds.SOUND_ID_OPEN_PANEL);
			}
		}
		
		public function hide():void
		{
			if(parent)
			{
				parent.removeChild(this);
			}
		}
		/**由子类继承实现，销毁数据*/		
		public function destroy():void
		{
			args = null;
			
			mouseChildren =false;
			mouseEnabled =false;
			
			if (_titleBar)
			{
				_titleBar.removeEventListener(MouseEvent.MOUSE_DOWN, titleBarMouseDownHandle);
				_titleBar = null;
			}
			
			if(_rsrLoader)
			{
				_rsrLoader.destroy();
				_rsrLoader = null;
			}
			
			if(_skin)
			{
				_skin.stop();
				destroySkin(_skin);
				if(_skin.parent)
				{
					_skin.parent.removeChild(_skin);
				}
				_skin = null;
			}
			removeEventListener(Event.ENTER_FRAME, enterframeHandle);
			
			//GuideManager.getInstance().checkPanelState(this, GuideEventTypes.GET_CLOSE_PASSIVE);
			this.parent&&this.parent.removeChild(this);
		}
		
		private function destroySkin(skin:DisplayObjectContainer):void
		{
			var childLen:int = skin.numChildren; 
			while ( childLen>0)
			{
				var subSkin:DisplayObject = skin.getChildAt(0) as DisplayObject;
				childLen--;
				if (subSkin)
				{
					var subSkinContainer:DisplayObjectContainer = subSkin as DisplayObjectContainer;
					if (subSkinContainer)
					{
						destroySkin(subSkinContainer);
					}
					skin.removeChild(subSkin);
					if (skin.hasOwnProperty(subSkin.name))
					{
						skin[subSkin.name] = null;
					}
				}
			}
		}

		public function get skin():MovieClip
		{
			return _skin;
		}
		
		public function get isShow():Boolean
		{
			return parent != null;
		}
	}
}