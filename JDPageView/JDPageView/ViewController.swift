//
//  ViewController.swift
//  JDPageView
//
//  Created by 张江东 on 2017/6/8.
//  Copyright © 2017年 58kuaipai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        // 1.搞定frame
        let pageViewFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        
        // 2.所有的标题
        //        let titles = ["推荐", "手游", "娱乐", "游戏", "趣玩"]
        let titles = ["游戏游戏","推荐", "手游玩法大全", "趣玩", "游戏游戏", "趣玩","娱乐手", ]
        
        // 3.titleView的样式
        let style = JDPageStyle()
        style.titleViewHeight = 44
        
        // isScrollEnable false固定宽度 不能滚动   true 不固定宽高 可以滑动
        style.isScrollEnable = true
//        style.isScrollEnable = false

        //选中标题是否变大
        //  style.isTitleScale = true
        //是否展示标题上的阴影
        style.isShowCoverView = true
        
        // 4.初始化所有的子控制器
        var childVcs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVcs.append(vc)
        }
        
        let pageView = JDPageView(frame: pageViewFrame, titles: titles, titleStyle: style, childVcs: childVcs, parentVc: self)
        
        // 6.将pageView添加到控制器的view中
        view.addSubview(pageView)
    }


}

