package entities;

import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxMap;
import com.haxepunk.Entity;

class Level extends TmxEntity
{

  public static inline var PLAYER = 17;
  public static inline var PIT = 18;
  public static inline var NYMPH = 19;
  public static inline var STALKER = 20;
  public static inline var SEER = 21;

  public var entities:Array<Entity>;

  public function new(filename:String)
  {
      super(filename);
      entities = new Array<Entity>();
      loadGraphic("graphics/tiles.png", ["main"]);
      loadMask("collision_mask", "walls");
      map = TmxMap.loadFromFile(filename);
      for(entity in map.getObjectGroup("entities").objects)
      {
        /*trace(entity.gid);*/
        if(entity.gid == PLAYER)
        {
          entities.push(new Player(entity.x, entity.y));
          entities.push(new Shadow(entity.x, entity.y));
        }
        if(entity.gid == PIT)
        {
          entities.push(new Pit(entity.x, entity.y));
        }
        if(entity.gid == NYMPH)
        {
          entities.push(new Nymph(entity.x, entity.y));
        }
        if(entity.gid == STALKER)
        {
          entities.push(new Stalker(entity.x, entity.y));
        }
        if(entity.gid == SEER)
        {
          entities.push(new Seer(entity.x, entity.y));
        }
      }
  }

}
