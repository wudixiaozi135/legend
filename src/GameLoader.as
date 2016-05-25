package
{
    import com.model.business.fileService.UrlSwfLoader;
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.business.fileService.interf.IUrlSwfLoaderReceiver;
    import com.model.business.flashVars.FlashVarsManager;
    import com.model.consts.StringConst;
    import com.view.gameLoader.IGameLoader;
    import com.view.gameWindow.util.ContextMenuUtil;
    import com.view.gameWindow.util.HttpServiceUtil;
    import com.view.newMir.INewMir;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageQuality;
    import flash.display.StageScaleMode;
    import flash.events.Event;

    public class GameLoader extends Sprite implements IUrlSwfLoaderReceiver,IGameLoader
	{
		private var _newMir:INewMir;
		private var _background:Bitmap;
		private var _loadings:Vector.<UILoading>;
		private var _loadIndex:int;
		public function get loadIndex():int
		{
			return _loadIndex;
		}
		
		public function GameLoader()
		{
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandle);
		}
		
		private function addToStageHandle(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandle);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.BEST;
			stage.frameRate = 60;//帧频
			stage.stageFocusRect = false;//tab键不会出现黄色的框框
			init();
			HttpServiceUtil.getInst().sendHttp(HttpServiceUtil.STEP1,1);
		}
		

		private function init():void
		{
			var flashVarsManager:FlashVarsManager = FlashVarsManager.getInstance();
			flashVarsManager.init(stage.loaderInfo.parameters);
			//初始化url链接
			ResourcePathConstants.initServerPath(FlashVarsManager.getInstance().resPath);
			ResourcePathConstants.initUrls();
			//
			stage.addEventListener(Event.RESIZE, resizeHandle, false, 0, true);
			initBackground();
			loadNewMir();
			
			if (stage.stageWidth > 0 && stage.stageHeight > 0)
			{
				resizeHandle(null);
			}
			
			new ContextMenuUtil(this);
		}
		
		private function initBackground():void
		{
			_background = new Bitmap();
			_background.bitmapData = new BitmapData(100, 100, false, 0xff000000);
			addChild(_background);
		}
		
		private function loadNewMir():void
		{
			var loader:UrlSwfLoader = new UrlSwfLoader(this);
			var newMir:String = FlashVarsManager.getInstance().newMir;
			loader.loadSwf(newMir);
			_loadings = new Vector.<UILoading>();
			_loadIndex = showLoading(StringConst.LOADING_TIP_0001);
			_loadings[_loadIndex].loadRes();
		}
		
		public function swfReceive(url:String, swf:Sprite,info:Object):void
		{
			_newMir = swf as INewMir;
			_newMir.setGameLoader(this);
			addChild(swf);
			resizeHandle(null);
		}
		
		public function swfProgress(url:String, progress:Number,info:Object):void 
		{
			setLoading(_loadIndex,progress);
		}
		
		public function swfError(url:String,info:Object):void
		{
			
		}
		
		private function resizeHandle(event:Event):void
		{
			var stageWidth:int = stage.stageWidth;
			var stageHeight:int = stage.stageHeight;
			if(_background.width==stageHeight&&_background.height==stageHeight)return;
			_background.width = stageWidth;
			_background.height = stageHeight;
			if (_newMir)
			{
				_newMir.resize(stageWidth, stageHeight);
			}
			var ui:UILoading;
			for each(ui in _loadings)
			{
				if(ui)
				{
					ui.resize();
				}
			}
		}
		
		public function showLoading(text:String,visible:Boolean = true):int
		{
			var ui:UILoading = new UILoading(!visible);
			ui.stage = stage;
			ui.mcLoading.mcProgress.mcMask.scaleX = 0;
			ui.mcLoading.txt.text = text;
			ui.skin.visible = visible;
			ui.resize();
			//
			addChild(ui.skin);
			//
			var i:int,l:int = _loadings.length;
			for(i=0;i<l;i++)
			{
				if(!_loadings[i])
				{
					_loadings[i] = ui;
					return i;
				}
			}
			_loadings.push(ui);
			return _loadings.length-1;
		}
		
		public function setLoadVisible(index:int,visible:Boolean):void
		{
			if(index < 0)
			{
				return;
			}
			var ui:UILoading = _loadings[index];
			if(ui)
			{
				ui.skin.visible = visible;
			}
		}
		
		public function setLoading(index:int,progress:Number):void
		{
			var ui:UILoading = _loadings[index];
			if(ui)
			{
				ui.mcLoading.mcProgress.mcMask.scaleX = progress;
				ui.mcLoading.txt.text = ui.mcLoading.txt.text.replace(/ \d*\.*\d*%/," "+(progress*100).toFixed(1)+"%");
			}
		}
		
		public function hideLoading(index:int):void
		{
			var ui:UILoading = _loadings[index];
			if(ui)
			{
				ui.hideLoading();
				_loadings[index] = null;
			}
		}
	}
}

import com.model.business.fileService.constants.ResourcePathConstants;
import com.model.consts.StringConst;
import com.model.gameWindow.rsr.RsrLoader;
import com.view.gameLoader.McLoading;
import com.view.gameLoader.McLoadingSmall;

import flash.display.MovieClip;
import flash.display.Stage;

class UILoading
{
	public var stage:Stage;
	private var countLoaded:int;

	private var _mcLoadingSmall:McLoadingSmall;
	private var _mcLoading:McLoading;
	
	private var _isShowTrue:Boolean;
	
	public function UILoading(isShowTrue:Boolean = false)
	{
		_isShowTrue = isShowTrue;
		_mcLoadingSmall = new McLoadingSmall();
		_mcLoading = new McLoading();
		_mcLoading.txtTip.text = StringConst.CHAT_GAME_WARNING;
		if(_isShowTrue)
		{
			loadRes();
		}
	}
	
	public function loadRes():void
	{
		var rsrLoader:RsrLoader = new RsrLoader();
		rsrLoader.addCallBack(_mcLoading.mcBg,callBack);
		rsrLoader.addCallBack(_mcLoading.mcProgressBg,callBack);
		rsrLoader.addCallBack(_mcLoading.mcProgress.mcProgressPic,callBack);
		rsrLoader.load(_mcLoading,ResourcePathConstants.IMAGE_LOADING_FOLDER_LOAD);
	}
	
	private function callBack(mc:MovieClip):void
	{
		countLoaded++;
		if(_isShowTrue && countLoaded >= 3)
		{
			if(_mcLoadingSmall.parent)
			{
				resize();
				_mcLoading.visible = _mcLoadingSmall.visible;
				_mcLoadingSmall.parent.addChild(_mcLoading);
				_mcLoadingSmall.parent.removeChild(_mcLoadingSmall);
			}
		}
	}
	
	public function resize():void
	{
		_mcLoading.x = (stage.stageWidth - _mcLoading.width)*.5;
		_mcLoading.y = (stage.stageHeight - _mcLoading.height)*.5;
		_mcLoadingSmall.x = (stage.stageWidth - _mcLoadingSmall.width)*.5;
		_mcLoadingSmall.y = (stage.stageHeight - _mcLoadingSmall.height)*.5;
	}
	
	public function get skin():MovieClip
	{
		if(countLoaded >= 3)
		{
			return _mcLoading;
		}
		return _mcLoadingSmall;
	}
	
	public function get mcLoading():McLoading
	{
		return _mcLoading;
	}
	
	public function hideLoading():void
	{
		if(_mcLoading.parent)
		{
			_mcLoading.parent.removeChild(_mcLoading);
		}
		if(_mcLoadingSmall.parent)
		{
			_mcLoadingSmall.parent.removeChild(_mcLoadingSmall);
		}
	}
}