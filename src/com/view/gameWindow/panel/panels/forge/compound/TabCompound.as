package com.view.gameWindow.panel.panels.forge.compound
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.CombineCfgData;
	import com.model.consts.ConstBind;
	import com.model.consts.DistingguishConst;
	import com.model.consts.EffectConst;
	import com.model.consts.FontFamily;
	import com.model.consts.MatrialTypeConst;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.forge.ForgeDataManager;
	import com.view.gameWindow.panel.panels.forge.McCompound;
	import com.view.gameWindow.panel.panels.forge.compound.slider.CompoundItemSlider;
	import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.gameWindow.util.cell.CompoundCell;
	import com.view.gameWindow.util.scrollBar.ScrollBar;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.utils.StringUtil;
	
	public class TabCompound extends TabBase
	{
		/**当前材料数据*/
		internal var currentCfgDt:CombineCfgData;
		/**-1:不能合成       0:能合成，合成为不绑定材料    1:能合成，合成为绑定材料*/
		internal var compoundType:int=-1;
		/**三种材料是同一种*/
		internal var isSame:Boolean=true;
		/**true为背包数据  false为英雄背包数据*/
		internal var isUseBag:Boolean=true;
		/**是否显示可合成物品*/
		internal var isShowCombine:Boolean=false;
		/**合成物品的类型数*/
		private var _matrialType:int = 0;
		
		private var _skinThis:McCompound;
		
		private var _mouseEvent:CompoundMouseEvent;
		
		private var _sidebar:CompoundItemSlider;
		private var _sideBarScrollBar:ScrollBar;
		private var _sidebarWidth:Number = 202;
		private var _sidebarHeight:Number = 375;
		
		private var _cellArr:Vector.<CompoundCell>;
		
		private var _needMatrial1Num:int=1;
		private var _needMatrial2Num:int=1;
		private var _needMatrial3Num:int=1;
		private var _needAllMatrialNum:int=3;//合成所需材料数量,一般为3个
		/**二级分类文字*/
		private var _distinguishArr:Array;
		/**一级分类集合*/
		private var _type1Vec:Array = [];
		/**二级分类集合*/
		private var _type2Vec:Array = [];
		/**所有材料的数量信息*/
		private var _allMaterialsVec:Vector.<CombineType1Data>=new Vector.<CombineType1Data>;
		/**可合成的材料的数量信息*/
		private var _canCombineMaterialsVec:Vector.<CombineType1Data>=new Vector.<CombineType1Data>;
		
		private var _forgeCount:int;
		private var _uiEffectLoader:UIEffectLoader;
		
		private var _sprite:Sprite;
		/**当前强化的选中合成的物品数据*/
		private var _data:Object;
		
		public function TabCompound()
		{
			super();
			_type1Vec.push([1, StringConst.FORGE_PANEL_00001]);
			_type1Vec.push([2, StringConst.FORGE_PANEL_00002]);
			/*_type1Vec.push([3, StringConst.FORGE_PANEL_00003]);*/
			_type1Vec.push([4, StringConst.FORGE_PANEL_00004]);
			/*_type1Vec.push([5, StringConst.FORGE_PANEL_00005]);*/
			_type1Vec.push([6, StringConst.FORGE_PANEL_00006]);
			
			_type2Vec.push([0, StringConst.FORGE_PANEL_0115]);
			_type2Vec.push([1, StringConst.FORGE_PANEL_0116]);
			_type2Vec.push([2, StringConst.FORGE_PANEL_0117]);
			_type2Vec.push([3, StringConst.FORGE_PANEL_0118]);
			_type2Vec.push([4, StringConst.FORGE_PANEL_0119]);
			_type2Vec.push([5, StringConst.FORGE_PANEL_0120]);
			_type2Vec.push([6, StringConst.FORGE_PANEL_0121]);
			_type2Vec.push([11, StringConst.FORGE_PANEL_0122]);
			_type2Vec.push([12, StringConst.FORGE_PANEL_0123]);
			_type2Vec.push([13, StringConst.FORGE_PANEL_0124]);
			_type2Vec.push([14, StringConst.FORGE_PANEL_0125]);
			_type2Vec.push([21, StringConst.FORGE_PANEL_0126]);
			_type2Vec.push([31, StringConst.FORGE_PANEL_0127]);
			_type2Vec.push([41, StringConst.FORGE_PANEL_0128]);
			_type2Vec.push([42, StringConst.FORGE_PANEL_0129]);
			_type2Vec.push([43, StringConst.FORGE_PANEL_0130]);
			_type2Vec.push([44, StringConst.FORGE_PANEL_0131]);
		}
		
		override protected function initSkin():void
		{
			_skin = new McCompound();
			_skinThis = _skin as McCompound;
			addChild(_skinThis);
		}
		
		override protected function initData():void
		{
			_skinThis.txtCount.restrict = "0-9";
			
			_mouseEvent = new CompoundMouseEvent(this);
			_mouseEvent.addEvent(_skinThis);
			
			_sprite = new Sprite();
			addChild(_sprite);
			
			_skinThis.txtCoin.text = StringConst.COMPOUND_PANEL_0001;
			_skinThis.txtGold.text = StringConst.COMPOUND_PANEL_0002;
			_skinThis.txtTip.htmlText = HtmlUtils.createHtmlStr(_skinThis.txtTip.textColor,StringConst.COMPOUND_PANEL_0003,12,false,2,FontFamily.FONT_NAME,true);
			ToolTipManager.getInstance().attachByTipVO(_skinThis.txtTip,ToolTipConst.TEXT_TIP,HtmlUtils.createHtmlStr(0xffe1aa,StringConst.COMPOUND_PANEL_TIP));
			
			initialize();
		}
		
		private function initialize():void
		{
			_sidebar = new CompoundItemSlider(_sidebarWidth,_sidebarHeight,callback);
			_sidebar.addEventListener(Event.CHANGE,mapSidebarChange);
			(_skin as McCompound).sidebarPos.addChild(_sidebar);
			//
			_distinguishArr = [];
			var obj:Object;
			for(var i:int=0;i<=13;i++)
			{
				obj = {};
				obj.type=DistingguishConst["TYPE_"+String(i)];
				obj.txt=StringConst["FORGE_PANEL_01"+String(i+15)];
				_distinguishArr.push(obj);
			}
			getMaterialsNumMsg();
			addSigns();
			addMatrials();
		}
		
		private function mapSidebarChange(e:Event):void
		{
			if(_sideBarScrollBar)
			{
				_sideBarScrollBar.resetScroll();
			}
		}
		/**获取所有一级材料的可合成数量信息*/
		private function getMaterialsNumMsg():void
		{
			var len:int=_type1Vec.length;
			var len2:int=_type2Vec.length;
			var type1:int;
			var type2:int;
			var combineType1Data:CombineType1Data;
			var combineType2Data:CombineType2Data;
			for(var i:int=0;i<len;i++)
			{
				type1=_type1Vec[i][0];
				combineType1Data=new CombineType1Data;
				combineType1Data.type=_type1Vec[i][0];
				combineType1Data.name=_type1Vec[i][1];
				combineType1Data.combineVec=new Vector.<CombineType2Data>;
				for(var j:int=0;j<len2;j++)
				{
					type2=_type2Vec[j][0];
					combineType2Data=getCombineType2Data(type1,type2,_type2Vec[j][1]);
					if(combineType2Data.combineVec.length>=1)
					{
						combineType1Data.combineVec.push(combineType2Data);
						combineType1Data.canCombineNum+=combineType2Data.canCombineNum;
					}
				}
				_allMaterialsVec.push(combineType1Data);
				if(combineType1Data.canCombineNum>0)
				{
					trace("TabCompound.getMaterialsNumMsg() 该一级分类：",combineType1Data.type,combineType1Data.canCombineNum);
				}
			}
		}
		/**获取二级合成材料*/
		private function getCombineType2Data(type:int,type2:int,name:String):CombineType2Data
		{
			var vec:Vector.<CombineCfgData>;
			if (type == 2 && type2 == 6)
			{
				vec = CombineFilterUtil.getSatisfyCombineDatas(type, type2);
			} else
			{
				vec = ConfigDataManager.instance.getType2Data(type, type2);
			}
			vec.sort(sortCombineType);
			var arr:Array = [];
			var combineData:CombineData;
			var combineType2Data:CombineType2Data = new CombineType2Data;
			combineType2Data.type = type;
			combineType2Data.type2 = type2;
			combineType2Data.name = name;
			combineType2Data.combineVec = new Vector.<CombineData>;
			//
			for each(var comboineMsg:CombineCfgData in vec)
			{
				var combineNum:int = getCanCombineNum(comboineMsg);
				combineData = new CombineData;
				combineData.id = comboineMsg.id;
				combineData.canCombineNum = combineNum;
				combineData.type = comboineMsg.type;
				combineData.type2 = comboineMsg.distinguish;
				combineData.name = comboineMsg.name;
				combineData.color = comboineMsg.color;
				combineType2Data.combineVec.push(combineData);
				combineType2Data.canCombineNum += combineNum;
				if(combineNum>0)
				{
					trace("可合成的id：",combineData.type,combineData.type2,comboineMsg.id,comboineMsg.material1_id,combineNum);
				}
			}
			if(combineType2Data.canCombineNum>0)
			{
				trace("该二级分类可合成数量：",combineType2Data.type,combineType2Data.type2,combineType2Data.canCombineNum);
			}
			return combineType2Data;
		}
		
		private function sortCombineType(temp1:CombineCfgData,temp2:CombineCfgData):int
		{
			if(temp1.id>temp2.id)
			{
				return 1;
			}
			return -1;
		}
		/**获得可合成数量*/
		private function getCanCombineNum(data:CombineCfgData):int
		{
			var bagBindNum:int;
			var heroBindNum:int;
			var bagUnbindNum:int;
			var heroUnbindNum:int;
			var needNum:int;
			var combineNum:int=0;
			//当三个条件id一样时
			if(data.isMaterialAllSame)
			{
				var _bagManager:BagDataManager = BagDataManager.instance;
				var _heroManager:HeroDataManager = HeroDataManager.instance;
				bagBindNum = _bagManager.getItemNumById(data.material1_id,ConstBind.HAS_BIND);
				heroBindNum = _heroManager.getItemNumById(data.material1_id,ConstBind.HAS_BIND);
				bagUnbindNum = _bagManager.getItemNumById(data.material1_id,ConstBind.NO_BIND);
				heroUnbindNum = _heroManager.getItemNumById(data.material1_id,ConstBind.NO_BIND);
				needNum = data.material1_count+data.material2_count+data.material3_count;
				if(bagBindNum >= needNum)
				{
					combineNum = Math.floor(bagBindNum/needNum);
				}
				else if(heroBindNum >= needNum)
				{
					combineNum = Math.floor(heroBindNum/needNum);
				}
				if(bagUnbindNum >= needNum)
				{
					combineNum += Math.floor(bagUnbindNum/needNum);
				}
				else if(heroUnbindNum >= needNum)
				{
					combineNum += Math.floor(heroUnbindNum/needNum);
				}
			}
			else
			{
				var count1:int = getCanCombineNumById(data.material1_id,data.material1_count);
				var count2:int = getCanCombineNumById(data.material2_id,data.material2_count);
				var count3:int = getCanCombineNumById(data.material3_id,data.material3_count);
				combineNum = Math.min(count1,count2,count3);
			}
			return combineNum;
		}
		/**添加标志点*/
		private function addSigns():void
		{
			var numArr:Array = [];
			if(_sidebar)
			{ 
				_sidebar.chear();
				for(var i:int=0;i<_allMaterialsVec.length;i++)
				{
					numArr.push(_allMaterialsVec[i].canCombineNum);
				}
				_sidebar.setStrengMaterialFolderData(_distinguishArr,MatrialTypeConst.STRENG_MATERIAL_TYPE,_allMaterialsVec[0]);
				_sidebar.setUpMaterialcFolderData(_distinguishArr,MatrialTypeConst.UP_MATERIAL_TYPE,_allMaterialsVec[1]);
				/*_sidebar.setSkillRunesFolderData(_distinguishArr,MatrialTypeConst.SKILL_RUNES_TYPE,_allMaterialsVec[2]);*/
				_sidebar.setExpItemFolderData(_distinguishArr,MatrialTypeConst.SKILL_EXP_ITEM,_allMaterialsVec[2]);
				/*_sidebar.setTreasureFolderData(_distinguishArr,MatrialTypeConst.SKILL_TREASURE,_allMaterialsVec[4]);*/
				_sidebar.setSkillBookFolderData(_distinguishArr,MatrialTypeConst.SKILL_SKILL_BOOK,_allMaterialsVec[3]);
				_sidebar.addListFolder();
				_sidebar.changMaterialNum(numArr);
				_sidebar.updatePos();
			}
		}
		
		private function addMatrials():void 
		{
			var compoundCell:CompoundCell;
			var compound:CompoundCell;
			_cellArr=new Vector.<CompoundCell>();
			for(var i:int=1;i<=3;i++)
			{
				compoundCell=new CompoundCell(_skinThis["material"+i],0,0,60,60);
				compoundCell.scaleX=0.8;
				compoundCell.scaleY=0.8;
				_cellArr.push(compoundCell);
				ToolTipManager.getInstance().attach(compoundCell);
			}
			
			compound=new CompoundCell(_skinThis["material"],0,0,60,60);
			_cellArr.push(compound);
			ToolTipManager.getInstance().attach(compound);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(_skinThis.mcScrollBar,function(mc:MovieClip):void
			{
				_sideBarScrollBar = new ScrollBar(_sidebar,mc,0,_sidebar,15);
				_sideBarScrollBar.resetHeight(_sidebarHeight);
			});
			rsrLoader.addCallBack(_skinThis.btnSure,function():void
			{
				_skinThis.btnSure.txt.text = StringConst.FORGE_PANEL_00013;
				
				InterObjCollector.instance.add(_skinThis.btnSure);
			});
		}
		
		public function clickOnAddFunc():void
		{
			if(!currentCfgDt)
			{
				return;
			}
			var count:int= int(_skinThis.txtCount.text);
			count++;
			if(count>_forgeCount)
			{
				count=_forgeCount;
			}
			_skinThis.txtCount.text=count+"";
			_skinThis.coinTxt.text=String(currentCfgDt.coin*count);
			_skinThis.unbindGoldTxt.text=String(currentCfgDt.unbind_gold*count);
		}
		
		public function clickOnReduce():void
		{
			if(!currentCfgDt)
			{
				return;
			}
			var count:int= int(_skinThis.txtCount.text);
			count--;
			if(count<1)
			{
				count=0;
			}
			_skinThis.txtCount.text=count+"";
			_skinThis.coinTxt.text=String(currentCfgDt.coin*count);
			_skinThis.unbindGoldTxt.text=String(currentCfgDt.unbind_gold*count);
		}
		
		public function checkComPoundCount():void
		{
			var count:int= int(_skinThis.txtCount.text);
			if(count<1)
			{
				count=0
			}
			else if(count>_forgeCount)
			{
				count=_forgeCount;
			}
			if(currentCfgDt)
			{
				_skinThis.txtCount.text=count+"";
				_skinThis.coinTxt.text=String(currentCfgDt.coin*count);
				_skinThis.unbindGoldTxt.text=String(currentCfgDt.unbind_gold*count);
			}
			else
			{
				_skinThis.txtCount.text="";
				_skinThis.coinTxt.text="";
				_skinThis.unbindGoldTxt.text="";
			}
		}
		/**点击三级分类(材料)后*/
		private function callback(data:Object):void
		{
			_data = data;
			var i:int;
			var compoundCell:CompoundCell;
			var bagBindNum:int;
			var bagUnbindNum:int;
			var heroBindNum:int;
			var heroUnbindNum:int;
			var matrial1ID:int;
			var matrial2ID:int;
			var matrial3ID:int;
			
			//初始化
			_forgeCount = 1;
			_matrialType = 0;
			/**展示材料数量*/
			var showMatricalNum:int = 0;
			isSame = false;
			compoundType = -1;
			currentCfgDt = ConfigDataManager.instance.getCombineDataByID(data.type,data.id);
			matrial1ID = currentCfgDt.material1_id;
			if(matrial1ID)
			{
				_matrialType += 1;
			}
			matrial2ID = currentCfgDt.material2_id;
			if(matrial2ID)
			{
				_matrialType += 1;
			}
			matrial3ID = currentCfgDt.material3_id;
			if(matrial3ID)
			{
				_matrialType += 1;
			}
			//三种材料相同
			if(currentCfgDt.isMaterialAllSame)
			{
				isSame = true;
				var _bagManager:BagDataManager = BagDataManager.instance;
				var _heroManager:HeroDataManager = HeroDataManager.instance;
				bagBindNum = _bagManager.getItemNumById(currentCfgDt.material1_id,ConstBind.HAS_BIND);
				heroBindNum = _heroManager.getItemNumById(currentCfgDt.material1_id,ConstBind.HAS_BIND);
				bagUnbindNum = _bagManager.getItemNumById(currentCfgDt.material1_id,ConstBind.NO_BIND);
				heroUnbindNum = _heroManager.getItemNumById(currentCfgDt.material1_id,ConstBind.NO_BIND);
				_needAllMatrialNum = currentCfgDt.material1_count+currentCfgDt.material2_count+currentCfgDt.material3_count;
				
				if(bagBindNum >= _needAllMatrialNum)//背包绑定材料满足合成数量
				{
					showMatricalNum = _needAllMatrialNum;
					_forgeCount=Math.floor(bagBindNum/_needAllMatrialNum);
					compoundType=1;
					isUseBag=true;
				}
				else if(heroBindNum>=_needAllMatrialNum)//英雄背包绑定材料满足合成数量
				{
					showMatricalNum =_needAllMatrialNum;
					_forgeCount=Math.floor(heroBindNum/_needAllMatrialNum);
					compoundType=1;
					isUseBag=false;
				}
				else if(bagUnbindNum>=_needAllMatrialNum)//背包不绑定材料满足合成数量
				{
					showMatricalNum =_needAllMatrialNum;
					_forgeCount=Math.floor(bagUnbindNum/_needAllMatrialNum);
					compoundType=0;
					isUseBag=true;
				}
				else if(heroUnbindNum>=_needAllMatrialNum)//英雄背包不绑定材料满足合成数量
				{
					showMatricalNum =_needAllMatrialNum;
					_forgeCount=Math.floor(heroUnbindNum/_needAllMatrialNum);
					compoundType=0;
					isUseBag=false;
				}
				else if(bagBindNum>0)//各种背包里的绑定和不绑定材料数量不满足合成数量,那就按照顺序选择一种显示出来
				{
					showMatricalNum = bagBindNum;
					isUseBag=true;
				}
				else if(heroBindNum>0)
				{
					showMatricalNum = heroBindNum;
					isUseBag=false;
				}
				else if(bagUnbindNum>0)
				{
					showMatricalNum = bagUnbindNum;
					isUseBag=true;
				}
				else if(heroUnbindNum>0)
				{
					showMatricalNum = heroUnbindNum;
					isUseBag=false;
				}
			}
			else//三种材料各不相同
			{
				isSame=false;
				var count1:int = getCanCombineNumById(currentCfgDt.material1_id,currentCfgDt.material1_count);
				var count2:int = getCanCombineNumById(currentCfgDt.material2_id,currentCfgDt.material2_count);
				var count3:int = getCanCombineNumById(currentCfgDt.material3_id,currentCfgDt.material3_count);
				_forgeCount = Math.min(count1,count2,count3);
			}
			//清空原先的图
			for(i=0;i<3;i++)
			{
				compoundCell=_cellArr[i];
				compoundCell.setNull();
			}
			//更新图片
			var needNumAdd:int;
			for(i=0;i<3;i++)
			{
				compoundCell = _cellArr[i];
				var matrialId:String = "material{0}_id";
				var matrialType:String = "material{0}_type";
				matrialId = StringUtil.substitute(matrialId,i+1);
				matrialType = StringUtil.substitute(matrialType,i+1);
				
				var id:int = currentCfgDt["material"+(i+1)+"_id"] as int;
				var needNum:int = currentCfgDt["material"+(i+1)+"_count"] as int;
				needNumAdd += needNum;
				var oweNum:int = getItemCountById(id,needNum);
				
				if((isSame && showMatricalNum < needNumAdd) || (!isSame && oweNum < needNum))
				{
					compoundCell.isShowFilters = true;
				}
				else
				{
					compoundCell.isShowFilters = false;
				}
				
				compoundCell.setItem(compoundCell,currentCfgDt[matrialType],currentCfgDt[matrialId]);
			}
			
			compoundCell = _cellArr[3];
			compoundCell.setItem(compoundCell,currentCfgDt.combined_type,currentCfgDt.combined_id);
			//
			_skinThis.coinTxt.text = String(currentCfgDt.coin*_forgeCount);
			_skinThis.material1txt.visible = currentCfgDt.material1_count>0;
			_skinThis.material1txt.text = StringUtil.substitute(StringConst.FORGE_PANEL_0026,currentCfgDt.material1_count);
			_skinThis.material2txt.visible = currentCfgDt.material2_count>0;
			_skinThis.material2txt.text = StringUtil.substitute(StringConst.FORGE_PANEL_0026,currentCfgDt.material2_count);
			_skinThis.material3txt.visible = currentCfgDt.material3_count>0;
			_skinThis.material3txt.text = StringUtil.substitute(StringConst.FORGE_PANEL_0026,currentCfgDt.material3_count);
			//
			var count:String = !currentCfgDt.isMaterialAllSame ? getItemCountById(matrial1ID,currentCfgDt.material1_count)+"" : "0";
			_skinThis.material1txtc.text = count;
			_skinThis.material1txtc.visible = _skinThis.material1txtc.text!="0";
			count = !currentCfgDt.isMaterialAllSame ? getItemCountById(matrial1ID,currentCfgDt.material2_count)+"" : "0";
			_skinThis.material2txtc.text = count;
			_skinThis.material2txtc.visible = _skinThis.material2txtc.text!="0";
			count = !currentCfgDt.isMaterialAllSame ? getItemCountById(matrial1ID,currentCfgDt.material3_count)+"" : "0";
			_skinThis.material3txtc.text = count;
			_skinThis.material3txtc.visible = _skinThis.material3txtc.text!="0";
			//
			_skinThis.txtCount.text=_forgeCount+"";
			
			if(currentCfgDt.unbind_gold>0)
			{
				_skinThis.unbindGoldTxt.visible=true;
				_skinThis.txtGold.visible=true;
				_skinThis.unbindGoldbg.visible=true;
			}
			else
			{
				_skinThis.unbindGoldTxt.visible=false;
				_skinThis.txtGold.visible=false;
				_skinThis.unbindGoldbg.visible=false;
			}
			_skinThis.unbindGoldTxt.text=String(currentCfgDt.unbind_gold*_forgeCount);
		}
		/**这方法命名有点诡异，根据id，以及需要的数量，返回满足这一个条件的次数*/
		private function getCanCombineNumById(id:int,needNum:int):int
		{
			if(needNum == 0)
			{
				return int.MAX_VALUE;
			}
			var bagBindNum:int;
			var heroBindNum:int;
			var bagUnbindNum:int;
			var heroUnbindNum:int;
			var combineNum:int=0;
			
			var bagManager:BagDataManager = BagDataManager.instance;
			var heroManager:HeroDataManager = HeroDataManager.instance;
			bagBindNum=bagManager.getItemNumById(id,ConstBind.HAS_BIND);
			heroBindNum=heroManager.getItemNumById(id,ConstBind.HAS_BIND);
			bagUnbindNum=bagManager.getItemNumById(id,ConstBind.NO_BIND);
			heroUnbindNum=heroManager.getItemNumById(id,ConstBind.NO_BIND);
			if(bagBindNum>=needNum)
			{
				combineNum=Math.floor(bagBindNum/needNum);
				compoundType=1;
				isUseBag=true;
			}
			else if(heroBindNum>=needNum)
			{
				combineNum=Math.floor(heroBindNum/needNum);
				compoundType=1;
				isUseBag=false;
			}
			if(bagUnbindNum>=needNum)
			{
				combineNum=Math.floor(bagUnbindNum/needNum);
				compoundType=0;
				isUseBag=true;
			}
			else if(heroUnbindNum>=needNum)
			{
				combineNum=Math.floor(heroUnbindNum/needNum);
				compoundType=0;
				isUseBag=false;
			}
			return combineNum;
		}
		/**获得该道具的数量，因为要区分英雄，绑定与否*/
		private function getItemCountById(id:int,needNum:int):int
		{
			var bagBindNum:int;
			var heroBindNum:int;
			var bagUnbindNum:int;
			var heroUnbindNum:int;
			var itemCount:int=0;
			
			var bagManager:BagDataManager = BagDataManager.instance;
			var heroManager:HeroDataManager = HeroDataManager.instance;
			bagBindNum=bagManager.getItemNumById(id,ConstBind.HAS_BIND);
			heroBindNum=heroManager.getItemNumById(id,ConstBind.HAS_BIND);
			bagUnbindNum=bagManager.getItemNumById(id,ConstBind.NO_BIND);
			heroUnbindNum=heroManager.getItemNumById(id,ConstBind.NO_BIND);
			if(bagBindNum>=needNum)
			{
				itemCount=bagBindNum;
			}
			else if(heroBindNum>=needNum)
			{
				itemCount=heroBindNum;
			}
			if(bagUnbindNum>=needNum)
			{
				itemCount=bagUnbindNum;
			}
			else if(heroUnbindNum>=needNum)
			{
				itemCount=heroUnbindNum;
			}
			else if(bagBindNum>0)
			{
				itemCount=bagBindNum;
			}
			else if(heroBindNum>0)
			{
				itemCount=heroBindNum;
			}
			else if(bagUnbindNum>0)
			{
				itemCount=bagUnbindNum;
			}
			else if(heroUnbindNum>0)
			{
				itemCount=heroUnbindNum;
			}
			return itemCount;
		}
		
		override public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_BAG_ITEMS || proc == GameServiceConstants.SM_HERO_INFO)
			{
				_allMaterialsVec = new Vector.<CombineType1Data>;
				getMaterialsNumMsg();
				refreshCombineData();
				if(_data)
				{
					callback(_data);
				}
			}
			else if(proc == GameServiceConstants.CM_COMBINE)
			{
				refreshData();
				if(_matrialType == 1)
				{
					destroyEffect();
					_uiEffectLoader = new UIEffectLoader(_sprite,662,428,1,1,EffectConst.RES_ITEMNUM1,null,true);
				}
				else if(_matrialType == 3)
				{
					destroyEffect();
					_uiEffectLoader = new UIEffectLoader(_sprite,570,170,1,1,EffectConst.RES_ITEMNUM3,null,true);
				}
			}
		}
		
		private function destroyEffect():void
		{
			if(_uiEffectLoader)
			{
				_uiEffectLoader.destroy();
				_uiEffectLoader = null;
			}
		}
		/**更新合成情况*/
		private function refreshCombineData():void
		{
			_sidebar.refreshData(_allMaterialsVec,isShowCombine);
		}
		/**刷新数据*/
		private function refreshData():void
		{
			if(currentCfgDt)
			{
				callback(currentCfgDt);
			}
		}
		
		override public function destroy():void
		{
			var cell:CompoundCell;
			for each (cell in _cellArr) 
			{
				ToolTipManager.getInstance().detach(cell);
			}
			ToolTipManager.getInstance().detach(_skinThis.txtTip);
			destroyEffect();
			if(_mouseEvent)
			{
				_mouseEvent.destoryEvent();
			}
			
			InterObjCollector.instance.remove(_skinThis.btnSure);
			
			_mouseEvent = null;
			_skinThis = null;
			//
			super.destroy();
		}
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			ForgeDataManager.instance.attach(this);
			BagDataManager.instance.attach(this);
			HeroDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			ForgeDataManager.instance.detach(this);
			HeroDataManager.instance.detach(this);
			BagDataManager.instance.detach(this);
			super.detach();
		}
		
	}
}