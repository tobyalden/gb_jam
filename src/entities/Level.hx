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
  public static inline var HEART = 22;
  public static inline var ANGEL = 23;

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
        if(entity.gid == PLAYER)
        {
          entities.push(new Player(entity.x, entity.y - 16));
          entities.push(new Shadow(entity.x, entity.y - 16));
          entities.push(new HUD());
        }
        if(entity.gid == PIT)
        {
          entities.push(new Pit(entity.x, entity.y - 16));
        }
        if(entity.gid == NYMPH)
        {
          entities.push(new Nymph(entity.x, entity.y - 16));
        }
        if(entity.gid == STALKER)
        {
          entities.push(new Stalker(entity.x, entity.y - 16));
        }
        if(entity.gid == SEER)
        {
          entities.push(new Seer(entity.x, entity.y - 16));
        }
        if(entity.gid == HEART)
        {
          entities.push(new Heart(entity.x, entity.y - 16));
        }
        if(entity.gid == ANGEL)
        {
          entities.push(new Angel(entity.x, entity.y - 16));
        }
      }
  }

}
