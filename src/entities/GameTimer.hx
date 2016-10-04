package entities;

class GameTimer
{

  static var allTimers:Array<GameTimer> = new Array<GameTimer>();

  public var count:Int;
  public var prevCount:Int;
  public var duration:Int;

  public function new(duration:Int)
  {
    this.duration = duration;
    count = 0;
    prevCount = 0;
    allTimers.push(this);
  }

  public function reset()
  {
    count = duration;
  }

  public function percentComplete() {
    return count / duration;
  }

  public function isActive()
  {
    return count > 0;
  }

  public function wasActive()
  {
    return prevCount == 1;
  }

  public static function updateAll()
  {
    for(timer in allTimers)
    {
      timer.prevCount = timer.count;
      if(timer.count > 0)
      {
        timer.count -= 1;
      }
    }
  }

}
