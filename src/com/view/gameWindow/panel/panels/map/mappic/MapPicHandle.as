package com.view.gameWindow.panel.panels.map.mappic
{
    import com.core.getDictElement;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.MapCfgData;
    import com.model.configData.cfgdata.MapMonsterCfgData;
    import com.model.configData.cfgdata.MapRegionCfgData;
    import com.model.configData.cfgdata.MapTeleportCfgData;
    import com.model.configData.cfgdata.MonsterCfgData;
    import com.model.configData.cfgdata.NpcCfgData;
    import com.model.consts.FontFamily;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.view.gameWindow.panel.panels.map.MapItemSidebar;
    import com.view.gameWindow.panel.panels.map.McMapPanel;
    import com.view.gameWindow.panel.panels.onhook.AutoSystem;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.scene.entity.EntityLayerManager;
    import com.view.gameWindow.scene.entity.constants.EntityTypes;
    import com.view.gameWindow.scene.entity.entityItem.FirstPlayer;
    import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
    import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
    import com.view.gameWindow.scene.entity.entityItem.interf.IMonster;
    import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
    import com.view.gameWindow.scene.map.SceneMapManager;
    import com.view.gameWindow.scene.map.utils.MapTileUtils;
    import com.view.gameWindow.tips.toolTip.TextTip;
    import com.view.gameWindow.tips.toolTip.ToolTipLayMediator;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.selectRole.SelectRoleDataManager;
    
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.filters.GlowFilter;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.Dictionary;
    
    import flashx.textLayout.formats.TextAlign;

    /**
	 * 地图图片处理类
	 * @author Administrator
	 */	
	public class MapPicHandle
	{
        private const miniMapTW:int = 530, miniMapTH:int = 380;
		private var _scaleX:Number,_scaleY:Number,_brinkW:int,_brinkH:int;
		private var _mapBmpLoader:MapBmpLoader;
		private var _layer:MovieClip;

		private var _teleporterSigns:Vector.<MapSign>,_npcSigns:Vector.<MapSign>,_mstSigns:Dictionary,_playerSigns:Dictionary;
		private var _mapMstSigns:Vector.<MapSign>;
		private var _firstPlayerSign:MapSign;
		private var _mapId:int;
		
		private var _bounds:Rectangle;
		private var _road:RoadView;
		
		public var mapSidebar:MapItemSidebar;
		
		public function MapPicHandle(layer:MovieClip)
		{
			_layer = layer;
		}
		/**初始化*/
		public function init():void
		{
			var mapId:int = SceneMapManager.getInstance().mapId;
			_mapId = mapId;
			var mapCfgData:MapCfgData = ConfigDataManager.instance.mapCfgData(mapId);
			if(!_mapBmpLoader)
				_mapBmpLoader = new MapBmpLoader(_layer);
			_mapBmpLoader.loadPic(mapCfgData.url);//加载图片
			_scaleX = mapCfgData.miniW/mapCfgData.width;
			_scaleY = mapCfgData.miniH/mapCfgData.height;
			_brinkW = (miniMapTW - mapCfgData.miniW)/2;
			_brinkH = (miniMapTH - mapCfgData.miniH)/2;
			
			_bounds = new Rectangle(_brinkW,_brinkH,mapCfgData.miniW,mapCfgData.miniH);
			addSigns();
			promptInfo();
		}
		
		private function checkBounds(dis:DisplayObject,parent:DisplayObject,ctner:DisplayObject,bounds:Rectangle):void
		{
			var pos:Point = parent.localToGlobal(new Point(dis.x,dis.y));
			pos = ctner.globalToLocal(pos);
			
			if(pos.x<bounds.x)
			{
				dis.x += bounds.x - pos.x;
			}
			else if(pos.x+dis.width > bounds.right)
			{
				dis.x += bounds.right - dis.width - pos.x;
			}
			
			if(pos.y < bounds.y)
			{
				dis.y += bounds.y - pos.y;
			}
			else if(pos.y + dis.height > bounds.bottom)
			{
				dis.y += bounds.bottom - dis.height - pos.y;
			}
			
		}

		/**添加标志点*/
		private function addSigns():void
		{
			clearSign();
			var mapId:int = SceneMapManager.getInstance().mapId;
			var areas:Array = addTeleporter(mapId);
			var npcs:Array = addNpc(mapId);
			addMsts();
			var msts:Array = getMstsInMap(mapId);
			msts.sortOn("level",Array.NUMERIC);
			
			var sMapMst:Array = [];
			var sMst:Array = [];
			getMapMstsInMap(mapId,sMst,sMapMst);
			
			addMapPathSigns();
			addMapMonsterSigns(sMapMst,sMst);//不是显示实时的怪物，相当于地图上的boss标识
			addPlayers();
			addFirstPlayer();
			
			if(mapSidebar)
			{
				var map:MapCfgData = ConfigDataManager.instance.mapCfgData(mapId);
				mapSidebar.mapId = map.id;
				mapSidebar.needShowFly = map.is_treasure == 0;
				mapSidebar.setContent(npcs.length>0,areas.length>0,msts.length>0);
				mapSidebar.setNpcData(npcs);
				mapSidebar.setMonsterData(msts);
				mapSidebar.setAreaData(areas);
				mapSidebar.updatePos();
				mapSidebar.clearPathHandler = removePathSigns;
			}
		}
		
		private function addMapMonsterSigns(mapMstList:Array,mstList:Array):void
		{
			if(!_mapMstSigns)
			{
				_mapMstSigns = new Vector.<MapSign>();
			}
			
			var re:Array = [];
			
			var mapSign:MapSign;
			var mst:MonsterCfgData;
			var mapMst:MapMonsterCfgData;
			var scalePt:Point;
			for(var index:int = 0;index < mapMstList.length; ++index )
			{
				mst = mstList[index];
				mapMst = mapMstList[index];
				
				mapSign = new MapSign();
				mapSign.initView(MapSignTypes.RED);
				mapSign.monsterData=mst;
				scalePt = scalePoint(mapMst.x,mapMst.y);
				mapSign.x = scalePt.x;
				mapSign.y = scalePt.y;
				_layer.addChild(mapSign);
				_mapMstSigns.push(mapSign);
				
				//顶部提示文本
				var title:TextField = new TextField();
				title.defaultTextFormat = new TextFormat(FontFamily.FONT_NAME,12,0xffffff,null,null,null,null,null,TextAlign.CENTER);
				title.htmlText = HtmlUtils.createHtmlStr(0xfc0000, mst.name + "(LV " + mst.level+")");
				title.width = title.textWidth+5;
				title.height = title.textHeight+5;
				title.mouseEnabled = false;
				title.y = -title.height;
				title.x = int((mapSign.width - title.width)/2);
				title.filters = [new GlowFilter(0xf,1,2,2,10)];
				mapSign.addChild(title);
				checkBounds(title,mapSign,_layer,_bounds);
			}
		}
		
		private function addMapPathSigns():void
		{
			if(!_road)
			{
				_road = new RoadView();
			}
			
			_road.ratioX = _scaleX;
			_road.ratioY = _scaleY;
			_road.anchorX = _brinkW;
			_road.anchorY = _brinkH;
			
			_layer.addChild(_road);
		}
		
		private function addTeleporter(mapId:int):Array
		{
			var mapTeleporterCfgDatas:Dictionary,teleporterConfig:MapTeleportCfgData,mapSign:MapSign,scalePt:Point;
			if(!_teleporterSigns)
			{
				_teleporterSigns = new Vector.<MapSign>();
			}
			mapTeleporterCfgDatas = ConfigDataManager.instance.mapTeleporterCfgDatas(mapId);
			
			var re:Array = [];
			for each(teleporterConfig in mapTeleporterCfgDatas)
			{
				mapSign = new MapSign();
				mapSign.initView(MapSignTypes.TELEPORTER);
                mapSign.mapTeleportData=teleporterConfig;
				scalePt = scalePoint(teleporterConfig.x_from,teleporterConfig.y_from);
				mapSign.x = scalePt.x;
				mapSign.y = scalePt.y;
				_layer.addChild(mapSign);
				_teleporterSigns.push(mapSign);
				
				//顶部提示文本
				var title:TextField = new TextField();
				title.defaultTextFormat = new TextFormat(FontFamily.FONT_NAME,12,0xffffff,null,null,null,null,null,TextAlign.CENTER);
				var mapRegion:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(teleporterConfig.region_to);
				var mapCfg:MapCfgData = ConfigDataManager.instance.mapCfgData(mapRegion.map_id);
                title.htmlText = HtmlUtils.createHtmlStr(0x00FFE5, mapRegion.name + "\n" + mapCfg.level_desc);
				title.width = title.textWidth+5;
				title.height = title.textHeight+5;
				title.mouseEnabled = false;
				title.y = -title.height;
				title.x = int((mapSign.width - title.width)/2);
				title.filters = [new GlowFilter(0xf,1,2,2,10)];
				mapSign.addChild(title);
				checkBounds(title,mapSign,_layer,_bounds);
				
				var rg:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(teleporterConfig.region_to);
				var area:Object = {};
				area.name = rg.name;
				area.id = teleporterConfig.id;
				re.push(area);
			}
			
			return re;
		}
		
		private function addNpc(mapId:int):Array
		{
			var npcCfgDatas:Dictionary,npcCfgData:NpcCfgData,mapSign:MapSign,scalePt:Point;
			npcCfgDatas = ConfigDataManager.instance.npcCfgDatas(mapId);
			if(!_npcSigns)
			{
				_npcSigns = new Vector.<MapSign>();
			}
			var re:Array = [];
			for each(npcCfgData in npcCfgDatas)
			{
				mapSign = new MapSign();
				mapSign.initView(MapSignTypes.GREEN);
                mapSign.npcData=npcCfgData;
				scalePt = scalePoint(npcCfgData.x,npcCfgData.y);
				mapSign.x = scalePt.x;
				mapSign.y = scalePt.y;

                //地图NPC名称
                if (npcCfgData.isShowName != 0)
                {
                    var npcName:TextField = new TextField();
                    if (npcCfgData.isShowName == 1)
                    {
                        npcName.htmlText = HtmlUtils.createHtmlStr(0x009900, npcCfgData.name);
                    } else if (npcCfgData.isShowName == 2)
                    {
                        npcName.htmlText = HtmlUtils.createHtmlStr(0x009900, npcCfgData.title);
                    }
                    npcName.width = npcName.textWidth + 5;
                    npcName.height = npcName.textHeight + 5;
                    npcName.mouseEnabled = false;
                    npcName.y = -npcName.height;
                    npcName.x = int((mapSign.width - npcName.width) / 2);
                    npcName.filters = [new GlowFilter(0xf, 1, 2, 2, 10)];
                    mapSign.addChild(npcName);
                }

				_layer.addChild(mapSign);
				_npcSigns.push(mapSign);
				re.push(npcCfgData);
			}
			
			return re;
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
                    mapSign.monsterData=mst.mstCfgData;
					scalePt = scalePoint(mst.tileX,mst.tileY);
					mapSign.x = scalePt.x;
					mapSign.y = scalePt.y;
					_layer.addChild(mapSign);
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
		
		private function getMstsInMap(mapId:int):Array
		{
			var msts:Dictionary = ConfigDataManager.instance.mapMstCfgDataByMap(mapId);
			
			var re:Array = [];
			for each(var mapMst:MapMonsterCfgData in msts)
			{
				var dict:Dictionary = ConfigDataManager.instance.monsterCfgDatas(mapMst.monster_group_id);
				
				var mst:MonsterCfgData = getDictElement(dict);
				
				if(mst && mst.show_in_map)
				{
					re.push(mst);
				}
			}
			
			return re;
		}
		
		private function getMapMstsInMap(mapId:int,outMst:Array,outMapMst:Array):void
		{
			var msts:Dictionary = ConfigDataManager.instance.mapMstCfgDataByMap(mapId);
			
			for each(var mapMst:MapMonsterCfgData in msts)
			{
				if(mapMst && mapMst.isShowInMap)
				{
					var dict:Dictionary = ConfigDataManager.instance.monsterCfgDatas(mapMst.monster_group_id);
					
					var mst:MonsterCfgData = getDictElement(dict);
					outMapMst.push(mapMst);
					outMst.push(mst);
				}
			}
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
				if(player.isShow)
				{
					if(SelectRoleDataManager.getInstance().isFirstPlayer(player))
					{
						continue;
					}
					
					mapSign = new MapSign();
					mapSign.initView(MapSignTypes.BLUE);
					scalePt = scalePoint(player.tileX,player.tileY);
					mapSign.x = scalePt.x;
					mapSign.y = scalePt.y;
					_layer.addChild(mapSign);
					_playerSigns[player.entityId] = mapSign;
				}
			}
		}
		
		private function addFirstPlayer():void
		{
			_firstPlayerSign = new MapSign;
			_firstPlayerSign.initView(MapSignTypes.ARROW);
			_layer.addChild(_firstPlayerSign);
			refreshFirstPlayerSign();
		}
		/**地图面板点击移动*/
		public function clickMove():void
		{
			if(!_bounds)
			{
				return;
			}
			if(!_bounds.contains(_layer.mouseX,_layer.mouseY))
			{
				return;
			}
			AutoSystem.instance.stopAuto();
			AutoJobManager.getInstance().reset(true);
			var pixelX:Number = (_layer.mouseX-_brinkW)/_scaleX;
			var pixelY:Number = (_layer.mouseY-_brinkH)/_scaleY;
			
			var pixelToTile:Point = MapTileUtils.pixelToTile(pixelX,pixelY);
			AutoJobManager.getInstance().setAutoFindPathPos(new Point(pixelToTile.x,pixelToTile.y), _mapId, 0);
			removePathSigns();
		}
		/**即时刷新鼠标相对地图的位置坐标*/
		public function refreshMousePoint():void
		{
			var pixelX:int = int((_layer.mouseX-_brinkW)/_scaleX);
			var pixelY:int = int((_layer.mouseY-_brinkH)/_scaleY);
			var str:String = "x:"+String(pixelX) + "    "+"y:"+String(pixelY);
			(ToolTipLayMediator.getInstance().getToolTip(ToolTipConst.TEXT_TIP) as TextTip).setData(str);
		}
		/**移除所有路径点标志*/
		public function removePathSigns():void
		{
			if(_road)
			{
				_road.clear();
			}
		}
		
		private function getPath():Array
		{
			var inMapPath:Array = AutoJobManager.getInstance().inMapPath;
			if(inMapPath && inMapPath.length)
			{
				var num:int = inMapPath.length;
				
				var path:Array = inMapPath.concat();
				var player:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
				
				var first:Point = new Point(player.tileX,player.tileY);
				
				path.unshift(first);
				
				scalePath(path);
				
				return path;
			}
			
			return null;
		}
		
		private function refreshPathSigns():void
		{
			_road.update();
		}
		
		private function refreshPath():void
		{
			var path:Array = getPath();
			_road.initPath(path);
			
			if(!_road.isRunning())
			{
				_road.addPointAtOnce();
			}
		}
		
		private function scalePath(path:Array):void
		{
			for(var i:int = 0; i < path.length; ++i)
			{
				var p:Point = path[i];
				p = MapTileUtils.tileToPixel(p.x,p.y);
				path[i] = p;
			}
		}
		/**缩放实际坐标到当前地图面板比例坐标*/
		private function scalePoint(x:int,y:int):Point
		{
			var tileToPixel:Point = MapTileUtils.tileToPixel(x,y);
			tileToPixel.x = tileToPixel.x*_scaleX;
			tileToPixel.y = tileToPixel.y*_scaleY;
			tileToPixel = tileToPixel.add(new Point(_brinkW,_brinkH));
			return tileToPixel;
		}
		/**添加怪物位置标志*/
		public function addMstSign(id:int):void
		{
			var mst:IMonster,mapSign:MapSign,scalePt:Point;
			mapSign = _mstSigns[id];
			if(!mapSign)
			{
				mst = EntityLayerManager.getInstance().getEntity(EntityTypes.ET_MONSTER,id) as IMonster;
				mapSign = new MapSign();
				mapSign.initView(MapSignTypes.RED);
				scalePt = scalePoint(mst.tileX,mst.tileY);
				mapSign.x = scalePt.x;
				mapSign.y = scalePt.y;
				var getChildIndex:int = _layer.getChildIndex(_firstPlayerSign);
				_layer.addChildAt(mapSign,getChildIndex);
				_mstSigns[id] = mapSign;
			}
		}
		/**刷新怪物位置标志*/
		public function refreshMstSign(id:int):void
		{
			var mst:IMonster,mapSign:MapSign,scalePt:Point;
			mst = EntityLayerManager.getInstance().getEntity(EntityTypes.ET_MONSTER,id) as IMonster;
			mapSign = _mstSigns[mst.entityId];
			if(mapSign)
			{
                mapSign.monsterData=mst.mstCfgData;
				scalePt = scalePoint(mst.tileX,mst.tileY);
				mapSign.x = scalePt.x;
				mapSign.y = scalePt.y;
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
		/**添加玩家位置标志*/
		public function addPlayerSign(id:int):void
		{
			var player:IPlayer,mapSign:MapSign,scalePt:Point;
			mapSign = _playerSigns[id];
			if(!mapSign)
			{
				player = EntityLayerManager.getInstance().getEntity(EntityTypes.ET_PLAYER,id) as IPlayer;
				scalePt = scalePoint(player.tileX,player.tileY);
				if(SelectRoleDataManager.getInstance().isFirstPlayer(player))
				{
					if(_firstPlayerSign)
					{
						_firstPlayerSign.x = scalePt.x;
						_firstPlayerSign.y = scalePt.y;
					}
					return;
				}
				
				mapSign = new MapSign();
				mapSign.initView(MapSignTypes.BLUE);
				mapSign.x = scalePt.x;
				mapSign.y = scalePt.y;
				var getChildIndex:int = _layer.getChildIndex(_firstPlayerSign);
				_layer.addChildAt(mapSign,getChildIndex);
				_playerSigns[id] = mapSign;
			}
		}
		/**刷新玩家位置标志*/
		public function refreshPlayerSign(id:int):void
		{
			var player:IPlayer,mapSign:MapSign,scalePt:Point;
			player = EntityLayerManager.getInstance().getEntity(EntityTypes.ET_PLAYER,id) as IPlayer;
			mapSign = _playerSigns[player.entityId];
			if(mapSign)
			{
				scalePt = scalePoint(player.tileX,player.tileY);
				mapSign.x = scalePt.x;
				mapSign.y = scalePt.y;
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
		/**刷新玩家位置标志*/
		public function refreshFirstPlayerSign():void
		{
			var firstPlayer:FirstPlayer = EntityLayerManager.getInstance().firstPlayer as FirstPlayer;
			if(_firstPlayerSign.drct != firstPlayer.direction)
				_firstPlayerSign.refreshDrct(firstPlayer.direction);
			var x:int = firstPlayer.pixelX*_scaleX + _brinkW;
			var y:int = firstPlayer.pixelY*_scaleY + _brinkH;
			if(_firstPlayerSign.x != x)
			{
				_firstPlayerSign.x = x;
			}
			if(_firstPlayerSign.y != y)
			{
				_firstPlayerSign.y = y;
			}
			baseInfo(firstPlayer.pixelX,firstPlayer.pixelY);
			
			refreshPath();
			refreshPathSigns();
		}
		/**前往*/
		public function goTo(mc:MovieClip):void
		{
			AutoSystem.instance.stopAutoEx();
			var pixelX:Number = Number((mc.tileX as TextField).text);
			var pixelY:Number = Number((mc.tileY as TextField).text);
			AutoJobManager.getInstance().runToTile(pixelX, pixelY, 0);
			removePathSigns();
		}
		
		private function promptInfo():void
		{
			var mapId:int = SceneMapManager.getInstance().mapId;
			var mapCfgData:MapCfgData = ConfigDataManager.instance.mapCfgData(mapId);
			var mapLevel:int = mapCfgData.level;
			var roleLevel:int = RoleDataManager.instance.lv;
			var tf:TextField = (_layer.parent as McMapPanel).txtLvInfo as TextField;
			if(roleLevel<(mapLevel-5))
			{
				tf.text=StringConst.MAP_PANEL_0007;
			}
			else if(roleLevel>(mapLevel+4) && roleLevel<(mapLevel-4))
			{
				tf.text=StringConst.MAP_PANEL_0008;
			}
			else if(roleLevel>(mapLevel+5))
			{
				tf.text=StringConst.MAP_PANEL_0009;
			}
			else
			{
				tf.text="";
			}
		}

		private function baseInfo(pixelX:int,pixelY:int):void
		{
			var mapId:int = SceneMapManager.getInstance().mapId;
			var mapCfgData:MapCfgData = ConfigDataManager.instance.mapCfgData(mapId);
			var mapName:String = mapCfgData.name;
			var tf:TextField = (_layer.parent as McMapPanel).txtMapInfo as TextField;
			
			var pos:Point = MapTileUtils.pixelToTile(pixelX,pixelY);
			tf.text=mapName+"( "+String(pos.x)+","+String(pos.y)+" )";
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
			
			while(_mapMstSigns && _mapMstSigns.length)
			{
				mapSign = _mapMstSigns.pop();
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
			
			removePathSigns();
			if(_firstPlayerSign)
			{
				_firstPlayerSign.destroy();
				_firstPlayerSign = null;
			}
		}
		
		public function destroy():void
		{
			clearSign();
			while(_layer && _layer.numChildren)
			{
				_layer.removeChildAt(0);
			}
			_layer = null;
			if(_mapBmpLoader)
				_mapBmpLoader.destroy();
			_mapBmpLoader = null;
		}
	}
}