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
 * D2D纹理类
 */
class D2DTexture implements D2DResource, D2DDrawable {
  
  ImageElement _image;

  /**
   * 创建
   */
  D2DTexture(String url) {
    _image = new ImageElement(src: url);
  }
  
  /**
   * 创建-绑定一个image
   */
  D2DTexture.bind(String imageId) {
    _image = querySelector(imageId);
  }

  /**
   * 获取canvas绘图源
   */
  CanvasImageSource getCanvasImageSource() {
    return _image;  
  }

  /**
   * 是否就绪
   */
  bool isReady() {
    return _image.complete;
  }

  /**
   * 获取Image
   */
  ImageElement getImage() {
    return _image;
  }
  
  /**
   * 取宽度
   */
  int getWidth() {
    return _image.width;
  }
  
  /**
   * 取高度
   */
  int getHeight() {
    return _image.height;
  }
  
}

