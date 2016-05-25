package com.view.gameWindow.scene.entity.entityItem
{
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityInfoLabel.EntityInfoLabel;
	import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
	import com.view.gameWindow.scene.map.path.MapPathManager;
	import com.view.gameWindow.scene.map.utils.MapTileUtils;
	import com.view.gameWindow.scene.viewItem.SceneViewItem;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	/**
	 * 所有场景元素的基类 
	 * @author Administrator
	 */	
	public class Entity extends SceneViewItem implements IEntity
	{
		public static const NO_ALPHA:Number = 0.0;
		public static const HALF_ALPHA:Number = 0.7;
		public static const FULL_ALPHA:Number = 1.0;
		
		protected static var _selectedFilter:GlowFilter = new GlowFilter(0xC5C855,1,4,4,4,2);
		protected static const _overFilter:ColorMatrixFilter = new ColorMatrixFilter([1.51024604372414,-0.425559412057497,0.0953133683333553,0,6.26999999999999,-0.141155127311352,1.40643028822174,-0.0852751609103901,0,6.27,-0.279839959843708,-0.21231284160452,1.67215280144823,0,6.27,0,0,0,1,0]);
		protected static const _nameTextFilters:Array = [new GlowFilter(0,1,2,2,10)];
		
		protected var _entityId:int;
		/**该变量仅在构造虚假entity对象时用于存储临时变量，具体子对象会重写get entityType方法是该变量无效*/
		protected var _entityType:int = -1;
		protected var _entityName:String;
		
		protected var _isShow:Boolean;
		protected var _isShowName:Boolean;
		
		protected var _shadow:Bitmap;
		
		protected var _infoLabel:EntityInfoLabel;
		protected var _nameTxt:TextField;
		protected var _nameColor:int;
		
		protected var _pixelX:Number;
		protected var _pixelY:Number;
		protected var _tileX:int;
		protected var _tileY:int;
		
		protected var _isTitleShow:Boolean = true;
		
		/**0位表示是否划过，1为表示是否选中*/
		protected var _fitersState:int;
		
		public function Entity()
		{
			mouseEnabled = false;
			mouseChildren = false;
			_isShow = false;
			_isShowName = true;
			_nameColor = 0xffffff;
			
			initInfoLabel();
		}
		
		public override function set alpha(value:Number):void
		{
			super.alpha = value;
			if (_infoLabel)
			{
				_infoLabel.alpha = value;
			}
		}
		
		public override function get entityId():int
		{
			return _entityId;
		}
		
		public override function set entityId(value:int):void
		{
			_entityId = value;
		}
		
		public override function get entityType():int
		{
			if(_entityType == -1)
				return EntityTypes.ET_NONE;
			else
				return _entityType;
		}
		
		public override function set entityType(value:int):void
		{
			_entityType = value;
		}
		
		public function get entityName():String
		{
			return _entityName;
		}
		
		public function set entityName(value:String):void
		{
			_entityName = value;
			if (_isShow)
			{
				initUpHeadContent();
			}
		}
		
		public function initInfoLabel():void
		{
			_infoLabel = new EntityInfoLabel();
		}
		
		public function resetInfoLabelPos():void
		{
			if (_infoLabel)
			{
				_infoLabel.x = x;
				_infoLabel.y = y;
			}
		}
		
		public function show():void
		{
			_isShow = true;
			alpha = 0;
			initUpHeadContent();
		}
		
		public function hide():void
		{
			_isShow = false;
			clearViewBitmap();
			clearUpHeadContent();
		}
		
		public function initViewBitmap():void
		{
			if (!_shadow)
			{
				_shadow = new Bitmap();
			}
			if (!contains(_shadow))
			{
				addChild(_shadow);
			}
			
			if (!_viewBitmap)
			{
				_viewBitmap = new Bitmap();
				_viewBitmap.smoothing = true;
				
				updateAlpha();
			}
			if (!contains(_viewBitmap))
			{
				addChild(_viewBitmap);
				
				resetLayer();
			}
		}
		
		public function clearViewBitmap():void
		{
			if (_viewBitmap)
			{
				if (_viewBitmap.bitmapData)
				{
					_viewBitmap.bitmapData = null;
				}
				if (_viewBitmap.parent)
				{
					removeChild(_viewBitmap);
				}
				_viewBitmap.filters = null;
				_viewBitmap = null;
			}
			if (_shadow)
			{
				if (_shadow.bitmapData)
				{
					_shadow.bitmapData = null;
				}
				if (_shadow.parent)
				{
					removeChild(_shadow);
				}
				_shadow = null;
			}
		}
		
		public function get infoLabel():Sprite
		{
			return _infoLabel;
		}
		
		public function initUpHeadContent():void
		{
			if(!_nameTxt && _entityName && _isShowName)
			{
				_nameTxt = new TextField();
				_nameTxt.mouseEnabled = false;
				_nameTxt.tabEnabled = false;
				_nameTxt.multiline = false;
				_nameTxt.wordWrap = false;
				_nameTxt.text = _entityName;
				_nameTxt.height = _nameTxt.textHeight + 5;
				_nameTxt.width = _nameTxt.textWidth+5;
				_nameTxt.textColor = _nameColor;
				_nameTxt.filters = _nameTextFilters;
				_nameTxt.cacheAsBitmap = true;
			}
		}
		
		public function clearUpHeadContent():void
		{
			if (_infoLabel)
			{
				_infoLabel.clearNameText();
			}
			_nameTxt = null;
		}
		
		/**用于刷新模型内层级结构*/
		public function resetLayer():void
		{
			
		}
		
		protected function updateView(timeDiff:int):void
		{
		}
		
		protected function updateAlpha():void
		{
			if (_viewBitmap)
			{
				if (MapPathManager.getInstance().checkAlpha(_tileX, _tileY))
				{
					if (_viewBitmap.alpha != HALF_ALPHA)
					{
						_viewBitmap.alpha = HALF_ALPHA;
					}
				}
				else
				{
					if (_viewBitmap.alpha != FULL_ALPHA)
					{
						_viewBitmap.alpha = FULL_ALPHA;
					}
				}
			}
		}
		
		protected function updateEffects(timeDiff:int):void
		{
			
		}
		
		protected function refreshNameTxtPos():void
		{
		}
		
		public function get pixelX():Number
		{
			return _pixelX;
		}
		
		public function get pixelY():Number
		{
			return _pixelY;
		}
		
		public function set pixelX(value:Number):void
		{
			_pixelX = value;
			x = int(_pixelX);
			_tileX = MapTileUtils.pixelXToTileX(_pixelX);
			resetInfoLabelPos();
		}
		
		public function set pixelY(value:Number):void
		{
			_pixelY = value;
			y = int(_pixelY);
			_tileY = MapTileUtils.pixelYToTileY(_pixelY);
			resetInfoLabelPos();
		}
		
		public function get tileX():int
		{
			return _tileX;
		}
		
		public function get tileY():int
		{
			return _tileY;
		}
		
		public function set tileX(value:int):void
		{
			_tileX = value;
			_pixelX = MapTileUtils.tileXToPixelX(_tileX);
			x = int(_pixelX);
			resetInfoLabelPos();
		}
		
		public function set tileY(value:int):void
		{
			_tileY = value;
			_pixelY = MapTileUtils.tileYToPixelY(_tileY);
			y = int(_pixelY);
			resetInfoLabelPos();
		}
		
		public function tileDistance(xTile:int, yTile:int):int
		{
			return MapTileUtils.tileDistance(_tileX, _tileY, xTile, yTile);
		}
		
		public function pixelDistance(pixelX:Number,pixelY:Number):Number
		{
			var x:Number = _pixelX - pixelX;
			var y:Number = _pixelY - pixelY;
			var sqrt:Number = Math.sqrt(x*x+y*y);
			return sqrt;
		}
		
		public function isMouseOn():Boolean
		{
			if(_viewBitmap && _viewBitmap.bitmapData)
			{
				var mx:Number = _viewBitmap.mouseX*_viewBitmap.scaleX;//返回相对图像的起始点位置
				var my:Number = _viewBitmap.mouseY*_viewBitmap.scaleY;
				var result:Boolean = mx > 0 && mx <= _viewBitmap.width && my > 0 && my <= _viewBitmap.height && _viewBitmap.bitmapData;
				if (result)
				{
					try
					{
						result = result && _viewBitmap.bitmapData.getPixel32(_viewBitmap.mouseX, _viewBitmap.mouseY) != 0;
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
		
		public function get isShow():Boolean
		{
			return _isShow;
		}
		
		public function get viewBitmapExist():Boolean
		{
			return _viewBitmap != null;
		}
		
		public function get selectable():Boolean
		{
			return true;
		}
		
		/**若选中则添加发光滤镜*/
		public function setSelected(value:Boolean):void
		{
			/*_fitersState &= 1;
			_fitersState |= int(value)<<1;
			setFilter();*/
		}
		
		/**若划过则添加发光滤镜*/
		public function setOver(value:Boolean):void
		{
			_fitersState &= 2;
			_fitersState |= int(value);
			setFilter();
		}
		
		protected function setFilter():void
		{
			if(!_viewBitmap)
			{
				return;
			}
			var filters:Array = new Array();
			if(_fitersState & 1)
				filters.push(_overFilter);
			if(_fitersState & 2)
				filters.push(_selectedFilter);
			if(!filters.length)
				filters = null;
			_viewBitmap.filters = filters;
		}
		
		public function get totalTime():int
		{
			return 0;
		}
		
		public function get viewBitmap():Bitmap
		{
			return _viewBitmap;
		}
		
		public function get tileDistToReach():int
		{
			return 0;
		}
		
		public override function destory():void
		{
			super.destory();
			hide();
			if (_nameTxt)
			{
				_nameTxt.text = "";
				_nameTxt = null;
			}
			if (_infoLabel)
			{
				_infoLabel.destroy();
				_infoLabel = null;
			}
		}
	}
}