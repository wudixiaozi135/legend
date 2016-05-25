package com.view.gameWindow.util
{
	import com.model.business.fileService.UrlSwfLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlSwfLoaderReceiver;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * 用户界面特效加载类
	 * @author Administrator
	 */	
	public class UIEffectLoader implements IUrlSwfLoaderReceiver
	{
		private var _layer:DisplayObjectContainer;
		private var _x:int,_y:int;
		private var _scaleX:Number,_scaleY:Number;
		private var _url:String;
		private var _urlSwfLoader:UrlSwfLoader;
		private var _effect:MovieClip;
		private var _playOverFun:Function;
		private var _receiveCallBack:Function;
		private var _isPlayOnce:Boolean;
		private var _visible:Boolean = true;//默认都是显示
		
		/***/
		public function get effect():MovieClip
		{
			return _effect;
		}
		public function set visible(val:Boolean):void
		{
			if(_effect)
				_effect.visible = val;
			_visible = val;
		}
		/**
		 * 构造特效加载类
		 * @param layer 特效父对象
		 * @param x 覆盖对象的中心点位置x
		 * @param y 覆盖对象的中心点位置y
		 * @param scaleX 特效缩放比例x
		 * @param scaleY 特效缩放比例y
		 * @param url 特效资源链接（使用该类中配置的常量或配置表中的数据）
		 */		
		public function UIEffectLoader(layer:DisplayObjectContainer,x:int,y:int,
									   scaleX:Number = 1,scaleY:Number = 1,url:String = "",
									   receiveCallBack:Function = null,isPlayOnce:Boolean = false,playOverFun:Function=null)
		{
			_layer = layer;
			_x = x;
			_y = y;
			_scaleX = scaleX;
			_scaleY = scaleY;
			_url = url;
			_receiveCallBack = receiveCallBack;
			_playOverFun = playOverFun;
			_isPlayOnce = isPlayOnce;
			if(_url != "")
			{
				load();
			}
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function set url(value:String):void
		{
			if(_url != value)
			{
				_url = value;
				
				if(!_url)
				{
					destroyEffect();
					destroyLoader();
				}
				else
				{
					load();
				}
			}
		}
		
		private function load():void
		{
			destroyLoader();
			_urlSwfLoader = new UrlSwfLoader(this);
			var url:String = ResourcePathConstants.IMAGE_EFFECT_FOLDER_LOAD + _url;
			_urlSwfLoader.loadSwf(url);
		}
		
		public function load2(val:String):void
		{
			destroyLoader();
			_urlSwfLoader = new UrlSwfLoader(this);
			var url:String = val;
			_urlSwfLoader.loadSwf(url);
		}
		
		public function swfError(url:String, info:Object):void
		{
			destroyEffect();
			destroyLoader();
		}
		
		public function swfProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function swfReceive(url:String, swf:Sprite, info:Object):void
		{
			if(_url && !url.match(_url))
			{
				return;
			}
			destroyEffect();
			if(_layer)
			{
				_effect = swf.getChildAt(0) as MovieClip;
				if(_effect)
				{
					_effect.mouseChildren = false;
					_effect.mouseEnabled = false;
					_effect.scaleX = _scaleX;
					_effect.scaleY = _scaleY;
					_effect.x = _x;
					_effect.y = _y;
					_effect.visible = _visible;
					_layer.addChild(_effect);
					if(!_isPlayOnce)
					{
						_effect.play();
					}
					else
					{
						_effect.addFrameScript(_effect.totalFrames-1,fun);
						function fun():void
						{
							if(_playOverFun!=null)
							{
								_playOverFun.apply();
							}
							while(_layer && _layer.numChildren)
							{
								_layer.removeChildAt(0);
							}
							destroy();
						}
					}		
					
					if(_receiveCallBack != null)
					{
						_receiveCallBack();
						_receiveCallBack = null;
					}
				}
			}
			destroyLoader();
		}
		
		private function destroyLoader():void
		{
			if(_urlSwfLoader)
			{
				_urlSwfLoader.destroy();
				_urlSwfLoader = null;
			}
		}
		
		public function destroyEffect():void
		{
			if(_effect)
			{
				if(_effect.parent)
				{
					_effect.parent.removeChild(_effect);
				}
				_effect.stop();
				_effect = null;
			}
		}
		
		public function destroy():void
		{
			destroyEffect();
			destroyLoader();
			_receiveCallBack = null;
			_playOverFun = null; 
			_layer = null;
			_url = "";
		}
	}
}