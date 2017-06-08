//
//  JDPageView.swift
//
//  Created by 张江东 on 17/2/7.
//  Copyright © 2017年 58kuaipai. All rights reserved.
//

import UIKit

class JDPageView: UIView {
    
    // MARK: 定义属性
    fileprivate var titles : [String]
    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    fileprivate var titleStyle : JDPageStyle
    
    // MARK: 构造函数
    init(frame : CGRect, titles : [String], titleStyle : JDPageStyle, childVcs : [UIViewController], parentVc : UIViewController) {
        
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.titleStyle = titleStyle
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK:- 设置UI界面内容
extension JDPageView {
    fileprivate func setupUI() {
        // 1.添加titleView到pageView中
        let titleViewFrame = CGRect(x: 0, y: 0, width: bounds.width, height: titleStyle.titleViewHeight)
        let titleView = JDTitleView(frame: titleViewFrame, titles: titles, style : titleStyle)
        addSubview(titleView)
        titleView.backgroundColor = UIColor.randomColor()
        
        // 2.添加contentView到pageView中
        let contentViewFrame = CGRect(x: 0, y: titleView.frame.maxY, width: bounds.width, height: frame.height - titleViewFrame.height)
        let contentView = JDContentView(frame: contentViewFrame, childVcs: childVcs, parentVc: parentVc)
        addSubview(contentView)
        contentView.backgroundColor = UIColor.randomColor()
        
        // 3.设置contentView&titleView关系
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
}
