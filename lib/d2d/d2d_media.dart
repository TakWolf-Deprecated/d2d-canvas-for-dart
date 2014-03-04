/*
 * D2D Canvas for Dart
 * 
 * By TakWolf - takgdx@gmail.com
 * http://www.takwolf.com/d2dcanvas
 * 
 * Released under Apache License 2.0
 * 
 */
part of d2d;

/**
 * 媒体状态
 */
const int MEDIA_HAVE_NOTHING = 0; //没有关于音频/视频是否就绪的信息
const int MEDIA_METADATA = 1;     //关于音频/视频就绪的元数据
const int MEDIA_CURRENT_DATA = 2; //关于当前播放位置的数据是可用的，但没有足够的数据来播放下一帧/毫秒
const int MEDIA_FUTURE_DATA = 3;  //当前及至少下一帧的数据是可用的
const int MEDIA_ENOUGH_DATA = 4;  //可用数据足以开始播放

/**
 * D2D多媒体抽象类
 */
abstract class D2DMedia implements D2DResource {
  
  /**
   * 获取多媒体上下文
   */
  MediaElement getMedia();
 
  /**
   * 获取音频就绪状态代码
   */
  int getReadyState() {
    return getMedia().readyState;
  }
 
  /**
   * 是否就绪
   */
  bool isReady() {
    return getReadyState() == MEDIA_ENOUGH_DATA;
  }

  /**
   * 置自动播放
   */
  void setAutoPlay(bool auto) {
    getMedia().autoplay = auto;
  }
  
  /**
   * 是否自动播放
   */
  bool isAutoPlay() {
    return getMedia().autoplay;
  }

  /**
   * 置播放速率
   * 1为不变
   */
  void setPlaybackRate(num rate) {
    getMedia().playbackRate = rate;
  }
  
  void setSpeed(num speed) => setPlaybackRate(speed);
  
  /**
   * 取播放速率
   */
  num getPlaybackRate() {
    return getMedia().playbackRate;
  }
  
  num getSpeed() => getPlaybackRate();

  /**
   * 是否播放中
   */
  bool isPlaying() {
    return getMedia().paused == false;
  }
  
  /**
   * 置当前时间-线程不安全
   */
  void setCurrentTime(num time) {
    if (isReady()) {
      getMedia().currentTime = time;
    }
  }
  
  /**
   * 取当前时间
   */
  num getCurrentTime() {
    return getMedia().currentTime;
  }
  
  /**
   * 取总长度时间
   */
  double getDuration() {
    return getMedia().duration;
  }
  
  double getTotalTime() => getDuration();
  
  /**
   * 置循环
   */
  void setLooping(bool loop) {
    getMedia().loop = loop;
  }
  
  /**
   * 是否循环
   */
  bool isLooping() {
    return getMedia().loop;
  }
  
  /**
   * 取音量
   */
  num getVolume() {
    return getMedia().volume;
  }
  
  /**
   * 置音量-1为原音量，0为静音，不能超过1
   */
  void setVolume(num volume) {
    getMedia().volume = volume;
  }

  /**
   * 获取当前有效的播放音地址
   */
  String getCurrentSource() {
    return getMedia().currentSrc;
  }

  /**
   * 添加音源
   */
  void addSource(String url) {
    var e = document.createElement('source');
    e.src = url;
    getMedia().append(e);
  }

  /**
   * 播放
   */
  void play() {
    if (isReady()) {
      getMedia().play();
    }
  }
  
  /**
   * 暂停
   */
  void pause() {
    getMedia().pause();
  }
  
  /**
   * 停止
   */
  void stop() {
    pause(); //先暂停
    if (isReady()) { //线程不安全，需要判断
      setCurrentTime(0); //置播放位置为0
    }
  }
  
}

