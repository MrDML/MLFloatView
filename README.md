# MLFloatView

[![CI Status](https://img.shields.io/travis/DML/MLFloatView.svg?style=flat)](https://travis-ci.org/DML/MLFloatView)
[![Version](https://img.shields.io/cocoapods/v/MLFloatView.svg?style=flat)](https://cocoapods.org/pods/MLFloatView)
[![License](https://img.shields.io/cocoapods/l/MLFloatView.svg?style=flat)](https://cocoapods.org/pods/MLFloatView)
[![Platform](https://img.shields.io/cocoapods/p/MLFloatView.svg?style=flat)](https://cocoapods.org/pods/MLFloatView)


## Preview
![Demo](https://github.com/MrDML/MLFloatView/blob/master/MLFloatViewGif.gif)


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MLFloatView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MLFloatView'
```
## Example Use

```Objective-C
// 设置frame
func initializeStyleOne(){
// 在初始化之前设置一些默认值
MLFloatView.configFloatViewDefaultValue(edgeScreenOffset: 5, distanceTaBarOffset: 20, isAnimation: true)
floatView = MLFloatView.init(image: UIImage.init(named: "redpacket"))
let size = (floatView.image?.size)!
let screenWidth = UIScreen.main.bounds.width
let screenHeigh = UIScreen.main.bounds.height
floatView.frame.origin = CGPoint(x: screenWidth - size.width - 20, y: screenHeigh - size.height - 50)
floatView.delegate = self
floatView.clickActionBlock = {(floatView) -> Void in
print("\(#line):\(#function)")
}
self.view .insertSubview(floatView, at: self.view.subviews.count)
}

// 无需设置frame 快速创建
func initializeStyleTwo(){
// 在初始化之前设置一些默认值
MLFloatView.configFloatViewDefaultValue(edgeScreenOffset: 5, distanceTaBarOffset: 20, isAnimation: true)
floatView =  MLFloatView.init(image: UIImage.init(named: "redpacket"), stopEdgeLocation: FloatViewAllShowState.AllShowRight)
floatView.clickActionBlock = {(floatView) -> Void in
print("\(#line):\(#function)")
}
self.view.insertSubview(floatView!, at: self.view.subviews.count)
}

func initializeStyleThree(){
// 在初始化之前设置一些默认值
MLFloatView.configFloatViewDefaultValue(edgeScreenOffset: 5, distanceTaBarOffset: 20, isAnimation: false)
floatView =  MLFloatView.init(image: UIImage.init(named: "redpacket"), stopEdgeLocation: FloatViewAllShowState.AllShowRight)
floatView.clickActionBlock = {(floatView) -> Void in
print("\(#line):\(#function)")
}
self.view.insertSubview(floatView!, at: self.view.subviews.count)
}

```


## Author

DML, dml1630@163.com

## License

MLFloatView is available under the MIT license. See the LICENSE file for more info.

