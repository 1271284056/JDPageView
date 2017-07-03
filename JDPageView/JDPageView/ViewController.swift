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
        let pageViewFrame = CGRect(x: 0, y: 40, width: view.bounds.width, height: view.bounds.height - 40)
        
        // 2.所有的标题
        var titles = ["游戏游戏","推荐", "手游玩法大全", "趣玩", "游戏游戏", "趣玩","娱乐手", ]
        
        // 3.titleView的样式
        let style = JDPageStyle()
        style.titleViewHeight = 44
        
        // isScrollEnable false固定宽度 不能滚动   true 不固定宽高 可以滑动
        style.isScrollEnable = true
        
        //MARK: 上面的一行和下面三行选一种注释 效果不同
//        titles = ["游戏游戏","推荐", "玩法大全", "趣玩"]
//        style.isScrollEnable = false
//        style.bottomLineWidth = 60  // 固定长度 下面线条宽度

        //选中标题是否变大
        //  style.isTitleScale = true
        //是否展示标题上的阴影
        style.isShowCoverView = false
        
        var childVcs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVcs.append(vc)
        }
        
        let pageView = JDPageView(frame: pageViewFrame, titles: titles, titleStyle: style, childVcs: childVcs, parentVc: self)
        
        //起始索引
        pageView.startIndex = 3
        
        // 6.将pageView添加到控制器的view中
        view.addSubview(pageView)
    }


}

