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
 * D2D资源-接口
 */
abstract class D2DResource {

  /**
   * 默认构造函数
   */
  D2DResource(String url); //子类必须实现一个该结构的构造函数
  
  /**
   * 是否就绪
   */
  bool isReady();

}

