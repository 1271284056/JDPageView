//
//  UIColor+Extension.swift
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
   
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
        
    }
    
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    static func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
}
