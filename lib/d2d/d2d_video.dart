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
 * D2D视频类
 */
class D2DVideo extends D2DMedia implements D2DDrawable {
  
  VideoElement _video;
  
  /**
   * 创建
   */
  D2DVideo(String url) {
    _video = new VideoElement();
    addSource(url);
  }
  
  /**
   * 创建-绑定一个video
   */
  D2DVideo.bind(String videoId) {
    _video = querySelector(videoId);
  }

  /**
   * 获取多媒体上下文
   */
  MediaElement getMedia() {
    return _video;
  }

  /**
   * 获取canvas绘图源
   */
  CanvasImageSource getCanvasImageSource() {
    return _video;  
  }

  /**
   * 获取video
   */
  VideoElement getVideo() {
    return _video;
  }

}

