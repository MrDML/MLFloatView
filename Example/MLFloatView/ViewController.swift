//
//  ViewController.swift
//  MLFloatView
//
//  Created by DML on 06/04/2018.
//  Copyright (c) 2018 DML. All rights reserved.
//

import UIKit
import MLFloatView

class ViewController: UIViewController,MLFloatViewDelegate {

    var floatView:MLFloatView! = nil
   public var row:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        switch row {
        case 0:
            initializeStyleOne()
        case 1:
             initializeStyleTwo()
        case 2:
            initializeStyleThree()
        default:
            break
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        floatView.isHidden = true
    }
    
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
    
    
    func floatViewClickAction(floatView: MLFloatView) {
        print("\(#line):\(#function)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        floatView.startAnimation(isAllShow: false)
    }

}

