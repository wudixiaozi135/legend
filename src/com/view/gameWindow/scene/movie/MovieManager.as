package com.view.gameWindow.scene.movie
{
	import com.core.toArray;
	import com.model.configData.ConfigDataManager;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.onhook.states.common.FightPlace;
	
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * @author wqhk
	 * 2014-12-3
	 */
	public class MovieManager
	{
		private static var _instance:MovieManager = null;
		
		public static function get instance():MovieManager
		{
			if(!_instance)
			{
				_instance = new MovieManager();
			}
			
			return _instance;
		}
		
		private var _ctl:IMovieControl;
		private var moveClips:Dictionary;
		private var timer:Dictionary;
		private var overDict:Dictionary;
		private var coverDict:Dictionary;
		private var cfgDict:Dictionary;
		
		public function isOver(mid:int):Boolean
		{
			if(overDict.hasOwnProperty(mid))
			{
				return overDict[mid];
			}
			
			return false;
		}
		
		public function findCfgDataList(mid:int):*
		{
			if(cfgDict[mid])
			{
				return cfgDict[mid];
			}
			
			var arr:Array = [];
			toArray(ConfigDataManager.instance.movieCfgDataDict(mid),arr);
			arr.sortOn("time_line",Array.NUMERIC);//time_line 最好不要相同
			cfgDict[mid] = arr;
			return arr;
		}
		
		public function MovieManager()
		{
			_ctl = new MovieControl();
			moveClips = new Dictionary();
			timer = new Dictionary();
			overDict = new Dictionary();
			cfgDict = new Dictionary();
			coverDict = new Dictionary();
		}
		
		public function startMovie(mid:int):void
		{
			moveClips[mid] = _ctl.createMovieQueue(mid,findCfgDataList(mid));
			
			playMovies(mid);
		}
		
		private function playMovies(mid:int):void
		{
			clearMovie(mid);
			
			if(!moveClips.hasOwnProperty(mid) || moveClips[mid].length < 1)
			{
				return;
			}
			
			playMovie(mid, moveClips[mid].shift());
			while(moveClips[mid].length > 0 && moveClips[mid][0].waitTime == 0)
			{
				playMovie(mid, moveClips[mid].shift());
			}
			
			if(moveClips[mid].length > 0)
			{
				timer[mid] = setTimeout(playMovies, moveClips[mid][0].waitTime * 100, mid);
			}
		}
		
		private function clearMovie(mid:int):void
		{
			if(timer[mid])
			{
				clearTimeout(timer[mid]);
				delete timer[mid];
			}
		}
		
		public function checkCover():Boolean
		{
			for each(var re:Boolean in coverDict)
			{
				if(re)
				{
					return true;
				}
			}
			
			return false;
		}
		
		private var _needReAuto:Boolean = false;
		
		private function playMovie(mid:int, movie:MovieInfo):void
		{
			switch(movie.type)
			{
				case 1:
					overDict[mid] = false;
					var isCover:Boolean = parseInt(movie.data) == 1;
					_ctl.movieBegin(mid,isCover);
					if(isCover)
					{
						coverDict[mid] = true;
						
						if(AutoSystem.instance.isAuto())
						{
							_needReAuto = true;
							AutoSystem.instance.stopAuto();
						}
					}
					break;
				case 2:
					overDict[mid] = true;
					_ctl.movieEnd(mid);
					if(coverDict[mid])
					{
						coverDict[mid] = false;
						delete coverDict[mid];
						
						if(!checkCover())
						{
							if(_needReAuto)
							{
								AutoSystem.instance.startAutoFight(FightPlace.FIGHT_PLACE_AUTO,false);
								_needReAuto = false;
							}
						}
					}
					break;
				case 3:
					var newMId:int = parseInt(movie.data);
					moveClips[newMId] = _ctl.createMovieQueue(newMId,findCfgDataList(newMId));
					playMovies(newMId);
					break;
				case 11: 
					_ctl.addMonster(movie.data.split(":"));
					break;
				case 12:
					_ctl.moveMonster(movie.data.split(":"));
					break;
				case 13:
					_ctl.monsterAttack(movie.data.split(":"));
					break;
				case 14:
					_ctl.monsterDied(movie.data.split(":"));
					break;
				case 15:
					_ctl.monsterStand(movie.data.split(":"));
					break;	
				case 16:
					_ctl.spellSkill(movie.data.split(":"));
					break;
				case 17:
					_ctl.monsterFacing(movie.data.split(":"));
					break;
				case 18:
					_ctl.removeUnit(movie.data.split(":"));
					break;	
				case 19:
					_ctl.chat(movie.data.split(":"));
					break;	
				case 31:
					_ctl.moveFirstPlayer(movie.data.split(":"));
					break;
				case 32:
					_ctl.moveCamera(movie.data.split(":"));
					break;
				case 41:
					_ctl.showCover(movie.data.split(":"));
					break;
				case 42:
					_ctl.addSubtitle(movie.data.split(":"));
					break;
				case 43:
					_ctl.hideCover();
					break;
			}
		}
		
	}
}