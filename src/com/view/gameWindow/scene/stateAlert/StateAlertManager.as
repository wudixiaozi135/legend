package com.view.gameWindow.scene.stateAlert
{

		import com.model.business.fileService.constants.ResourcePathConstants;
		import com.view.gameWindow.scene.entity.entityItem.interf.ILivingUnit;
		import com.view.gameWindow.scene.entity.entityItem.interf.IMonster;
		
		import flash.display.Bitmap;
		import flash.display.BitmapData;
		import flash.display.DisplayObjectContainer;
		import flash.display.Sprite;
		import flash.geom.Point;
		import flash.utils.Dictionary;
		
		public class StateAlertManager
		{
			private static var _stateImages : Dictionary;
			private static var _unloadedImages : Array;
			private static var _errorImages : Array;
			private static var _nLoadTime : int;
			
			private static var _instance : StateAlertManager;
			//states
			public static const VOILENT : String = "voilent";//暴击
			public static const DODGE : String = "dodge";//闪避
			public static const CRIT : String = "crit";//会心
			public static const PARRY : String = "parry";//格挡
			public static const NUQI : String = "nuqi";//怒气
			public static const DIDANG : String = "didang";//抵挡
//			public static const JINGYAN : String = "greenExp";//经验
			
			public static const SMALL_YELLOW : String = "samll_yellow";
			public static const SMALL_RED : String = "small_red";
			public static const LARGE_YELLOW : String = "large_yellow";
			public static const LARGE_RED : String = "large_red";
			public static const GREEN : String = "green";
			public static const BLUE : String = "blue";
			public static const ORANGE : String = "orange";
			public static const RED : String = "red";
			public static const YELLOW : String = "yellow";
			public static const FIGHTNUM : String = "fightChange";
			public static const HP : String = "hp";
			
			public static const GREEN_EXP : String = "green_exp";
			public static const BISHA :String = "bisha";//必杀
			public static const FAFANG :String = "fafang";//法防
			public static const WUFANG : String = "wufang";//物防
			public static const FALI : String = "fali";//法力
			public static const FAMIAN : String = "famian";//法术免伤
			public static const WUMIAN : String = "wumian";//物理免伤
			public static const GONGJI : String = "gongji";//攻击
			public static const KANGBAO : String = "kangbao";//抗暴
			public static const KANGBING : String = "kangbing";//抗冰冻
			public static const KANGYUN : String = "kangyun";//抗晕眩
			public static const SHENGMING : String = "shengming";//最大血量
			public static const MINGZHONG : String = "mingzhong";//命中
			
			public static const BAOJI_URL : String = "images/fight/baoji.png";
			public static const DODGE_URL : String = "images/fight/shanbi.png";
			public static const CRIT_URL : String = "images/fight/huixin.png";
			public static const PARRY_URL : String = "images/fight/gedang.png";
			public static const NUQI_URL : String = "images/fight/nuqi.png";
			public static const DIDANG_URL : String = "images/fight/didang.png";
			
			public static const SMALL_YELLOW_NUM_URL : String = "images/fight/syellow*.png";
			public static const SMALL_RED_NUM_URL : String = "images/fight/sred*.png";
			public static const LARGE_YELLOW_NUM_URL : String = "images/fight/lyellow*.png";
			public static const LARGE_RED_NUM_URL : String = "images/fight/lred*.png";
			public static const GREEN_NUM_URL : String = "images/fight/green*.png";
			public static const BLUE_NUM_URL : String = "images/fight/blue*.png";
			public static const ORANGE_NUM_URL : String = "images/fight/orange*.png";
			public static const RED_NUM_URL : String = "images/fight/red*.png";
			public static const YELLOW_NUM_URL : String = "images/fight/yellow*.png";
			public static const FIGHT_NUM_URL : String = "images/fight/fightChange*.png";
			public static const HP_URL : String = "images/fight/hp*.png";
			
			public static const GREEN_EXP_URL : String = "images/fight/greenEXP.png";
			public static const BISHA_URL :String = "images/fight/bisha.png";//必杀
			public static const FAFANG_URL :String = "images/fight/fafang.png";//法防
			public static const WUFANG_URL : String = "images/fight/wufang.png";//物防
			public static const FALI_URL : String = "images/fight/fali.png";//法力
			public static const FAMIAN_URL : String = "images/fight/famian.png";//法术免伤
			public static const WUMIAN_URL : String = "images/fight/wumian.png";//物理免伤
			public static const GONGJI_URL : String = "images/fight/gongji.png";//攻击
			public static const KANGBAO_URL : String = "images/fight/kangbao.png";//抗暴
			public static const KANGBING_URL : String = "images/fight/kangbing.png";//抗冰冻
			public static const KANGYUN_URL : String = "images/fight/kangyun.png";//抗晕眩
			public static const SHENGMING_URL : String = "images/fight/shengming.png";//最大血量
			public static const MINGZHONG_URL : String = "images/fight/mingzhong.png";//命中
			
			private var _states:Vector.<StateAlert>;
			private var _statesEx:Vector.<StateAlertEx>;//界面上的飘字
			
			private var _lastInView:Vector.<StateAlert>;
			private var _inView:Vector.<StateAlert>;
			private var _layer:Sprite;
			
			public static function getInstance() : StateAlertManager
			{
				if ( ! _instance )
				{
					_instance = new StateAlertManager();
				}
				return _instance;
			}
			
			public static function initStateImages( url : String , bitmapData : BitmapData ) : void
			{
				_stateImages[ url ] = bitmapData;
				loadNextImage();
			}
			
			public static function loadImage() : void
			{
				_nLoadTime = 3;
				
				_stateImages = new Dictionary();
				_unloadedImages = [];
				_unloadedImages.push( BAOJI_URL , DODGE_URL , CRIT_URL , PARRY_URL , NUQI_URL, DIDANG_URL);
				
				var arr : Array = [ ORANGE_NUM_URL , RED_NUM_URL , YELLOW_NUM_URL,SMALL_YELLOW_NUM_URL,SMALL_RED_NUM_URL,LARGE_YELLOW_NUM_URL,LARGE_RED_NUM_URL , GREEN_NUM_URL , BLUE_NUM_URL , GREEN_EXP_URL, BISHA_URL, FAFANG_URL, WUFANG_URL, FALI_URL, FAMIAN_URL, WUMIAN_URL, GONGJI_URL, KANGBAO_URL, KANGBING_URL, KANGYUN_URL, SHENGMING_URL, MINGZHONG_URL,FIGHT_NUM_URL,HP_URL];
				for each ( var url : String in arr )
				{
					_unloadedImages.push( url.replace( "*" , "add" ) );
					_unloadedImages.push( url.replace( "*" , "minus" ) );
					
					for ( var i : int = 0 ; i < 10 ; i ++ )
					{
						_unloadedImages.push( url.replace( "*" , i ) );
					}
				}
				loadNextImage();
			}
			
			private static function loadNextImage() : void
			{
				if ( _unloadedImages.length <= 0 && _nLoadTime > 0 && _errorImages )
				{
					_unloadedImages = _errorImages;
					_errorImages = null;
				}
				if ( _unloadedImages && _unloadedImages.length > 0 )
				{
					var shift:String = _unloadedImages.shift();
					var imageItem:StateAlertImageItem = new StateAlertImageItem();
					imageItem.init(ResourcePathConstants.RES_SERVER_PATH + shift);
				}
			}
			
			public static function loadImageError( url : String ) : void
			{
				trace(url);
				_errorImages = _errorImages || [];
				_errorImages.push( url );
				_nLoadTime--;
				loadNextImage();
			}
			
			public function initLayer(layer:Sprite):void
			{
				_layer = layer;
			}
			
			public function update(timeDiff:int):void
			{
				if (_states)
				{
					_inView = _states.concat();
					clearAndAddSortedEffects();
					enterframe();
				}
			}
			
			private function clearAndAddSortedEffects():void
			{
				var newEffectLength:int = _inView.length;
				var oldEffectLength:int = _lastInView.length;
				
				var i:int;
				for (i = 0; i < newEffectLength; ++i)
				{
					var child:StateAlert = _inView[i];
					if (!_layer.contains(child))
					{
						_layer.addChildAt(child, i);
						++oldEffectLength;
					}
					else if (_layer.getChildIndex(child) != i)
					{
						_layer.setChildIndex(child, i);
					}
				}
				while (i < oldEffectLength)
				{
					if (_layer.getChildAt(i))
					{
						_layer.removeChildAt(i);
					}
					--oldEffectLength;
				}
				_lastInView = _inView;
			}
			
			private function enterframe() : void
			{
				var totleTime:Number;
				var times:int;
				if ( _states && _states.length > 0 )
				{
					for each ( var state : StateAlert in _states )
					{
						if ( state.over )
						{
							state.destroy();
							_states.splice( _states.indexOf( state ) , 1 );
						}
						else
						{
							totleTime = new Date().time;
							times = 0;
							if(state.lastUserTime != 0)
							{
								times = Math.ceil((totleTime - state.lastUserTime) / 33);
							}
							else
							{
								times = 1;
							}
							state.lastUserTime = totleTime;
							while(times > 0)
							{
								state.enterframe();
								times--;
							}
						}
					}
				}
				
				if(_statesEx && _statesEx.length > 0)
				{
					for each(var s : StateAlertEx in _statesEx)
					{
						if(s.over)
						{
							s.destroy();
							_statesEx.splice(_statesEx.indexOf(s),1);
						}
						else
						{
							totleTime = new Date().time;
							times = 0;
							if(s.lastUserTime != 0)
							{
								times = Math.ceil((totleTime - s.lastUserTime) / 33);
							}
							else
							{
								times = 1;
							}
							s.lastUserTime = totleTime;
							while(times > 0)
							{
								s.enterframe();
								times--;
							}
						}
					}
				}
			}
			
			public function showOrdinaryState( name : String , unit:ILivingUnit , startX : Number , startY : Number ) : void
			{
				var bitmapData : BitmapData;
				if ( name == VOILENT)
				{
					bitmapData = getStateImage( BAOJI_URL );
				}
				else if ( name == DODGE )
				{
					bitmapData = getStateImage( DODGE_URL );
				}
				else if ( name == CRIT )
				{
					bitmapData = getStateImage( CRIT_URL );
				}
				else if ( name == PARRY )
				{
					bitmapData = getStateImage( PARRY_URL );
				}
				else if ( name == DIDANG)
				{
					bitmapData = getStateImage( DIDANG_URL );
				}
										
				if ( bitmapData )
				{
					_states = _states || new Vector.<StateAlert>();
					var state : StateAlert = new StateAlert();
					state.init( [ bitmapData ], 0 , unit , startX , startY , 36 , 3 , 24 , 0.6 , 0.5 );
					_states.push( state );
				}
			}
			
			public function showNum( color : String , num : int , showSign : Boolean , postImage : String , unit:ILivingUnit, startX : Number , startY : Number ,voilent : Boolean = false) : void
			{
				var arr : Array = getNumArray( color , num , showSign,voilent );
				var lackExpImage:Boolean = false;
				var expImage:BitmapData;
				if ( postImage == GREEN_EXP )
				{
					expImage = getStateImage( GREEN_EXP_URL );
					if (!expImage)
					{
						lackExpImage = true;
					}
				}
				if (arr && !lackExpImage)
				{
					if (expImage)
					{
						arr.unshift(expImage);
//						arr.push(expImage);
					}
					_states = _states || new Vector.<StateAlert>();
					var state : StateAlert = new StateAlert();
					if(voilent)
					{
						state.init( arr, getOverlapPixel(color) , unit , startX , startY , 48 , 6 , 24 , 1.2 , 0.5 );
					}
					else if(postImage == GREEN_EXP)
					{
						state.init( arr, getOverlapPixel(color) , unit , startX , startY , 48 , 3 , 24 , 1 , 0.5 );
					}
					else
					{
						if(unit is IMonster)
						{
							state.stateAlertType = StateAlertType.MONSTER;
						}
						state.init( arr, getOverlapPixel(color) , unit , startX , startY , 36 , 3 , 24 , 0.6 , 0.5 );
					}
					_states.push( state );
				}
			}
			
			//破防
			public function showCrit(unit:ILivingUnit , startX : Number , startY : Number ) : void
			{
				var bitmapData : BitmapData = getStateImage( CRIT_URL );
				if ( bitmapData )
				{
					_states = _states || new Vector.<StateAlert>();
					var state : StateAlert = new StateAlert();
					state.init( [ bitmapData ], 0, unit , startX , startY , 36 , 3 , 24 , 1.0 , 0.5 );
					_states.push( state );
				}
			}
			
			//招架
			public function showParry(unit:ILivingUnit, startX : Number , startY : Number ) : void
			{
				var bitmapData : BitmapData = getStateImage( PARRY_URL );
				if ( bitmapData )
				{
					_states = _states || new Vector.<StateAlert>();
					var state : StateAlert = new StateAlert();
					state.init( [ bitmapData ], 0, unit , startX , startY , 36 , 3 , 24 , 1 ,0.5 );
					_states.push( state );
				}
			}
			
			//暴击单独处理
			public function showVoilent(unit:ILivingUnit, startX : Number , startY : Number ) : void
			{
				var bitmapData : BitmapData = getStateImage( BAOJI_URL );
				if ( bitmapData )
				{
					_states = _states || new Vector.<StateAlert>();
					var state : StateAlert = new StateAlert();
					state.init( [ bitmapData ], 0, unit , startX , startY , 36 , 3 , 24 ,1.2 , 0.5 );
					_states.push( state );
				}
			}
			
			public function showAttrChange( color : String , num : int , unit:ILivingUnit, startX : Number , startY : Number ,type : int = 0):void
			{
				var arr : Array = getNumArray( color , num , true);
				var lackImage:Boolean = false;
				var attrImage:BitmapData;
				switch(type)
				{
					/*case AttribType.ATTR_MAXHP:
						attrImage = getStateImage(SHENGMING_URL);
						break;
					case AttribType.ATTR_ATTACK:
						attrImage = getStateImage(GONGJI_URL);
						break;
					case AttribType.ATTR_MAXMP:
						attrImage = getStateImage(FALI_URL);
						break;
					case AttribType.ATTR_MDEF:
						attrImage = getStateImage(FAFANG_URL);
						break;
					case AttribType.ATTR_PDEF:
						attrImage = getStateImage(WUFANG_URL);
						break;
					case AttribType.ATTR_PREBK:
						attrImage = getStateImage(KANGYUN_URL);
						break;
					case AttribType.ATTR_PREFROST:
						attrImage = getStateImage(KANGBING_URL);
						break;
					case AttribType.ATTR_PREVP:
						attrImage = getStateImage(KANGBAO_URL);
						break;					
					case AttribType.ATTR_HTIP:
						attrImage = getStateImage(MINGZHONG_URL);
						break;
					case AttribType.ATTR_VPP:
						attrImage = getStateImage(BISHA_URL);
						break;
					case AttribType.ATTR_MREDUCE:
						attrImage = getStateImage(FAMIAN_URL);
						break;	
					case AttribType.ATTR_PREDUCE:
						attrImage = getStateImage(WUMIAN_URL);
						break;	*/
					default:
						break;	
				}
				
				if (!attrImage)
				{
					lackImage = true;
				}
				
				if (arr && !lackImage)
				{
					if (attrImage)
					{
						arr.unshift(attrImage);
					}
					_states = _states || new Vector.<StateAlert>();
					var state : StateAlert = new StateAlert();
					state.init( arr, getOverlapPixel(color) , unit , startX , startY , 48 , 3 , 24 , 0.6 , 0.5 );
					_states.push( state );
				}
			}
			
			private static function number2Image( pre : String , after : String , num : int , showSign : Boolean = true , lastsign : String = "" ) : Array
			{
				var tempNum:int=Math.abs(num);
				var tempNumString : String = tempNum.toString();
				var temp : Array = tempNumString.split( "" );
				if(showSign)
				{
					if(num>0)
					{
						temp.unshift(pre+"add"+after);
					}
					else
					{
						temp.unshift(pre+"minus"+after);
					}
				}
				if(lastsign.length>0)
				{
					temp.push(lastsign);
				}
				return temp;
			}
			
			private function getStateImage( url : String ) : BitmapData
			{
				_stateImages = _stateImages || new Dictionary();
				return _stateImages[ ResourcePathConstants.RES_SERVER_PATH + url ] as BitmapData;
			}
			
			private function getNumArray( color : String , num : int , withSign : Boolean ,voilent : Boolean = false) : Array
			{
				var colorUrl : String;
				if ( color == SMALL_YELLOW )
				{
					colorUrl = SMALL_YELLOW_NUM_URL;
				}
				else if ( color == SMALL_RED )
				{
					colorUrl = SMALL_RED_NUM_URL;
				}
				else if ( color == LARGE_YELLOW )
				{
					colorUrl = LARGE_YELLOW_NUM_URL;
				}
				else if ( color == LARGE_RED )
				{
					colorUrl = LARGE_RED_NUM_URL;
				}
				else if ( color == GREEN )
				{
					colorUrl = GREEN_NUM_URL;
				}
				else if ( color == BLUE )
				{
					colorUrl = BLUE_NUM_URL;
				}
				else if(color == ORANGE)
				{
					colorUrl = ORANGE_NUM_URL;
				}
				else if(color == RED)
				{
					colorUrl = RED_NUM_URL;
				}
				else if(color == YELLOW)
				{
					colorUrl = YELLOW_NUM_URL;
				}
				else if(color == FIGHTNUM)
				{
					colorUrl = FIGHT_NUM_URL;
				}
				else if(color == HP)
				{
					colorUrl = HP_URL;
				}
				if ( colorUrl && colorUrl != "" )
				{
					var resultArray : Array = [];
					var bitmapData : BitmapData;
					var available : Boolean = true;
					if (voilent)
					{
						bitmapData = getStateImage(BAOJI_URL);
						if(bitmapData)
						{
							resultArray.push( bitmapData );
						}
						else
						{
							available = false;
						}
						withSign = true;
					}
					if ( withSign )
					{
						if ( num > 0 )
						{
							bitmapData = getStateImage( colorUrl.replace( "*" , "add" ) );
							if ( bitmapData )
							{
								resultArray.push( bitmapData );
							}
							else
								available = false;
						}
						else if ( num < 0 )
						{
							bitmapData = getStateImage( colorUrl.replace( "*" , "minus" ) );
							if ( bitmapData )
							{
								resultArray.push( bitmapData );
							}
							else
								available = false;
						}
					}
					var numString : String = int( Math.abs( num ) ).toString();
					var digiArray : Array = numString.split( "" );
					while ( digiArray.length > 0 )
					{
						bitmapData = getStateImage( colorUrl.replace( "*" , digiArray.shift() ) );
						if ( bitmapData )
						{
							resultArray.push( bitmapData );
						}
						else
							available = false;
					}
					if ( available )
					{
						return resultArray;
					}
					return null;
				}
				return null;
			}
			
			private function getOverlapPixel(type:String):int
			{
				switch (type)
				{
					case SMALL_YELLOW:
					case SMALL_RED:
						return 3;
					case GREEN:
					case BLUE:
					case LARGE_YELLOW:
					case LARGE_RED:
					case HP:
					case RED:
						return 3;
					case ORANGE:
					case YELLOW:
						return 10;
					case FIGHTNUM:
						return 1;
				}
				return 0;
			}
			
			public function clear():void
			{
				for each ( var state : StateAlert in _states )
				{
					state.destroy();
					if(state.parent)
					{
						state.parent.removeChild(state);
					}
				}
				for each(state in _inView)
				{
					state.destroy();
					if(state.parent)
					{
						state.parent.removeChild(state);
					}
				}
				for each(state in _lastInView)
				{
					state.destroy();
					if(state.parent)
					{
						state.parent.removeChild(state);
					}
				}
				_states = null;
				if(_inView!=null)
				{
					_inView.length=0;
				}else
				{
					_inView = new Vector.<StateAlert>();
				}
				if(_lastInView!=null)
				{
					_lastInView.length=0;
				}else
				{
					_lastInView = new Vector.<StateAlert>();
				}
			}
			
			public function showUiAlert(ui:DisplayObjectContainer, color : String , num : int , showSign : Boolean , postImage : String , startX : Number , startY : Number ,voilent : Boolean = false) : UiStateAlert
			{
				var arr : Array = getNumArray( color , num , showSign,voilent );
				var lackExpImage:Boolean = false;
				var expImage:BitmapData;
				if ( postImage == GREEN_EXP )
				{
					expImage = getStateImage( GREEN_EXP_URL );
					if (!expImage)
					{
						lackExpImage = true;
					}
				}
				if (arr && !lackExpImage)
				{
					if (expImage)
					{
						arr.unshift(expImage);
					}
					var state : UiStateAlert = new UiStateAlert();
					if(voilent)
					{
						state.init( arr, getOverlapPixel(color) , startX , startY , 48 , 6 , 24 , 1.2 , 0.5 );
					}
					else
					{
						state.init( arr, getOverlapPixel(color) , startX , startY , 36 , 3 , 24 , 0.6 , 0.5 );
					}
					
					if(ui)
					{
						ui.addChild(state);
					}
					
					return state;
				}
				return null;
			}
			
			public function getImageData(color : String , num : int , showSign : Boolean):Bitmap
			{
				var arr : Array = getNumArray( color , num , showSign,false );
				var bitmapData : BitmapData = genBitmapData(arr,getOverlapPixel(color));
				if(bitmapData)
				{
					return new Bitmap(bitmapData);
				}
				return null;
			}
			
			private function genBitmapData(bitmapDatas : Array, overlapPixel:int) : BitmapData
			{
				var bitmapData : BitmapData;
				var tempBitmapData : BitmapData
				if (bitmapDatas &&  bitmapDatas.length > 1 )
				{
					var bitmapWidth : int = overlapPixel * 2;
					var bitmapHeight : int = 0;
					var bd : BitmapData;
					for each ( bd in bitmapDatas )
					{
						bitmapWidth += bd.width - overlapPixel;
						bitmapHeight = Math.max( bitmapHeight , bd.height );
					}
					tempBitmapData = new BitmapData( bitmapWidth , bitmapHeight , true , 0x00000000 );
					var xPos : int = overlapPixel;
					var point : Point = new Point();
					while ( bitmapDatas.length > 0 )
					{
						bd = bitmapDatas.shift();
						point.x = xPos - overlapPixel;
						tempBitmapData.copyPixels( bd , bd.rect , point ,null,null,true);
						xPos += bd.width - overlapPixel;
					}
					bitmapData = tempBitmapData;
				}
				else if (bitmapDatas && bitmapDatas.length == 1 )
				{
					bitmapData = bitmapDatas[ 0 ];
				}
				return bitmapData;
			}
		}
}