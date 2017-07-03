//
//  UIColor+Extension.swift
//  JDPageView
//
//  Created by 张江东 on 16/11/9.
//  Copyright © 2016年 58kuaipai. All rights reserved.
//

import UIKit

extension UIColor {
//类方法 static func
    static func colorWithHex(hexColor:Int64)->UIColor{
        
        let red = ((CGFloat)((hexColor & 0xFF0000) >> 16))/255.0;
        let green = ((CGFloat)((hexColor & 0xFF00) >> 8))/255.0;
        let blue = ((CGFloat)(hexColor & 0xFF))/255.0;
   
        return UIColor(r: red, g: green, b: blue)
        
    }
    
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    static func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
}


//  对UIView的扩展
extension UIView {
    
    
    //  扩展计算属性
    //  x坐标
    var x: CGFloat {
        get {
            return frame.origin.x
        } set {
            frame.origin.x = newValue
        }
    }
    //  y坐标
    var y: CGFloat {
        get {
            return frame.origin.y
        } set {
            frame.origin.y = newValue
        }
    }
    
    //  宽度
    var width: CGFloat {
        
        get {
            return frame.size.width
        } set {
            frame.size.width = newValue
        }
        
        
    }
    //  高度
    var height: CGFloat {
        
        get {
            return frame.size.height
        } set {
            frame.size.height = newValue
        }
        
        
    }
    
    //  中心x
    var centerX: CGFloat {
        get {
            return center.x
        } set {
            center.x = newValue
        }
    }
    
    //  中心y
    var centerY: CGFloat {
        get {
            return center.y
        } set {
            center.y = newValue
        }
    }
    
    //  获取或者设置size大小
    var size: CGSize {
        get {
            return frame.size
        } set {
            frame.size = newValue
        }
    }
    
    /// 右边界的x值
    public var maxX: CGFloat{
        get{
            return self.x + self.width
        }
        set{
            var r = self.frame
            r.origin.x = newValue - frame.size.width
            self.frame = r
        }
    }
    
    // 下边界的y值
    public var maxY: CGFloat{
        get{
            return self.y + self.height
        }
        set{
            var r = self.frame
            r.origin.y = newValue - frame.size.height
            self.frame = r
        }
    }
    
    public var origin: CGPoint{
        get{
            return self.frame.origin
        }
        set{
            self.x = newValue.x
            self.y = newValue.y
        }
    }
    
}

