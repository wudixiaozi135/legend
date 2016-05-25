package com.view.gameWindow.scene.map.path
{
	import flash.geom.Point;

	public class PathFinder
	{
		public static const ISRECTANGLE:Boolean = true;
		
		//横向移动一格的路径评分
		private const COST_HORIZONTAL : int = 10;
		//竖向移动一格的路径评分
		private const COST_VERTICAL : int = 10;
		//斜向移动一格的路径评分
		private const COST_DIAGONAL : int = 14;//14;
		
		private var xMapStart:int;		//地图起始网格坐标
		private var yMapStart:int;		//地图起始网格坐标
		private var wMap:int;			//地图列数（每行格点数）
		private var hMap:int;			//地图行数（每列格点数）
		private var mapNodes:Vector.<Vector.<Node>>;			//与地图行列相同的数组，存放节点
		private var mapTiles:Vector.<Vector.<int>>;
		public static var mid:int;
//		private var openList:Array=new Array();		//开放列表
		private var openList:Vector.<Node>=new Vector.<Node>();		//开放列表
		private var closeList:Vector.<Node>=new Vector.<Node>();		//关闭列表
		private var lastFindPathUsedNode:Array=new Array();
		private var isFinded:Boolean = false;		//能否找到路径，true-已找到
		
		public var runTimeInMs:int = 0; 	//寻路时间
		
		private var _aroundNodes:Vector.<Node>=new Vector.<Node>();
		
		//（改）加上D 长距离时: 值越大距离的影响越大，寻的点越少（但遇到障碍拐点会多），大地图可以加快寻路
		private var D:int = 1;
		public static const G_PLUS:int = 4;
		
		public function PathFinder()
		{
		}
		
		public function resetMapInfo(nRow:int, nCol:int, mapTileInfos:Vector.<Vector.<int>>):void
		{
			mapNodes = new Vector.<Vector.<Node>>();
			for (var y:int = 0; y < nRow; ++y)
			{
				var row:Vector.<Node> = new Vector.<Node>();
				for (var x:int = 0; x < nCol; ++x) 
				{
					row.push(new Node(x, y));
				}
				mapNodes.push(row);
			}
			mapTiles = mapTileInfos;
		}
		
		public function find(startPoint:Point, endPoint:Point, topLeftX:int, topLeftY:int, bottomRightX:int, bottomRightY:int, tileDist:int):Array
		{
			D = Math.ceil((Math.abs(endPoint.x - startPoint.x)+Math.abs(endPoint.y - startPoint.y))/200);
			this.isFinded = false;
			
			this.xMapStart = topLeftX;
			this.yMapStart = topLeftY;
			this.wMap = bottomRightX;
			this.hMap = bottomRightY;

			for each(var tmpnode:Node in lastFindPathUsedNode)
			{
				tmpnode.resetPathInfo();
			}
			lastFindPathUsedNode.length=0;
			var currentNode:Node = mapNodes[startPoint.y][startPoint.x];
			var endNode:Node = mapNodes[endPoint.y][endPoint.x];

			openList.push(currentNode);
			currentNode.nodeIndex=0;
			while(openList.length>0)
			{
				//取出并删除开放列表第一个元素
				currentNode = openList[0];
				this.delAndSort();
				//加入到关闭列表
				currentNode.isInOpen = false;
				currentNode.isInClose = true;
				lastFindPathUsedNode.push(currentNode);
				this.closeList.push(currentNode);	
				
				//当前节点==目标节点
				if(Math.abs(currentNode.x - endPoint.x) <= tileDist && Math.abs(currentNode.y - endPoint.y) <= tileDist)
				{
					this.isFinded = true;	//能达到终点，找到路径
					break;
				}
				
				//取相邻八个方向的节点，去除不可通过和以在关闭列表中的节点
				var aroundNodes:Vector.<Node>;
				if(ISRECTANGLE)
				{
					aroundNodes= this.getRectangleAroundsNode(currentNode.x, currentNode.y);
				}
				else
				{
					aroundNodes= this.getDiamondAroundsNode(currentNode.x, currentNode.y);
				}
				
				
				for each (var node:Node in aroundNodes) //检测相邻的八个方向的节点
				{
					//计算 G， H 值   
					var g:int = this.getGValue(currentNode, node)+getGValuePlus(currentNode,node);
					var h:int = this.getHValue(currentNode, endNode, node);
					
					if (node.isInOpen)	//如果节点已在播放列表中
					{
						//如果该节点新的G值比原来的G值小,修改F,G值，设置该节点的父节点为当前节点
						if (g < node.g)
						{
							node.g = g;
							node.h = h;
							node.f = g + h;
							node.parentNode = currentNode;
							lastFindPathUsedNode.push(node);
							this.findAndSort(node);
						}
					}
					else //如果节点不在开放列表中
					{
						//插入开放列表中，并按照估价值排序
						node.g = g;
						node.h = h;
						node.f = g + h;
						node.parentNode = currentNode;
						lastFindPathUsedNode.push(node);
						this.insertAndSort(node);
					}
				}
			}
			

			if (this.isFinded)	//找到路径
			{
				var path:Array = this.createPath(startPoint.x, startPoint.y);
				this.destroyLists();
				
				///// 运行时间 ////////////
//				this.runTimeInMs = getTimer() - startTime;
				//////////////////////////
//				trace("found in "+runTimeInMs);
				return betterPath(path);
			} 
			else 
			{	//没有找到路径
				this.destroyLists();
				
				///// 运行时间 ////////////
//				this.runTimeInMs = getTimer() - startTime;
				//////////////////////////
//				trace("not fiound in"+runTimeInMs);
				return null;
			}
		}
		
		/**
		 * 生成路径数组
		 */
		private function createPath(xStart:int, yStart:int):Array
		{
			var path:Array = new Array();
			
			var node:Node = this.closeList.pop();
			
			while (node.x != xStart || node.y != yStart)
			{
				path.unshift(new Point(node.x, node.y));
				node = node.parentNode;
			}
			path.unshift(new Point(node.x, node.y));
			
			return path;
		}
		
		/**
		 * 删除根node后排序
		 */
		private function delAndSort():void
		{
			var listLength:int = this.openList.length;
			if (listLength <= 1)
			{
				this.openList.shift();
			}
			else
			{
				this.openList[0]=this.openList[listLength-1];
				this.openList[0].nodeIndex=0;
				this.openList.pop();
				listLength--;
				var nodeIndex:int=0;
				var tmpNode:Node;
				while((nodeIndex<<1)+1<listLength)
				{
					var smallNodeIndex:int=nodeIndex;
					if(this.openList[nodeIndex].f>this.openList[(nodeIndex<<1)+1].f)
					{
						smallNodeIndex=(nodeIndex<<1)+1;
					}
					if((nodeIndex<<1)+2<listLength)
					{
						if(this.openList[smallNodeIndex].f>this.openList[(nodeIndex<<1)+2].f)
						{
							smallNodeIndex=(nodeIndex<<1)+2;
						}
					}
					if(smallNodeIndex==nodeIndex)
					{
						break;
					}
					else
					{
						tmpNode=this.openList[smallNodeIndex];
						this.openList[smallNodeIndex]=this.openList[nodeIndex];
						this.openList[nodeIndex]=tmpNode;
						this.openList[nodeIndex].nodeIndex=nodeIndex;
						this.openList[smallNodeIndex].nodeIndex=smallNodeIndex;
						nodeIndex=smallNodeIndex;
					}
				}
				
			}
		}
		
		/**
		 * 将node放到正确顺序
		 */
		private function findAndSort(node:Node):void
		{
			var listLength:int = this.openList.length;
			
			if (listLength < 1) return;
//			for (var i:int=0; i<listLength; i++)
//			{
//				if (node.f <= this.openList[i].f)
//				{
//					this.openList.splice(i, 0, node);
//				}
//				if (node.x == this.openList[i].x && node.y == this.openList[i].y)
//				{
					//this.openList.splice(i, 1);
					this.openList[node.nodeIndex]=node;
					var tmpNode:Node;
					var nodeIndex:int=node.nodeIndex;
					while(nodeIndex>0)
					{
						if(this.openList[nodeIndex].f<=this.openList[((nodeIndex-1)>>1)].f)
						{
							tmpNode=this.openList[nodeIndex];
							this.openList[nodeIndex]=this.openList[((nodeIndex-1)>>1)];
							this.openList[((nodeIndex-1)>>1)]=tmpNode;
							this.openList[nodeIndex].nodeIndex=nodeIndex;
							nodeIndex=((nodeIndex-1)>>1);
							this.openList[nodeIndex].nodeIndex=nodeIndex;
						}
						else
						{
							break;
						}
					}
//					break;
//				}
//			}
		}
		
		/**
		 * 按由小到大顺序将节点插入到列表
		 */
		private function insertAndSort(node:Node):void
		{
			node.isInOpen = true;
			lastFindPathUsedNode.push(node);
			var listLength:int = this.openList.length;
			
			if (listLength == 0)
			{
				this.openList.push(node);
				node.nodeIndex=listLength;
			}
			else
			{
//				for (var i:int=0; i<listLength; i++)
//				{
//					if (node.f <= this.openList[i].f)
//					{
//						this.openList.splice(i, 0, node);
//						return;
//					}
//				}
				this.openList.push(node);
				node.nodeIndex=listLength;
				var tmpNode:Node;
				var nodeIndex:int=listLength;
				while(nodeIndex>0)
				{
					if(this.openList[nodeIndex].f<=this.openList[((nodeIndex-1)>>1)].f)
					{
						tmpNode=this.openList[nodeIndex];
						this.openList[nodeIndex]=this.openList[((nodeIndex-1)>>1)];
						this.openList[((nodeIndex-1)>>1)]=tmpNode;
						this.openList[nodeIndex].nodeIndex=nodeIndex;
						nodeIndex=((nodeIndex-1)>>1);
						this.openList[nodeIndex].nodeIndex=nodeIndex;
					}
					else
					{
						break;
					}
				}
			}
		}
		
		/**
		 * 计算G值
		 */
		private function getGValue(currentNode:Node, node:Node):int
		{
			var g:int = 0;
			if(ISRECTANGLE)
			{
				if (currentNode.y == node.y)			// 横向  左右
				{
					g = currentNode.g + this.COST_HORIZONTAL;
				}
				else if (currentNode.x == node.x)// 竖向  上下
				{
					g = currentNode.g + this.COST_VERTICAL;
				}
				else						// 斜向  左上 左下 右上 右下
				{
					g = currentNode.g + this.COST_DIAGONAL;
				}
				
				g+=node.additionValue;
			}
			else
			{
				if (currentNode.y == node.y)			// 横向  左右
				{
					g = currentNode.g + this.COST_HORIZONTAL;
				}
				else if (currentNode.y+2 == node.y || currentNode.y-2 == node.y)// 竖向  上下
				{
					g = currentNode.g + this.COST_VERTICAL;
				}
				else						// 斜向  左上 左下 右上 右下
				{
					g = currentNode.g + this.COST_DIAGONAL;
				}
				g+=node.additionValue;
			}
			return g;
		}
		
		//（改）拐弯加权重
		private function getGValuePlus(startNode:Node,endNode:Node):int
		{
			if(!startNode.isInSameDirection(endNode))
			{
				return G_PLUS;
			}
			
			return 0;
		}
		
		/**
		 * 计算H值
		 */
		private function getHValue(currentNode:Node, endNode:Node, node:Node):int
		{
			var dx:int;
			var dy:int;
			
			var dxNodeTo0:int;
			var dxEndNodeTo0:int;
			
			if(ISRECTANGLE)
			{
				var distanceX:int=Math.abs(endNode.x - node.x);
				var distanceY:int=Math.abs(endNode.y - node.y);
				
				//1 原 保留
//				dx = distanceX * this.COST_HORIZONTAL;
//				dy = distanceY * this.COST_VERTICAL;
//				if(distanceX!=distanceY)
//				{
//					dy+=this.COST_VERTICAL*Math.abs(distanceX-distanceY);//取消-this.COST_VERTICAL;//最后一格做一次转折
//				}
				
				//2
//				return D*COST_VERTICAL*Math.max(distanceX,distanceY);
				//3
				return D*COST_DIAGONAL*Math.min(distanceX,distanceY)+D*COST_VERTICAL*Math.abs(distanceX-distanceY);
				//4
//				return D*COST_VERTICAL*(distanceX+distanceY);
				
//				if(distanceX<=2 && distanceY<=2)
//				{
//					dx = distanceX * this.COST_HORIZONTAL;
//					dy = distanceY * this.COST_VERTICAL;
//				}
//				else
//				{
//					if(distanceX!=distanceY)
//					{
//						dx=(this.COST_HORIZONTAL+this.COST_DIAGONAL)*Math.sqrt((endNode.x - node.x)*(endNode.x - node.x)+(endNode.y - node.y)*(endNode.y - node.y));
//						dy=0;
//					}
//					else
//					{
//						dx = distanceX * this.COST_HORIZONTAL;
//						dy = distanceY * this.COST_VERTICAL;
//					}
//				}
			}
			else
			{
				//节点到0，0点的x轴距离
				dxNodeTo0 = node.x * this.COST_HORIZONTAL + (node.y&1) * this.COST_HORIZONTAL/2;
				//终止节点到0，0点的x轴距离
				dxEndNodeTo0 = endNode.x * this.COST_HORIZONTAL + (endNode.y&1) * this.COST_HORIZONTAL/2; 
				dx = Math.abs(dxEndNodeTo0 - dxNodeTo0);
				dy = Math.abs(endNode.y - node.y) * this.COST_VERTICAL;
			}
			return dx + dy;
		}
		
		/**
		 * 得到菱形周围八方向节点
		 */
		private function getDiamondAroundsNode(x:int, y:int):Vector.<Node>
		{
			_aroundNodes.length = 0;
			
			var checkX:int;
			var checkY:int;

			//左
			checkX = x-1
			checkY = y;
			if (isWalkable(checkX, checkY) && !mapNodes[checkY][checkX].isInClose)
			{
				_aroundNodes.push(mapNodes[checkY][checkX]);
			}
			//右
			checkX = x+1;
			checkY = y;
			if (isWalkable(checkX, checkY) && !mapNodes[checkY][checkX].isInClose)
			{
				_aroundNodes.push(mapNodes[checkY][checkX]);
			}
			//上
			checkX = x;
			checkY = y-2;
			if (isWalkable(checkX, checkY) && !mapNodes[checkY][checkX].isInClose)
			{
				_aroundNodes.push(mapNodes[checkY][checkX]);
			}
			//下
			checkX = x;
			checkY = y+2;
			if (isWalkable(checkX, checkY) && !mapNodes[checkY][checkX].isInClose)
			{
				_aroundNodes.push(mapNodes[checkY][checkX]);
			}
			//左上
			checkX = x-1+(y&1);
			checkY = y-1;
			if (isWalkable(checkX, checkY) && !mapNodes[checkY][checkX].isInClose)
			{
				_aroundNodes.push(mapNodes[checkY][checkX]);
			}
			//左下
			checkX = x-1+(y&1);
			checkY = y+1;
			if (isWalkable(checkX, checkY) && !mapNodes[checkY][checkX].isInClose)
			{
				_aroundNodes.push(mapNodes[checkY][checkX]);
			}
			//右上
			checkX = x+(y&1);
			checkY = y-1;
			if (isWalkable(checkX, checkY) && !mapNodes[checkY][checkX].isInClose)
			{
				_aroundNodes.push(mapNodes[checkY][checkX]);
			}
			//右下
			checkX = x+(y&1);
			checkY = y+1;
			if (isWalkable(checkX, checkY) && !mapNodes[checkY][checkX].isInClose)
			{
				_aroundNodes.push(mapNodes[checkY][checkX]);
			}
			
			return _aroundNodes;
		}
		
		/**
		 * 得到矩形周围八方向节点
		 */
		private function getRectangleAroundsNode(x:int, y:int):Vector.<Node>
		{
			_aroundNodes.length = 0;
			
			var checkX:int;
			var checkY:int;
			
			//左
			checkX = x-1
			checkY = y;
			if (isWalkable(checkX, checkY) && !mapNodes[checkY][checkX].isInClose)
			{
				_aroundNodes.push(mapNodes[checkY][checkX]);
			}
			//右
			checkX = x+1;
			checkY = y;
			if (isWalkable(checkX, checkY) && !mapNodes[checkY][checkX].isInClose)
			{
				_aroundNodes.push(mapNodes[checkY][checkX]);
			}
			//上
			checkX = x;
			checkY = y-1;
			if (isWalkable(checkX, checkY) && !mapNodes[checkY][checkX].isInClose)
			{
				_aroundNodes.push(mapNodes[checkY][checkX]);
			}
			//下
			checkX = x;
			checkY = y+1;
			if (isWalkable(checkX, checkY) && !mapNodes[checkY][checkX].isInClose)
			{
				_aroundNodes.push(mapNodes[checkY][checkX]);
			}
			//左上
			checkX = x-1;
			checkY = y-1;
			if (isWalkable(checkX, checkY) && !mapNodes[checkY][checkX].isInClose)
			{
				_aroundNodes.push(mapNodes[checkY][checkX]);
			}
			//左下
			checkX = x-1;
			checkY = y+1;
			if (isWalkable(checkX, checkY) && !mapNodes[checkY][checkX].isInClose)
			{
				_aroundNodes.push(mapNodes[checkY][checkX]);
			}
			//右上
			checkX = x+1;
			checkY = y-1;
			if (isWalkable(checkX, checkY) && !mapNodes[checkY][checkX].isInClose)
			{
				_aroundNodes.push(mapNodes[checkY][checkX]);
			}
			//右下
			checkX = x+1;
			checkY = y+1;
			if (isWalkable(checkX, checkY) && !mapNodes[checkY][checkX].isInClose)
			{
				_aroundNodes.push(mapNodes[checkY][checkX]);
			}
			
			return _aroundNodes;
		}
		/**获取目标点周围可行走的点*/
		public function getNearWalkableTile(startTile:Point, targetTile:Point/*x:int, y:int*/):Point
		{
			/*var i:int,l:int = AutoJobManager.MAX_TILE_DIST2,j:int;
			for (i=-l;i<=l;i++) 
			{
				for (j=-l;j<=l;j++) 
				{
					var isWalkable:Boolean = isWalkable(x+i,y+j);
					if(isWalkable)
					{
						return new Point(x+i,y+j);
					}
				}
			}
			return null;*/
			var k:Number = (targetTile.x - startTile.x)/(startTile.y - targetTile.y);
			var isMore:Boolean = startTile.y - targetTile.y - k*(startTile.x - targetTile.x) > 0;
			function rightSide(x:int,y:int):Boolean
			{
				return isMore ? y - targetTile.y - k*(x - targetTile.x) > 0 : y - targetTile.y - k*(x - targetTile.x) < 0;
			}
			//
			var allUsedNodes:Vector.<Node> = new Vector.<Node>();
			var nowNodes:Vector.<Node> = new Vector.<Node>();
			var nowNode:Node = mapNodes[targetTile.y][targetTile.x];
			nowNodes.push(nowNode);
			allUsedNodes.push(nowNode);
			var nextNodes:Vector.<Node> = new Vector.<Node>();
			var nodeGet:Node;
			var nowTimes:int;
			while(nowTimes++ <= 4)
			{
				if(nextNodes.length)
				{
					nowNodes = nextNodes;
					allUsedNodes = allUsedNodes.concat(nextNodes);
					nextNodes = new Vector.<Node>();
				}
				nodeGet = checkOneRound(nowNodes,nextNodes,rightSide);
				if(nodeGet)
				{
					resetAllUsedNodes(allUsedNodes);
					return new Point(nodeGet.x,nodeGet.y);
				}
			}
			resetAllUsedNodes(allUsedNodes);
			return null;
		}
		
		private function resetAllUsedNodes(nodes:Vector.<Node>):void
		{
			var node:Node;
			for each(node in nodes)
			{
				node.isCheck = 0;
			}
		}
		/**检测一轮node点*/
		private function checkOneRound(nowNodes:Vector.<Node>,nextNodes:Vector.<Node>,rightSide:Function = null):Node
		{
			var node:Node;
			for each(node in nowNodes)
			{
				node.isCheck = 2;
				if(isWalkable(node.x,node.y))
				{
					if(rightSide == null || (rightSide != null && rightSide(node.x,node.y)))
					{
						return node;
					}
				}
			}
			for each(node in nowNodes)
			{
				getRectangleAroundsNodeUnChecked(nextNodes,node.x,node.y);
			}
			return null;
		}
		/**
		 * 得到矩形周围八方向节点，获取附近的点时调用
		 */
		private function getRectangleAroundsNodeUnChecked(aroundNodes:Vector.<Node>, x:int, y:int):void
		{
			var checkX:int;
			var checkY:int;
			
			//左
			checkX = x-1
			checkY = y;
			if (!mapNodes[checkY][checkX].isCheck)
			{
				mapNodes[checkY][checkX].isCheck = 1;
				aroundNodes.push(mapNodes[checkY][checkX]);
			}
			//右
			checkX = x+1;
			checkY = y;
			if (!mapNodes[checkY][checkX].isCheck)
			{
				mapNodes[checkY][checkX].isCheck = 1;
				aroundNodes.push(mapNodes[checkY][checkX]);
			}
			//上
			checkX = x;
			checkY = y-1;
			if (!mapNodes[checkY][checkX].isCheck)
			{
				mapNodes[checkY][checkX].isCheck = 1;
				aroundNodes.push(mapNodes[checkY][checkX]);
			}
			//下
			checkX = x;
			checkY = y+1;
			if (!mapNodes[checkY][checkX].isCheck)
			{
				mapNodes[checkY][checkX].isCheck = 1;
				aroundNodes.push(mapNodes[checkY][checkX]);
			}
			//左上
			checkX = x-1;
			checkY = y-1;
			if (!mapNodes[checkY][checkX].isCheck)
			{
				mapNodes[checkY][checkX].isCheck = 1;
				aroundNodes.push(mapNodes[checkY][checkX]);
			}
			//左下
			checkX = x-1;
			checkY = y+1;
			if (!mapNodes[checkY][checkX].isCheck)
			{
				mapNodes[checkY][checkX].isCheck = 1;
				aroundNodes.push(mapNodes[checkY][checkX]);
			}
			//右上
			checkX = x+1;
			checkY = y-1;
			if (!mapNodes[checkY][checkX].isCheck)
			{
				mapNodes[checkY][checkX].isCheck = 1;
				aroundNodes.push(mapNodes[checkY][checkX]);
			}
			//右下
			checkX = x+1;
			checkY = y+1;
			if (!mapNodes[checkY][checkX].isCheck)
			{
				mapNodes[checkY][checkX].isCheck = 1;
				aroundNodes.push(mapNodes[checkY][checkX]);
			}
		}
		/**
		 * 检查点在地图上是否可通过
		 */
		private function isWalkable(x:int, y:int):Boolean
		{
			// 是否是有效的地图上点（数组边界检查）
			if (x < this.xMapStart || x >= this.wMap) 
			{
				return false;
			}
			if (y < this.yMapStart || y >= this.hMap)
			{
				return false;
			}

			// 是否是walkable
			return checkTileWalkable(x, y);
		}
		
		public function checkTileWalkable(x:int, y:int):Boolean
		{
			var mask:int = mapTiles[y][x];
			return mask != MapPathManager.TM_BLOCK && mask != MapPathManager.TM_MINE;
		}
		
		/**
		 * 销毁数组
		 */
		private function destroyLists():void
		{
			this.closeList.length=0;
			this.openList.length=0;
			
		}
		
		private function betterPath(oldPath:Array):Array
		{
			if (oldPath == null || oldPath.length == 0)
			{
				return null;
			}
			var tempPath:Array=new Array();
			var direction:int=-1;
			var oldX:int=oldPath[0].x;
			var oldY:int=oldPath[0].y;
			var directionChanged:Boolean=false;
			for(var i:int=1;i<oldPath.length;i++)
			{
				var currentX:int=oldPath[i].x;
				var currentY:int=oldPath[i].y;
				var oldDirection:int=direction;
				if(currentY==oldY && currentX-oldX==1)
				{
					direction=6;
				}
				else if(currentY==oldY && currentX-oldX==-1)
				{
					direction=2;
				}
				else if(currentX==oldX && currentY-oldY==1)
				{
					direction=0;
				}
				else if(currentX==oldX && currentY-oldY==-1)
				{
					direction=4;
				}
				else if(currentX-oldX==-1 && currentY-oldY==-1)
				{
					direction=3;
				}
				else if(currentX-oldX==-1 && currentY-oldY==1)
				{
					direction=1;
				}
				else if(currentX-oldX==1 && currentY-oldY==-1)
				{
					direction=5;
				}
				else if(currentX-oldX==1 && currentY-oldY==1)
				{
					direction=7;
				}
				else
				{
					trace("path error:" +oldX+","+oldY+" : "+currentX+","+currentY);
				}
				oldX=currentX;
				oldY=currentY;
				
				if(direction!=oldDirection)
				{
					directionChanged=true;
				}
				if(directionChanged)
				{
					tempPath.push(oldPath[i-1]);
					directionChanged=false;
				}
				if(i==oldPath.length-1)
				{
					tempPath.push(oldPath[i]);
					directionChanged=false;
					continue;
				}
			}
			if(oldPath.length==1)
			{
				tempPath.push(oldPath[0]);
			}
			return tempPath;
		}
	}
}


class Node
{
	public var x:int;
	public var y:int;
	public var isInOpen:Boolean;
	public var isInClose:Boolean;
	public var g:int;
	public var h:int;
	public var f:int;
	public var parentNode:Node;
	public var nodeIndex:int;//在openList中的index
	public var additionValue:int;//地形附加值
	/**在获取最近点时调用<br>0:默认，1：准备调用，2：已经调用*/
	public var isCheck:int;
	
	public function Node(x:int, y:int)
	{
		this.x = x;
		this.y = y;
		this.isInOpen = false;
		this.isInClose = false;
		this.g = 0;
		this.h = 0;
		this.f = 0;
		this.parentNode = null;
		this.nodeIndex=0;
	}
	public function resetPathInfo():void
	{
		isInOpen = false;
		isInClose = false;
		g = 0;
		h = 0;
		f = 0;
		parentNode = null;
		nodeIndex=0;
		isCheck = 0;
	}
	
	public function isInSameDirection(newNode:Node):Boolean
	{
		if(!parentNode)
		{
			return true;
		}
		
		var newX:int = newNode.x-x;
		var newY:int = newNode.y-y;
		
		var oldX:int = x - parentNode.x;
		var oldY:int = y - parentNode.y;
		
		if(newX/Math.abs(newX) == oldX/Math.abs(oldX) && newY/Math.abs(newY) == oldY/Math.abs(oldY))
		{
			return true;
		}
		
		return false;
	}
}
