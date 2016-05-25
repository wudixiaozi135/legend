package com.view.gameWindow.tips.toolTip
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.ConstBind;
	import com.model.consts.ConstStorage;
	import com.model.consts.ItemType;
	import com.model.consts.JobConst;
	import com.model.consts.StringConst;
	import com.model.frame.FrameManager;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.expStone.ExpStoneData;
	import com.view.gameWindow.panel.panels.expStone.ExpStoneDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.TimeUtils;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import mx.utils.StringUtil;
	
	/**
	 * 道具tip
	 * @author jhj
	 */
	public class ItemBaseTip extends BaseTip
	{
		public static const NAME_X:int = 16;
		public static const NAME_Y:int = 16;
		public static const BIND_X:int = 220;
		public static const BIND_Y:int = 16;
		
		private var delayTimeText:TextField;
		private var lastTime:int = 300000;
		private var itemCount:int = 1;
		/** * 使用条件字段 */		
		private var userConditionArr:Array=[StringConst.LEVEL_NEED,StringConst.ENTITY_NEED,StringConst.JOB_NEED];
		
		protected var itemCfgData:ItemCfgData;
		protected var _cellEffectLoader:UIEffectLoader;
		
		private var _urlEffect:String;
		
		private var tip:TextTip;
		
		public function ItemBaseTip()
		{
			super();
			initView(_skin);
		}
		
		override public function dispose():void
		{
			super.dispose();
			destroyEffect();
		}
		
		private function destroyEffect():void
		{
			if(_cellEffectLoader)
			{
				_cellEffectLoader.destroy();
				_urlEffect = null;
			}
		}
		
		override public function setData(obj:Object):void
		{
			_data = obj;
			if(obj is BagData)
			{
				itemCfgData = ConfigDataManager.instance.itemCfgData(BagData(obj).id);
			}
			else if(obj is ItemCfgData)
			{
				itemCfgData = obj as ItemCfgData;
			}
			
			if(!itemCfgData)
			{
				return;
			}
			
			if(itemCfgData.type <= 20)
			{
				_skin.visible = false;
				addChildAt(tip,0);
				tip.setData(HtmlUtils.createHtmlStr(0xb4b4b4,itemCfgData.name + (itemCount >1?"x" + itemCount:"")));
				return;
			}
			setUseCondition(itemCfgData);
			setVariableProperty(itemCfgData);
			setSell(itemCfgData);
			setDelayTime(itemCfgData.expire);
			
			maxHeight += 18;
			height = maxHeight;
		}
		
		override public function setCount(count:int):void
		{
			itemCount = count;
		}
		
		
		override public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			super.urlBitmapDataReceive(url,bitmapData,info);
			_iconBmp.y = 46;
			
			if(itemCfgData)
			{
//				var size:int = 2;
//				var sp:Shape = new Shape();
//				var color:int = ItemType.getColorByQuality(itemCfgData.quality);
//				sp.graphics.lineStyle(size,color,0.7);
//				sp.graphics.beginFill(color,0);
//				sp.graphics.drawRect(0,0,_iconBmp.width,_iconBmp.height);
//				sp.graphics.endFill();
//				sp.x = _iconBmp.x;
//				sp.y = _iconBmp.y;
//				
//				if(_skin)
//				{
//					_skin.addChild(sp);
//				}
				var url:String = ItemType.getEffectUrlByQuality(itemCfgData.quality);
				if(_urlEffect != url)
				{
					_urlEffect = url;
					_cellEffectLoader = new UIEffectLoader(_skin,_iconBmp.x+_iconBmp.width/2,_iconBmp.y+_iconBmp.height/2,1,1,_urlEffect);
				}
			}
		}
		
		override public function updateTime(time:int):void
		{
			var delayTime:int = lastTime-time;
			lastTime = delayTime;
			if(delayTime <= 0)
			{
				delayTimeText.htmlText = "";
				hide(delayTimeText);
				delayTimeText = null;
				FrameManager.instance.removeObj(this);
				return;
			}
			
//			var min:int = delayTime/60000;
//			var sec:int = delayTime/1000%60;
//			var htmlStr:String = HtmlUtils.createHtmlStr(0xff0000,StringConst.SURPLUS+min+StringConst.MINIUTE+sec+StringConst.SECOND);
			var timeObj:Object = TimeUtils.calcTime(delayTime/1000);
			var htmlStr:String = HtmlUtils.createHtmlStr(0xff0000,StringConst.SURPLUS+TimeUtils.format(timeObj));
			delayTimeText.htmlText = htmlStr;
			delayTimeText.width = delayTimeText.textWidth + 10;
		}
		
		protected function setVariableProperty(itemCfgData:ItemCfgData):void
		{
			var newUrl:String = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD+itemCfgData.icon+ResourcePathConstants.POSTFIX_PNG;
			loadPic(newUrl);
			
			var htmlStr:String = HtmlUtils.createHtmlStr(ItemType.getColorByQuality(itemCfgData.quality),itemCfgData.name,15,true);
			var equipNameText:TextField = addProperty(htmlStr,NAME_X,NAME_Y);
//			htmlStr = HtmlUtils.createHtmlStr(0xffe1aa,"("+ItemType.itemName(itemCfgData.type)+")",12);
//			addProperty(htmlStr,104,50);
			setBind();
			
			maxHeight = NAME_Y + equipNameText.height + 6;
			
			setIconPos();
			
			if(_data is BagData)
			{
				setExpInfo(BagData(_data));
			}
			addDes(itemCfgData.desc);
			setUseMethod(itemCfgData.use_method);
		}
		
		private function setIconPos():void
		{
			var skin:PropTipSkin = _skin as PropTipSkin;
			skin.mcIcon.y = 40;
			maxHeight = skin.mcIcon.y + skin.mcIcon.height + 6;
		}
		
		/**
		 * 经验玉
		 */
		protected function setExpInfo(data:BagData):void
		{
			var expStone:ExpStoneDataManager = ExpStoneDataManager.instance;
			
			var item:ItemCfgData = expStone.getItem(data.storageType,data.slot);
			if(item)
			{
				var info:ExpStoneData = expStone.getExpInfo(data.storageType,data.slot);
				var exp:int = 0;
				var max:int = 0;
				if(info)
				{
					exp = info.exp;
					max = info.maxExp;
				}
				else
				{
					max = ExpStoneData.getMaxExp(item);
				}
				
				var htmlStr:String = HtmlUtils.createHtmlStr(0x00ff00,StringUtil.substitute(StringConst.EXP_STONE_TIP13,exp,max));
				maxHeight += 9;
				addProperty(htmlStr,18,maxHeight);
				maxHeight+=9;
			}
			
		}
		
		protected function setBind():void
		{
			if(_data.hasOwnProperty("bind")&&_data.bind == ConstBind.HAS_BIND)
			{
				var htmlStr:String = HtmlUtils.createHtmlStr(0xff0000,StringConst.TYPE_BIND_2,13);
				addProperty(htmlStr,BIND_X,BIND_Y);
			}
		}
		
		protected function setDelayTime(time:int):void
		{
			if(time>0)
			{
				maxHeight += 10;
				addSplitLine(20,maxHeight);
				FrameManager.instance.addObj(this);
				maxHeight += 10;
				delayTimeText = new TextField();
				delayTimeText.x = 20;
				delayTimeText.y = maxHeight;
				addChild(delayTimeText);
				maxHeight += 12/*delayTimeText.textHeight*/;
			}
		}
		
		protected function setUseCondition(itemCfgData:ItemCfgData):void
		{
			var htmlStrArr:Array = [];
			var htmlStr:String;
			
			/*htmlStr = HtmlUtils.createHtmlStr(0xffe599,StringConst.EQUIP_TYPE+StringConst.COLON,12)+HtmlUtils.createHtmlStr(0xffe599,ItemType.itemName(itemCfgData.type),12);
			htmlStrArr.push(htmlStr);*/
			var bagData:BagData = _data as BagData;
			for each(var propertyName:String in userConditionArr)
			{
				switch(propertyName)
				{
					case StringConst.LEVEL_NEED:
						if(itemCfgData.level <= 0)
						{
							continue
						}
						var isEnough:Boolean;
						if(bagData && bagData.storageType == ConstStorage.ST_CHR_BAG)
						{
							isEnough = RoleDataManager.instance.checkReincarnLevel(itemCfgData.reincarn,itemCfgData.level);
						}
						else if(bagData && bagData.storageType == ConstStorage.ST_HERO_BAG)
						{
							isEnough = HeroDataManager.instance.checkReincarnLevel(itemCfgData.reincarn,itemCfgData.level);
						}
						else
						{
							isEnough = RoleDataManager.instance.checkReincarnLevel(itemCfgData.reincarn,itemCfgData.level);
						}
						var levelColor:int = isEnough ? 0xffe599 : 0xff0000 ;
						var levelStr:String = itemCfgData.reincarn == 0? itemCfgData.level+StringConst.LEVEL : itemCfgData.reincarn+StringConst.REINCARN+itemCfgData.level+StringConst.LEVEL;
						htmlStr = HtmlUtils.createHtmlStr(levelColor,StringConst.LEVEL_NEED+StringConst.COLON)+HtmlUtils.createHtmlStr(levelColor,levelStr,13);
						htmlStrArr.push(htmlStr);
						break;
					case StringConst.JOB_NEED:
						var job:int = itemCfgData.job;
						var myJob:int;
						if(bagData && bagData.storageType == ConstStorage.ST_CHR_BAG)
						{
							myJob = RoleDataManager.instance.job;
						}
						else if(bagData && bagData.storageType == ConstStorage.ST_HERO_BAG)
						{
							myJob = HeroDataManager.instance.job;
						}
						else
						{
							myJob = RoleDataManager.instance.job;
						}
						if(job == JobConst.TYPE_NO)
						{
							continue;
						}
						var jobValue:String = JobConst.jobName(job);
						var jobColor:int = myJob == job ? 0xffe599 : 0xff0000;
						htmlStr = HtmlUtils.createHtmlStr(jobColor,StringConst.JOB_NEED+StringConst.COLON)+HtmlUtils.createHtmlStr(jobColor,jobValue,12);
						htmlStrArr.push(htmlStr);
						break;
					case StringConst.ENTITY_NEED:
						if(itemCfgData.entity == EntityTypes.ET_NONE)
						{
							continue;
						}
						var str:String = itemCfgData.entity == EntityTypes.ET_HERO ? StringConst.ENTITY_TYPE_HERO:StringConst.ENTITY_TYPE_PLAYER;
						htmlStr = HtmlUtils.createHtmlStr(0xffe599,propertyName+StringConst.COLON,12)+HtmlUtils.createHtmlStr(0xffe599,str,12);
						htmlStrArr.push(htmlStr);
						break;
						
				}
			}
			
			var theY:int = 40;
			for(var i:int = 0;i<htmlStrArr.length;i++)
			{
				if( i == 0)
					theY += 11;
				
				var tf:TextField = addProperty(htmlStrArr[i],95,theY);
				if(htmlStrArr.length == 1)
				{
					if(itemCfgData.use_method == "")
						theY += tf.textHeight+1;
					else
						theY += tf.textHeight-1;;
				}
				else if(i == htmlStrArr.length-1)
				{
					if(itemCfgData.use_method == "")
						theY += tf.textHeight+1;
					else
						theY += tf.textHeight-1;
				}
				else
				{
					theY += tf.textHeight+6; 
				}
			}
			maxHeight = Math.max(maxHeight,theY);
		}
		
		protected function setUseMethod(useMthod:String):void
		{
			if(useMthod == "")
				return;
			
			var htmlStrArr:Array = CfgDataParse.pareseDes(useMthod,0xffffff);
			
			for (var i:int = 0;i<htmlStrArr.length;i++)
			{
				if(i == 0)
					maxHeight += 11;
				var tf:TextField = addProperty(htmlStrArr[i],18,maxHeight);
				if(tf.numLines == 1 && htmlStrArr.length == 1)
					maxHeight = tf.y+tf.textHeight-2;
				else if(i<htmlStrArr.length-1)
					maxHeight = tf.y+tf.textHeight+4;
				else if(tf.numLines == 1)
					 maxHeight = tf.y+tf.textHeight-3;
				else 
					 maxHeight = tf.y+tf.textHeight;
			}
		}
		
//		private function setDes(desc:String):void
//		{
//			if(desc == "")
//				return;
//			
//			var htmlStrArr:Array = CfgDataParse.pareseDes(desc,0xffffff);
//			
//			if(htmlStrArr.length>0)
//				maxHeight += 11;
//			
//			for (var i:int = 0;i<htmlStrArr.length;i++)
//			{
//				var desText:TextField = addProperty(htmlStrArr[i],18,maxHeight,true);
//				if(desText.numLines == 1 && htmlStrArr.length == 1)
//				    maxHeight = desText.y+desText.textHeight-2;
//				else if(i<htmlStrArr.length-1)
//				    maxHeight = desText.y+desText.textHeight+4;
//				else
//					maxHeight = desText.y+desText.textHeight;
//			}
//		}
		
		private function setSell(itemCfgData:ItemCfgData):void
		{
			maxHeight += 9;
			addSplitLine(15,maxHeight);
			maxHeight += 9;
			//
			var htmlStr:String;
			htmlStr = HtmlUtils.createHtmlStr(0xffe599,StringConst.SELL_PRIECE+StringConst.COLON)+
				HtmlUtils.createHtmlStr(itemCfgData.can_sell ? 0xffc000 : 0xc00000,itemCfgData.can_sell ? itemCfgData.sell_value.toString() : StringConst.NO_SELL);
			addProperty(htmlStr,20,maxHeight);
			maxHeight += 9;
		}
		
//		private function addProperty(htmlStr:String, x:int, y:int ,isSetLeading:Boolean = false):TextField
//		{
//			var text:TextField = new TextField();
//			addChild(text);
//			text.width = 250;
//			text.autoSize = TextFieldAutoSize.LEFT;
//			text.htmlText = htmlStr;
//			text.wordWrap = true;
//			text.multiline =true;
//			text.x = x;
//			text.y = y;
//			text.filters = [_filter];
//			return text;
//		}
//		
//		private function loadSplitLine(x:int, y:int):DelimiterLine
//		{
//			var splitLine:DelimiterLine = new DelimiterLine();
//			addChild(splitLine);
//			splitLine.x = x;
//			splitLine.y = y;
//			super.initView(splitLine);
//			return splitLine;
//		}
		
		override public function initView(mc:MovieClip):void
		{
			if(!mc)
			{
				_skin = new PropTipSkin();
				addChildAt(_skin,0);
				mc = _skin
				tip = new TextTip();
			}
			super.initView(mc);
		}
	}
}