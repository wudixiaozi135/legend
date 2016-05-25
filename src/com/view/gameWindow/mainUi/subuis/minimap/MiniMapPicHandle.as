package com.view.gameWindow.mainUi.subuis.minimap
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapCfgData;
	import com.model.configData.cfgdata.MapTeleportCfgData;
	import com.model.configData.cfgdata.MonsterCfgData;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.model.consts.MapRegionType;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.ModelEvents;
	import com.view.gameWindow.mainUi.subclass.McMapProperty;
	import com.view.gameWindow.panel.panels.map.MapDataManager;
	import com.view.gameWindow.panel.panels.map.mappic.MapSign;
	import com.view.gameWindow.panel.panels.map.mappic.MapSignTypes;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.FirstPlayer;
	import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.scene.entity.entityItem.interf.IMonster;
	import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
	import com.view.gameWindow.scene.map.SceneMapManager;
	import com.view.gameWindow.scene.map.utils.MapTileUtils;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.selectRole.SelectRoleDataManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	/**
	 * 小地图图片处理类
	 * @author Administrator
	 */	
	public class MiniMapPicHandle
	{
		private var _mc:McMapProperty;
		private var _miniMapBmpLoader:MiniMapBmpLoader;
		private const miniMapTW:int = 530,miniMapTH:int = 380
		private var _scaleX:Number,_scaleY:Number,_brinkW:int,_brinkH:int;
		private var _signsLayer:Sprite;
		private var _teleporterSigns:Vector.<MapSign>,_npcSigns:Vector.<MapSign>,_mstSigns:Dictionary,_playerSigns:Dictionary;
		private var _firstPlayerSign:MapSign;
		/**显示位图*/
		private var _viewBitMap:Bitmap;
		private var _blankBd:BitmapData;
		private var _miniW:Number;
		private var _miniH:Number;
		private var _lastRegionType:int = -1;
		private var _mapCfg:MapCfgData;
		private var _oldTileX:int;
		private var _oldTileY:int;
		
		public function MiniMapPicHandle(mc:McMapProperty)
		{
			_mc = mc;
			_mc.mcBmpLayer.mask = _mc.mcMask;//添加遮罩
			_blankBd = new BitmapData(_mc.mcMask.width,_mc.mcMask.height,true,0);
			_viewBitMap = new Bitmap(_blankBd.clone(),"auto",true);
			_mc.mcBmpLayer.addChild(_viewBitMap);
			_signsLayer = new Sprite();
			_mc.mcBmpLayer.addChild(_signsLayer);
			_miniMapBmpLoader = new MiniMapBmpLoader();
		}
		
		public function showMiniMap(mapId:int, xTile:int, yTile:int):void
		{
			MapDataManager.instance.initMap(mapId);
			var mapCenterPos:Point = MapTileUtils.tileToPixel(xTile, yTile);
			var mapCfgData:MapCfgData = ConfigDataManager.instance.mapCfgData(mapId);
			_miniMapBmpLoader.loadPic(mapCfgData.url,imgCompleteHandler);//加载图片
			_scaleX = mapCfgData.miniW/mapCfgData.width;
			_scaleY = mapCfgData.miniH/mapCfgData.height;
			_brinkW = (miniMapTW - mapCfgData.miniW)/2;
			_brinkH = (miniMapTH - mapCfgData.miniH)/2;
			_miniW = mapCfgData.miniW;
			_miniH = mapCfgData.miniH;
			_mapCfg = mapCfgData;
			_oldTileX = -1;
			_oldTileY = -1;
			addSigns();
			refreshMiniMapPos(xTile,yTile);
		}
		
		private function imgCompleteHandler():void
		{
			var tileX:int = _oldTileX;
			var tileY:int = _oldTileY;
			_oldTileX = -1;
			_oldTileY = -1;
			refreshMiniMapPos(tileX,tileY);
			
			if(_firstPlayerSign)
			{
				_firstPlayerSign.tileX = -1;
				_firstPlayerSign.tileY = -1;
				var f:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
				if(f)
				{
					setMapSignPos(_firstPlayerSign,f.tileX,f.tileY);
				}
			}
		}
		
		/**添加标志点*/
		private function addSigns():void
		{
			clearSign();
			var mapId:int = SceneMapManager.getInstance().mapId;
			addTeleporter(mapId);
			addNpc(mapId);
			addMsts();
			addFirstPlayer();//要在addPlayers前
			addPlayers();
		}
		
		private function addTeleporter(mapId:int):void
		{
			var mapTeleporterCfgDatas:Dictionary,teleporterConfig:MapTeleportCfgData,mapSign:MapSign,scalePt:Point;
			if(!_teleporterSigns)
				_teleporterSigns = new Vector.<MapSign>();
			mapTeleporterCfgDatas = ConfigDataManager.instance.mapTeleporterCfgDatas(mapId);
			for each(teleporterConfig in mapTeleporterCfgDatas)
			{
				mapSign = new MapSign();
				mapSign.initView(MapSignTypes.TELEPORTER);
				setMapSignPos(mapSign,teleporterConfig.x_from,teleporterConfig.y_from);
				_signsLayer.addChildAt(mapSign,0);
				_teleporterSigns.push(mapSign);
			}
		}
		
		private function addNpc(mapId:int):void
		{
			var npcCfgDatas:Dictionary,npcCfgData:NpcCfgData,mapSign:MapSign,scalePt:Point;
			npcCfgDatas = ConfigDataManager.instance.npcCfgDatas(mapId);
			if(!_npcSigns)
				_npcSigns = new Vector.<MapSign>();
			for each(npcCfgData in npcCfgDatas)
			{
				mapSign = new MapSign();
				mapSign.initView(MapSignTypes.GREEN);
				setMapSignPos(mapSign,npcCfgData.x,npcCfgData.y);
				_signsLayer.addChild(mapSign);
				_npcSigns.push(mapSign);
			}
		}
		
		private function addMsts():Array
		{
			var monsterDic:Dictionary,mst:IMonster,mapSign:MapSign,scalePt:Point;
			monsterDic = EntityLayerManager.getInstance().monsterDic;
			if(!_mstSigns)
			{
				_mstSigns = new Dictionary();
			}
			
			var re:Array = [];
			for each(mst in monsterDic)
			{
				if(mst.isShow)
				{
					mapSign = new MapSign();
					mapSign.initView(MapSignTypes.RED);
					setMapSignPos(mapSign,mst.tileX,mst.tileY);
					_signsLayer.addChild(mapSign);
					_mstSigns[mst.entityId] = mapSign;
				}
				
				var cfg:MonsterCfgData = ConfigDataManager.instance.monsterCfgData(mst.monsterId);
				if(cfg.show_in_map)
				{
					re.push(cfg);
				}
			}
			
			return re;
		}
		
		private function isFirstPlayer(player:IEntity):Boolean
		{
			return SelectRoleDataManager.getInstance().isFirstPlayer(player as IPlayer);
		}
		
		private function addPlayers():void
		{
			var playerDic:Dictionary,player:IPlayer,mapSign:MapSign,scalePt:Point;
			playerDic = EntityLayerManager.getInstance().playerDic;
			if(!_playerSigns)
			{
				_playerSigns = new Dictionary();
			}
			for each(player in playerDic)
			{
				if(isFirstPlayer(player))
				{
					setMapSignPos(_firstPlayerSign,player.tileX,player.tileY);
					continue;
				}
				if(player.isShow)
				{
					mapSign = new MapSign();
					mapSign.initView(MapSignTypes.BLUE);
					setMapSignPos(mapSign,player.tileX,player.tileY);
					_signsLayer.addChild(mapSign);
					_playerSigns[player.entityId] = mapSign;
				}
			}
		}
		/**添加玩家位置标志*/
		public function addPlayerSign(id:int):void
		{
			var player:IPlayer,mapSign:MapSign,scalePt:Point;
			mapSign = _playerSigns[id];
			if(!mapSign)
			{
				player = EntityLayerManager.getInstance().getEntity(EntityTypes.ET_PLAYER,id) as IPlayer;
				
				if(isFirstPlayer(player))
				{
					setMapSignPos(_firstPlayerSign,player.tileX,player.tileY);
					refreshFirstPlayerSign();
					return;
				}
				mapSign = new MapSign();
				mapSign.initView(MapSignTypes.BLUE);
				setMapSignPos(mapSign,player.tileX,player.tileY);
				_signsLayer.addChildAt(mapSign,0);
				_playerSigns[id] = mapSign;
			}
		}
		/**刷新玩家位置标志*/
		public function refreshPlayerSign(id:int):void
		{
			if (!_playerSigns)
			{
				return;
			}
			var player:IPlayer,mapSign:MapSign;
			player = EntityLayerManager.getInstance().getEntity(EntityTypes.ET_PLAYER,id) as IPlayer;
			if(!player)
			{
				return;
			}
			mapSign = _playerSigns[player.entityId];
			
			if(isFirstPlayer(player))
			{
				setMapSignPos(_firstPlayerSign,player.tileX,player.tileY);
				refreshFirstPlayerSign();
				return;
			}
			
			if(mapSign)
			{
				setMapSignPos(mapSign,player.tileX,player.tileY);
			}
		}
		/**删除玩家位置标志*/
		public function removePlayerSign(id:int):void
		{
			var mapSign:MapSign,scalePt:Point;
			mapSign = _playerSigns[id];
			if(mapSign)
			{
				delete _playerSigns[id];
				mapSign.destroy();
			}
		}
		
		private function addFirstPlayer():void
		{
			_firstPlayerSign = new MapSign;
			_firstPlayerSign.initView(MapSignTypes.ARROW);
			_signsLayer.addChild(_firstPlayerSign);
			refreshFirstPlayerSign();
		}
		/**缩放坐标到当前比例*/
		private function scalePoint(x:int,y:int):Point
		{
			var tileToPixel:Point = MapTileUtils.tileToPixel(x,y);
			tileToPixel.x = tileToPixel.x*_scaleX;
			tileToPixel.y = tileToPixel.y*_scaleY;
			tileToPixel = tileToPixel.add(new Point(_brinkW,_brinkH));
			return tileToPixel;
		}
		
		private function scalePointPixelX(x:int):Number
		{
			return x*_scaleX+_brinkW;
		}
		
		private function scalePointPixelY(y:int):Number
		{
			return y*_scaleY+_brinkH;
		}
		
		private function scaleTileX2PixelX(tileX:int):Number
		{
			return scalePointPixelX(MapTileUtils.tileXToPixelX(tileX))
		}
		
		private function scaleTileY2PixelY(tileY:int):Number
		{
			return scalePointPixelY(MapTileUtils.tileYToPixelY(tileY))
		}
		
		private function scalePointPixel(x:int,y:int):Point
		{
			var re:Point = new Point(x*_scaleX+_brinkW,y*_scaleY+_brinkH);
			return re;
		}
		/**刷新玩家位置标志*/
		private function refreshFirstPlayerSign():void
		{
			var firstPlayer:FirstPlayer = EntityLayerManager.getInstance().firstPlayer as FirstPlayer;
			if(firstPlayer && _firstPlayerSign.drct != firstPlayer.direction)
			{
				_firstPlayerSign.refreshDrct(firstPlayer.direction);
			}
			
			if(firstPlayer)
			{
				baseInfo(firstPlayer.tileX,firstPlayer.tileY);
			}
		}
		
		private var lastBaseMapName:String;
		private var lastBaseTileX:int;
		private var lastBaseTileY:int;
		private function baseInfo(tileX:int,tileY:int):void
		{
			var mapId:int = SceneMapManager.getInstance().mapId;
			var mapCfgData:MapCfgData = ConfigDataManager.instance.mapCfgData(mapId);
			var mapName:String = mapCfgData.name;
			
			if(lastBaseMapName != mapName || tileX != lastBaseTileX || tileY != lastBaseTileY)
			{
				var tf:TextField = _mc.txtMapInfo;
				var tip:String = mapName+"  X:"+tileX+" Y:"+tileY;
				if(tf.text != tip)
				{
					tf.text = tip;
				}
				
				lastBaseMapName = mapName;
				lastBaseTileX = tileX;
				lastBaseTileY = tileY;
			}
		}
		/**添加怪物位置标志*/
		public function addMstSign(id:int):MapSign
		{
			var mst:IMonster,mapSign:MapSign;
			mapSign = _mstSigns[id];
			if(!mapSign)
			{
				mst = EntityLayerManager.getInstance().getEntity(EntityTypes.ET_MONSTER,id) as IMonster;
				
				mapSign = new MapSign();
				mapSign.initView(MapSignTypes.RED);
				setMapSignPos(mapSign,mst.tileX,mst.tileY);
				_signsLayer.addChildAt(mapSign,0);
				_mstSigns[id] = mapSign;
			}
			return mapSign;
		}
		/**刷新怪物位置标志*/
		public function refreshMstSign(id:int):void
		{
			var mst:IMonster,mapSign:MapSign,scalePt:Point;
			mst = EntityLayerManager.getInstance().getEntity(EntityTypes.ET_MONSTER,id) as IMonster;
			
			if(mst)
			{
				mapSign = _mstSigns[mst.entityId];
				if(!mapSign)
				{
					mapSign = addMstSign(id);
				}
				else if(mapSign)
				{
					setMapSignPos(mapSign,mst.tileX,mst.tileY);
				}
			}
		}
		
		private function setMapSignPos(mapSign:MapSign,tileX:int,tileY:int):void
		{
			if(mapSign.tileX != tileX || mapSign.tileY != tileY)
			{
				mapSign.x = scaleTileX2PixelX(tileX);
				mapSign.y = scaleTileY2PixelY(tileY);
				mapSign.tileX = tileX;
				mapSign.tileY = tileY;
			}
		}
		/**删除怪物位置标志*/
		public function removeMstSign(id:int):void
		{
			var mapSign:MapSign,scalePt:Point;
			mapSign = _mstSigns[id];
			if(mapSign)
			{
				delete _mstSigns[id];
				mapSign.destroy();
			}
		}
		
		private function clearSign():void
		{
			var mapSign:MapSign;
			while(_teleporterSigns && _teleporterSigns.length)
			{
				mapSign = _teleporterSigns.pop();
				mapSign.destroy();
			}
			while(_npcSigns && _npcSigns.length)
			{
				mapSign = _npcSigns.pop();
				mapSign.destroy();
			}
			
			if(_mstSigns)
			{
				for each(mapSign in _mstSigns)
				{
					mapSign.destroy();
				}
			}
			if(_playerSigns)
			{
				for each(mapSign in _playerSigns)
				{
					mapSign.destroy();
				}
			}
			
			if(_firstPlayerSign)
			{
				_firstPlayerSign.destroy();
				_firstPlayerSign = null;
			}
		}
		
		public function updateProc(proc:int):void
		{
			if(proc == ModelEvents.UPDATE_REGION_TYPE)
			{
				if(MapDataManager.instance.regionType == MapRegionType.FIGHT)
				{
					_mc.areaFlag.gotoAndStop(2);
				}
				else
				{
					_mc.areaFlag.gotoAndStop(1);
				}
			}
			else if(proc == ModelEvents.UPDATE_REGION_TYPE_NOTICE)
			{
				if(MapDataManager.instance.regionType == MapRegionType.FIGHT)
				{
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,HtmlUtils.createHtmlStr(0xff0000,StringConst.TIP_MAP_REGION_DANGEROUS));
				}
				else
				{
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,HtmlUtils.createHtmlStr(0x00ff00,StringConst.TIP_MAP_REGION_SAFE));
				}
			}
		}
		
		public function refreshMiniMapPos(tileX:Number,tileY:Number):void
		{
			if(tileX == _oldTileX && tileY == _oldTileY)
			{
				return;
			}
			_oldTileX = tileX;
			_oldTileY = tileY;
			
			var bitmapData:BitmapData,miniCenterX:Number,miniCenterY:Number,newX:Number,newY:Number,i:int,l:int;
			bitmapData = _miniMapBmpLoader.bitmapData;
			if(bitmapData)
			{
				miniCenterX = MapTileUtils.tileXToPixelX(tileX)*_scaleX;
				miniCenterY = MapTileUtils.tileYToPixelY(tileY)*_scaleY;
				if(miniCenterX<70)
				{
					miniCenterX = 70;
				}
				
				if(miniCenterY<70)
				{
					miniCenterY = 70;
				}
				
				if(miniCenterX > _miniW - 70)
				{
					miniCenterX = _miniW - 70;
				}
				
				if(miniCenterY > _miniH - 70)
				{
					miniCenterY = _miniH - 70;
				}
				
				newX = -_brinkW-miniCenterX+70;
				newY = -_brinkH-miniCenterY+70;
				
				MapDataManager.instance.updateRegionRype(tileX,tileY);
				
				/*if(_signsLayer.x - newX > .1 || _signsLayer.x - newX < -.1 || _signsLayer.y - newY > .1 || _signsLayer.y - newY < -.1)
				{*/
					_signsLayer.x = newX;
					_signsLayer.y = newY;
					l = _signsLayer.numChildren;
					for(i=0;i<l;i++)
					{
						var obj:DisplayObject = _signsLayer.getChildAt(i);
						if(!obj.hitTestObject(_mc.mcMask))
							obj.visible = false;
						else
							obj.visible = true;
					}
					_viewBitMap.bitmapData.copyPixels(bitmapData,new Rectangle(-newX,-newY,_viewBitMap.bitmapData.width,_viewBitMap.bitmapData.height),new Point());
					refreshFirstPlayerSign();
				/*}*/
			}
			else
			{
				_viewBitMap.bitmapData.copyPixels(_blankBd,new Rectangle(-newX,-newY,_viewBitMap.bitmapData.width,_viewBitMap.bitmapData.height),new Point());
			}
		}
	}
}