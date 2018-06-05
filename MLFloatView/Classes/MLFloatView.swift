//
//  MLFloatView.swift
//  MLFloatView
//
//  Created by DML. on 2018/6/4.
//

import UIKit


public struct FloatViewDefault {
     let statusBarHeight = UIApplication.shared.statusBarFrame.height
     var safeNavigationHeight:CGFloat{
        return 44.0  + self.statusBarHeight
    }
    var screenWidth = UIScreen.main.bounds.width
    var screenHeigh = UIScreen.main.bounds.height
    var safeTabBarHeight:CGFloat = 49.0
    var distanceTaBarOffset:CGFloat = 20.0
    var edgeOffset:CGFloat = 5.0
    var isAnimation = true
}




enum FloatViewMovingState {
    case IsMoving
    case EndMoving
}

public enum FloatViewAllShowState {
    case Non
    case AllShowRight
    case AllShowLeft
    
    
}

public enum FloatViewHalfShowState {
    case Non
    case HalfShowRight
    case HalfShowLeft

}

@objc public protocol MLFloatViewDelegate:NSObjectProtocol {
    @objc optional func floatViewClickAction(floatView:MLFloatView)
}


open class MLFloatView: UIImageView {
    
    public var clickActionBlock:((_ floatView:MLFloatView)->Void)?

    public weak var delegate:MLFloatViewDelegate?
    
    public static var defaultValue = FloatViewDefault()

    typealias Task = (_ cancel: Bool) -> Void
    var task:Task?
    public var state = FloatViewAllShowState.Non
    public var aniCompleteState = FloatViewHalfShowState.Non
    var movingState = FloatViewMovingState.EndMoving

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initializeConfig()
    }
    
    public override init(image: UIImage?) {
        super.init(image: image)
        initializeConfig()
    }
    
     /// 便利构造器
     /// 初始化通过状态直接设置浮标的悬停位置  如果不满足条件直接返回nil
     /// - Parameters:
     ///   - image: image
     ///   - location: 通过状态设置位置
     convenience public init?(image: UIImage?, stopEdgeLocation location:FloatViewAllShowState) {
        guard let imageReult = image else { return nil }
        self.init(image: imageReult)
        state = location
        initializeByStateForLocation(imageSize: imageReult.size)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeConfig()
    }
    
    
   private func initializeByStateForLocation(imageSize size: CGSize){
        var x:CGFloat = 0,y:CGFloat = 0
        if state == .AllShowRight {
           x = MLFloatView.defaultValue.screenWidth - size.width - MLFloatView.defaultValue.edgeOffset
        }else if state == .AllShowLeft {
           x = MLFloatView.defaultValue.edgeOffset
        }
         y = MLFloatView.defaultValue.screenHeigh - size.height - MLFloatView.defaultValue.safeTabBarHeight - MLFloatView.defaultValue.distanceTaBarOffset
        self.frame.origin = CGPoint(x: x, y: y)
        self.frame.size = size
    }
    
    
    
    
   private func initializeConfig(){
    
        self.isUserInteractionEnabled = true
        let tapGesture =  UITapGestureRecognizer.init(target: self, action: #selector(clickAction))
        tapGesture.delaysTouchesBegan = true // default no
        tapGesture.delaysTouchesEnded = true;  // default yes
        tapGesture.cancelsTouchesInView = true // default yes
        self.addGestureRecognizer(tapGesture)

    }
    
    
    open override var frame: CGRect{
        didSet{
            if frame.origin.x <= MLFloatView.defaultValue.screenWidth * 0.5 {
                state = .AllShowLeft
            }else{
                state = .AllShowRight
            }

        }
    }
    
    @objc func clickAction(){
        
        if movingState == .IsMoving {return}
        if let hasTask = task {cancel(hasTask)}
        if MLFloatView.defaultValue.isAnimation == true {
            if state == .AllShowLeft || state == .AllShowRight {
                responseFuction()
            }else{
                if aniCompleteState == .HalfShowLeft || aniCompleteState == .HalfShowRight {
                    startAnimation(isAllShow: true)
                }
            }
        }else{
            responseFuction()
        }
 
    }
    
   private func responseFuction() {
        if let myDelegate = delegate {
            if myDelegate.responds(to: #selector(MLFloatViewDelegate.floatViewClickAction(floatView:))){
                myDelegate.floatViewClickAction!(floatView: self)
            }
        }
        
        if (clickActionBlock != nil) {
            clickActionBlock!(self)
        }
    }

    public func startAnimation(isAllShow show:Bool) {
        
        if MLFloatView.defaultValue.isAnimation == false {
            return
        }
        if state == .Non && show == false {
            return
        }
        if movingState == .EndMoving {
            startAnimation(aniCompleteState: aniCompleteState, isAllShow: show)
        }
        
    }

  
  private  func startAnimation(aniCompleteState:FloatViewHalfShowState, isAllShow show:Bool){

      if aniCompleteState == .Non {return}
    
        let signed:CGFloat = show == true ? 1.0 : -1.0

        var x = self.frame.origin.x
        
        if aniCompleteState == .HalfShowLeft {
            x = x + (self.frame.size.width * 0.5) * signed  + MLFloatView.defaultValue.edgeOffset * signed
        }else if aniCompleteState == .HalfShowRight {
            x = x - (self.frame.size.width * 0.5) * signed - MLFloatView.defaultValue.edgeOffset * signed
        }
    
        if x < -(self.frame.size.width * 0.5) || x > MLFloatView.defaultValue.screenWidth -   (self.frame.size.width * 0.5){
            return
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.frame.origin.x = x;
        }) { (complete) in
            
            if show == true {
                if complete == true {
                    self.state = aniCompleteState == .HalfShowLeft ? .AllShowLeft : .AllShowRight
                }
            }else{
                self.state = .Non
            }
            
            
        }
        
    }

    /// 提供类方法在初始化FloatView时可以设置默认值
    ///
    /// - Parameters:
    ///   - edgeOffset: default 5.0
    ///   - disOffset: default 20.0
    ///   - animation: default true
    public class func configFloatViewDefaultValue(edgeScreenOffset edgeOffset:CGFloat,distanceTaBarOffset disOffset:CGFloat, isAnimation animation:Bool){
        var defaultValue  =  FloatViewDefault.init()
        defaultValue.distanceTaBarOffset = disOffset
        defaultValue.edgeOffset = edgeOffset
        defaultValue.isAnimation = animation
        MLFloatView.defaultValue = defaultValue;
    }
    

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          if let hasTask = task {cancel(hasTask)}
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        movingState = .IsMoving
        
        guard let touch = touches.first else { return }
    
        let currentPoint = touch.location(in: self);
       
        let previousPoint = touch.previousLocation(in: self)
        
        let disX = currentPoint.x - previousPoint.x
        let disY = currentPoint.y - previousPoint.y
        
        self.frame.origin.x += disX
        self.frame.origin.y += disY
     
    
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        restorationSafe()
        
    }

    func restorationSafe(){
        
        let frame = self.frame
        var y = frame.origin.y
        var x = frame.origin.x
        if frame.origin.y <= MLFloatView.defaultValue.safeNavigationHeight {
            y = MLFloatView.defaultValue.safeNavigationHeight + MLFloatView.defaultValue.edgeOffset
        }
        
        if frame.origin.y >= MLFloatView.defaultValue.screenHeigh - MLFloatView.defaultValue.safeTabBarHeight - frame.size.height  {
            y = MLFloatView.defaultValue.screenHeigh - MLFloatView.defaultValue.safeTabBarHeight - frame.size.height - MLFloatView.defaultValue.edgeOffset
        }
        
        
        if frame.origin.x <= MLFloatView.defaultValue.screenWidth * 0.5 {
            x = MLFloatView.defaultValue.edgeOffset
            state = .AllShowLeft
        }else{
            x = MLFloatView.defaultValue.screenWidth - frame.size.width - MLFloatView.defaultValue.edgeOffset
            state = .AllShowRight
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = CGRect(x: x, y: y, width: frame.size.width, height: frame.size.height)
        }) { (comlpete) in
            if comlpete == true {
                
                if MLFloatView.defaultValue.isAnimation == true {
                    if self.state == .AllShowLeft {
                        x = x - (frame.size.width * 0.5) - MLFloatView.defaultValue.edgeOffset
                    }else{
                        x = x + (frame.size.width * 0.5) + MLFloatView.defaultValue.edgeOffset
                    }
                    self.task = self.delay(1, task: {
                        UIView.animate(withDuration: 0.2, animations: {
                            self.frame = CGRect(x: x , y: y, width: frame.size.width, height: frame.size.height)
                        }, completion: { (comlpete) in
                            if comlpete == true {
                                self.aniCompleteState = self.state == .AllShowLeft ? .HalfShowLeft : .HalfShowRight
                                self.state = .Non
                                self.movingState = .EndMoving
                            }
                            
                        })
                    })
                }else{
                    self.movingState = .EndMoving
                }
            }
            
        }
       
    }
    
    
   private func delay(_ time: TimeInterval,task:@escaping() -> ()) -> Task?{

        func dispatch_later(block:@escaping ()->()){
            let t = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        }
        var closure:(() -> Void)? = task
        var result: Task?
        let delayedClosure: Task = { cancel in

            if let internalClosure = closure {
                if (cancel == false){
                   DispatchQueue.main.async(execute: internalClosure)
                }
            }
            closure = nil
            result = nil
        }

        result = delayedClosure
        dispatch_later { () -> () in
            if let delayedClosureTemp = result {
                delayedClosureTemp(false)
            }
        }
        return result
    }
    
   private func cancel(_ task:Task?){
        task?(true)
    }
    

}















