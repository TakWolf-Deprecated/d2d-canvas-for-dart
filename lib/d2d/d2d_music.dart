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
 * D2D音效类
 */
class D2DMusic extends D2DMedia {
  
  AudioElement _audio;
  
  /**
   * 创建
   */
  D2DMusic(String url) {
    _audio = new AudioElement();
    addSource(url);
  }
  
  /**
   * 创建-绑定一个audio
   */
  D2DMusic.bind(String audioId) {
    _audio = querySelector(audioId);
  }

  /**
   * 获取多媒体上下文
   */
  MediaElement getMedia() {
    return _audio;
  }

  /**
   * 获取audio
   */
  AudioElement getAudio() {
    return _audio;
  }
  
}

