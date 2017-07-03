//
//  JDPageView.swift
//
//  Created by 张江东 on 17/2/7.
//  Copyright © 2017年 58kuaipai. All rights reserved.
//

import UIKit

let kScreenFrame : CGRect =  UIScreen.main.bounds
let kScreenSize : CGSize = UIScreen.main.bounds.size
//  屏幕的宽度
let kScreenWidth = UIScreen.main.bounds.size.width
//  屏幕的高度
let kScreenHeight = UIScreen.main.bounds.size.height

class JDPageView: UIView {
    
    // MARK: 定义属性
    fileprivate var titles : [String]
    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    fileprivate var titleStyle : JDPageStyle
    
    var titleView : JDTitleView?
    var contentView: JDContentView?
    
    var startIndex: Int = 0{
        didSet{
            
            if startIndex > self.childVcs.count - 1 {
                return
            }
            DispatchQueue.main.async {
                let indexPa = IndexPath(item: self.startIndex, section: 0)
                self.contentView?.collectionView.scrollToItem(at: indexPa, at: .centeredHorizontally, animated: false)
                self.contentView?.delegate?.contentView((self.contentView)!, targetIndex: self.startIndex, progress: 1)
                self.contentView?.delegate?.contentView( (self.contentView)!, endScroll: self.startIndex)
            }
        }
    }

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
    
    fileprivate func setupUI() {
        // 1.添加titleView到pageView中
        let titleViewFrame = CGRect(x: 0, y: 0, width: bounds.width, height: titleStyle.titleViewHeight)
        
        
        titleView = JDTitleView(frame: titleViewFrame, titles: titles, style : titleStyle)
        self.addSubview(titleView!)
        titleView?.backgroundColor = UIColor.white

        
        
        // 2.添加contentView到pageView中
        let contentViewFrame = CGRect(x: 0, y: (titleView?.frame.maxY)!, width: bounds.width, height: self.frame.size.height - titleViewFrame.height)
        contentView = JDContentView(frame: contentViewFrame, childVcs: childVcs, parentVc: parentVc)
        addSubview(contentView!)
        contentView?.backgroundColor = UIColor.white
        
        // 3.设置contentView&titleView关系
        titleView?.delegate = contentView
        contentView?.delegate = titleView
    }
    
}


// MARK:- 设置UI界面内容
extension JDPageView {

}
