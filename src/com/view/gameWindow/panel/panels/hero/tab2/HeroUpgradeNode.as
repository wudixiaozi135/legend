package com.view.gameWindow.panel.panels.hero.tab2
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.HeroGradeCfgData;
	import com.model.configData.cfgdata.HeroMeridiansCfgData;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.common.ResManager;
	import com.view.gameWindow.panel.panels.hero.ConditionConst;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.tips.toolTip.interfaces.IToolTipClient;
	import com.view.gameWindow.util.FilterUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class HeroUpgradeNode extends Sprite implements IToolTipClient
	{
		
		private var sprite:Sprite;
		private var nodeBitmap:Bitmap;
		private var nodeMc:MovieClip;
		private var nodeBG:Bitmap;
		private var nodeEffect:MovieClip;

		private var bgUrl:String;
		private var nodeUrl:String;
		private var nodeUrlType:int;

		private var _nodeCfg:HeroMeridiansCfgData;
		private var _heroGradeCfg:HeroGradeCfgData;

		private var _activateNode:int;
		
		private const PNG:int = 1;
		private const SWF:int = 2;
		
		private var _isInitNodeEffect:Boolean;
		private var _isInitNodeMc:Boolean;
		
		public function HeroUpgradeNode()
		{
			super();
			sprite = new Sprite();
			sprite.mouseEnabled = false;
			nodeBG=new Bitmap();
			addChild(nodeBG);
			nodeBitmap=new Bitmap();
			addChild(nodeBitmap);
			nodeMc=new MovieClip();
			addChild(sprite);
			nodeEffect = new MovieClip();
			ToolTipManager.getInstance().attach(this);
		}
		
		public function setNode(nodeCfg:HeroMeridiansCfgData,activateNode:int):void
		{
			var nodeEffectUrl:String;
			if(this._activateNode==activateNode&&nodeCfg==this._nodeCfg)return;
			this._activateNode = activateNode;
			this._nodeCfg = nodeCfg;
			_heroGradeCfg = ConfigDataManager.instance.heroGradeCfgData(_nodeCfg.grade_level);
			bgUrl="";
			nodeUrl="";
			this.filters=null;
			switch(nodeCfg.bi_condition)
			{
				case ConditionConst.NORMAL:
				case ConditionConst.BUFFER:
					nodeUrlType = SWF;
					bgUrl=ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD+"hero/layer_1.png";
					if(activateNode>=nodeCfg.meridians_level)
					{
						nodeUrl = ResourcePathConstants.IMAGE_EFFECT_FOLDER_LOAD + "hero/" + _heroGradeCfg.meridians_point + ResourcePathConstants.POSTFIX_SWF;
					}
					break;
				case ConditionConst.CHOP:
					nodeUrlType = PNG;
					nodeUrl=ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD+"hero/chop.png";
					if(activateNode<nodeCfg.meridians_level)
					{
						this.filters=[FilterUtil.getGrayfiltes()];
					}
					break;
				case ConditionConst.EQUIP:
					nodeUrlType = PNG;
					var equipArr:Array = nodeCfg.bi_equip.split("|");
					var equipStr:String=equipArr[0] as String;
					equipArr = equipStr.split(":");
					var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(equipArr[0]);
					if(equipCfgData==null)return;
					var sex:int;
					if(equipCfgData.type==ConstEquipCell.TYPE_YIFU)
					{
						sex=HeroDataManager.instance.sex;
					}else
					{
						sex=0;
					}
					nodeUrl=ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD+"hero/equip"+equipCfgData.type+sex+".png";
					if(activateNode<nodeCfg.meridians_level)
					{
						this.filters=[FilterUtil.getGrayfiltes()];
					}
					break;
				case ConditionConst.DUIJIE:
					nodeUrlType = PNG;
					nodeUrl=ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD+"hero/duijie.png";
					if(activateNode<nodeCfg.meridians_level)
					{
						this.filters=[FilterUtil.getGrayfiltes()];
					}
					break;
//				case ConditionConst.BUFFER:
//					nodeUrlType = PNG;
//					nodeUrl=ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD+"hero/buffer.png";
//					if(activateNode<nodeCfg.meridians_level)
//					{
//						this.filters=[FilterUtil.getGrayfiltes()];
//					}
//					break;
			}
			if(bgUrl!="")
			{
				nodeBG.bitmapData&&nodeBG.bitmapData.dispose();
				ResManager.getInstance().loadBitmap(bgUrl,loadBgComple);
			}

			if(nodeUrl!="")
			{
				if(nodeUrlType == PNG)
				{
					nodeBitmap.bitmapData&&nodeBitmap.bitmapData.dispose();
					ResManager.getInstance().loadBitmap(nodeUrl,loadNodeComple);
				}
				else if(nodeUrlType == SWF)
				{
					if(!_isInitNodeMc)
					{
						ResManager.getInstance().loadSwf(nodeUrl,loadNodeSwfComple);
					}
				}
				if(!_isInitNodeEffect && activateNode >=nodeCfg.meridians_level)
				{
					nodeEffectUrl = ResourcePathConstants.IMAGE_EFFECT_FOLDER_LOAD + "hero/" + _heroGradeCfg.meridians_effect + ResourcePathConstants.POSTFIX_SWF;
					ResManager.getInstance().loadSwf(nodeEffectUrl,loadNodeEffectComple);
				}
			}
		}
		
		private function loadNodeEffectComple(swf:Sprite):void
		{
			nodeEffect = swf.getChildAt(0) as MovieClip;
			if(nodeEffect)
			{
				nodeEffect.mouseChildren = false;
				nodeEffect.mouseEnabled = false;
				if(nodeUrlType == PNG)
				{
					nodeEffect.x = 0;
					nodeEffect.y = 0;
				}
				else if(nodeUrlType == SWF)
				{
					nodeEffect.x = 0;
					nodeEffect.y = 0;
				}
				nodeEffect.play();
				addChild(nodeEffect);
				_isInitNodeEffect = true;
			}
		}
		
		private function loadNodeSwfComple(swf:Sprite):void
		{
			nodeMc = swf.getChildAt(0) as MovieClip;
			if(nodeMc)
			{
				nodeMc.mouseChildren = false;
				nodeMc.mouseEnabled = false;
				nodeMc.x=0;
				nodeMc.y=0;
				sprite.addChild(nodeMc);
				_isInitNodeMc = true;
			}
		}
		
		private function loadNodeComple(bitmapData:BitmapData,url:String):void
		{
			if(nodeBitmap)
			{
				nodeBitmap.smoothing=true;
				nodeBitmap.bitmapData=bitmapData;
				nodeBitmap.x=-nodeBitmap.width*0.5;
				nodeBitmap.y=-nodeBitmap.height*0.5;
			}else
			{
				bitmapData.dispose();
			}
		}
		
		private function loadBgComple(bitmapData:BitmapData,url:String):void
		{
			if(nodeBG)
			{
				nodeBG.smoothing=true;
				nodeBG.bitmapData=bitmapData;
				nodeBG.x=-nodeBG.width*0.5;
				nodeBG.y=-nodeBG.height*0.5;
			}else
			{
				bitmapData.dispose();
			}
		}
		
		public function destroy():void
		{
			ToolTipManager.getInstance().detach(this);
			this.filters=null;
			if(nodeBG)
			{
				nodeBG.bitmapData&&nodeBG.bitmapData.dispose();
				nodeBG.parent&&nodeBG.parent.removeChild(nodeBG);
				nodeBG=null;
			}
			if(nodeBitmap)
			{
				nodeBitmap.bitmapData&&nodeBitmap.bitmapData.dispose();
				nodeBitmap.parent&&nodeBitmap.parent.removeChild(nodeBitmap);
				nodeBitmap=null;
			}
			if(nodeMc)
			{
				nodeMc.parent&&nodeMc.parent.removeChild(nodeMc);
				nodeMc = null;
			}
			if(nodeEffect)
			{
				nodeEffect.stop();
				nodeEffect.parent&&nodeEffect.parent.removeChild(nodeEffect);
				nodeEffect = null;
			}
			if(sprite)
			{
				sprite.parent&&sprite.parent.removeChild(sprite);
				sprite = null;
			}
			_isInitNodeEffect = false;
			_isInitNodeMc = false;
			
		}
		
		public function getTipData():Object
		{
			return _nodeCfg;
		}
		
		public function getTipType():int
		{
			return ToolTipConst.HERO_UGRADE_TIP;
		}

		public function get nodeCfg():HeroMeridiansCfgData
		{
			return _nodeCfg;
		}

		
		public function getTipCount():int
		{
			// TODO Auto Generated method stub
			return 1;
		}
		
	}
}