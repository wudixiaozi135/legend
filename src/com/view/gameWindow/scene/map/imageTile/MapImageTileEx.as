package com.view.gameWindow.scene.map.imageTile
{
	public class MapImageTileEx
	{
		public var imageTile:MapImageTile;
		public var dist:Number;
		
		public static function compare(ex1:MapImageTileEx, ex2:MapImageTileEx):Number
		{
			return ex1.dist - ex2.dist;
		}
	}
}