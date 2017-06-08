//
//  JDTitleView.swift
//
//  Created by 张江东 on 17/2/7.
//  Copyright © 2017年 58kuaipai. All rights reserved.
//

import UIKit

/*
 1.内容是否可以滚动
    * 如果可以滚动，则需要加UIScrollView
 */

protocol JDTitleViewDeleate : class {
    func titleView(_ titleView : JDTitleView, didSelected currentIndex : Int)
}

class JDTitleView: UIView {
    
    // MARK: 定义属性
    weak var delegate : JDTitleViewDeleate?
    
    fileprivate var titles : [String]
    fileprivate var style : JDPageStyle
    
    fileprivate lazy var currentIndex : Int = 0
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    fileprivate lazy var bottomLine : UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        bottomLine.frame.size.height = self.style.bottomLineHeight
        return bottomLine
    }()
    fileprivate lazy var coverView : UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.style.coverBgColor
        coverView.alpha = self.style.coverAlpha
        return coverView
    }()
    
    // MARK: 构造函数
    init(frame : CGRect, titles : [String], style : JDPageStyle) {
        
        self.titles = titles
        self.style = style
        
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("不能从Xib中加载")
    }
}


// MARK:- 设置UI界面
extension JDTitleView {
    fileprivate func setupUI() {
        // 1.添加滚动view
        addSubview(scrollView)
        
        // 2.添加title对应的label
        setupTitleLabels()
        
        // 3.设置Label的frame
        setupTitleLabelsFrame()
        
        // 4.设置BottomLine
        setupBottomLine()
        
        // 5.设置CoverView
        setupCoverView()
    }
    
    private func setupTitleLabels() {
        for (i, title) in titles.enumerated() {
            // 1.创建Label
            let titleLabel = UILabel()
            
            // 2.设置label的属性
            titleLabel.text = title
            titleLabel.tag = i
            titleLabel.font = style.titleFont
            titleLabel.textColor = i == 0 ? style.selectColor : style.normalColor
            titleLabel.textAlignment = .center
            
            // 3.添加到父控件中
            scrollView.addSubview(titleLabel)
            
            // 4.保存label
            titleLabels.append(titleLabel)
            
            // 5.添加手势
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            titleLabel.addGestureRecognizer(tapGes)
            titleLabel.isUserInteractionEnabled = true
        }
    }
    
    private func setupTitleLabelsFrame() {
        let count = titles.count
        
        for (i, label) in titleLabels.enumerated() {
            var w : CGFloat = 0
            let h : CGFloat = bounds.height
            var x : CGFloat = 0
            let y : CGFloat = 0
            
            if !style.isScrollEnable {
                w = bounds.width / CGFloat(count)
                x = w * CGFloat(i)
            } else {
                w = (titles[i] as NSString).boundingRect(with: CGSize(width : CGFloat.greatestFiniteMagnitude, height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : style.titleFont], context: nil).width
                if i == 0 {
                    x = style.titleMargin * 0.5
                } else {
                    let preLabel = titleLabels[i - 1]
                    x = preLabel.frame.maxX + style.titleMargin
                }
            }
            
            label.frame = CGRect(x: x, y: y, width: w, height: h)
            
            if style.isTitleScale && i == 0 {
                label.transform = CGAffineTransform(scaleX: style.scaleRange, y: style.scaleRange)
            }
        }
        
        if style.isScrollEnable {
            scrollView.contentSize.width = titleLabels.last!.frame.maxX + style.titleMargin * 0.5
        }
    }
    
    private func setupBottomLine() {
        // 1.判断是否需要显示底部线段
        guard style.isShowBottomLine else { return }
        
        // 2.将bottomLine添加到titleView中
        scrollView.addSubview(bottomLine)
        
        // 3.设置frame
        bottomLine.frame.origin.x = titleLabels.first!.frame.origin.x
        bottomLine.frame.origin.y = bounds.height - style.bottomLineHeight
        bottomLine.frame.size.width = titleLabels.first!.bounds.width
    }
    
    private func setupCoverView() {
        // 1.判断是否需要显示
        guard style.isShowCoverView else { return }
        
        // 2.添加coverView到scrollview中
        scrollView.addSubview(coverView)
        
        // 3.设置frame
        var coverW : CGFloat = titleLabels.first!.frame.width - 2 * style.coverMargin
        if style.isScrollEnable {
            coverW = titleLabels.first!.frame.width + style.titleMargin * 0.5
        }
        let coverH : CGFloat = style.coverHeight
        coverView.bounds = CGRect(x: 0, y: 0, width: coverW, height: coverH)
        coverView.center = titleLabels.first!.center
        
        coverView.layer.cornerRadius = style.coverHeight * 0.5
        coverView.layer.masksToBounds = true
    }
}


// MARK:- 事件处理函数
extension JDTitleView {
    @objc fileprivate func titleLabelClick(_ tapGes : UITapGestureRecognizer) {
        // 0.取出点击的Label
        guard let newLabel = tapGes.view as? UILabel else { return }
        
        // 1.改变自身的titleLabel的颜色
        let oldLabel = titleLabels[currentIndex]
        oldLabel.textColor = style.normalColor
        newLabel.textColor = style.selectColor
        currentIndex = newLabel.tag
        
        // 2.通知内容View改变当前的位置
        delegate?.titleView(self, didSelected: currentIndex)
        
        // 3.调整BottomLine
        if style.isShowBottomLine {
            bottomLine.frame.origin.x = newLabel.frame.origin.x
            bottomLine.frame.size.width = newLabel.frame.width
        }
        
        // 4.调整缩放比例
        if style.isTitleScale {
            newLabel.transform = oldLabel.transform
            oldLabel.transform = CGAffineTransform.identity
        }
        
        // 5.调整位置
        adjustPosition(newLabel)
        
        // 6.调整coverView的位置
        if style.isShowCoverView {
            let coverW = style.isScrollEnable ? (newLabel.frame.width + style.titleMargin) : (newLabel.frame.width - 2 * style.coverMargin)
            coverView.frame.size.width = coverW
            coverView.center = newLabel.center
        }
    }
}


extension JDTitleView : JDContentViewDelegate {
    func contentView(_ contentView: JDContentView, endScroll inIndex: Int) {
        // 1.取出两个Label
        let oldLabel = titleLabels[currentIndex]
        let newLabel = titleLabels[inIndex]
        
        // 2.改变文字的颜色
        oldLabel.textColor = style.normalColor
        newLabel.textColor = style.selectColor
        
        // 3.记录最新的index
        currentIndex = inIndex
        
        // 4.判断是否可以滚动
        adjustPosition(newLabel)
    }
    
    
    fileprivate func adjustPosition(_ newLabel : UILabel) {
        guard style.isScrollEnable else { return }
        var offsetX = newLabel.center.x - scrollView.bounds.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        let maxOffset = scrollView.contentSize.width - bounds.width
        if offsetX > maxOffset {
            offsetX = maxOffset
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    func contentView(_ contentView: JDContentView, targetIndex: Int, progress: CGFloat) {
        // 1.取出两个Label
        let oldLabel = titleLabels[currentIndex]
        let newLabel = titleLabels[targetIndex]
        
        // 2.渐变文字颜色
        let selectRGB = getGRBValue(style.selectColor)
        let normalRGB = getGRBValue(style.normalColor)
        let deltaRGB = (selectRGB.0 - normalRGB.0, selectRGB.1 - normalRGB.1, selectRGB.2 - normalRGB.2)
        oldLabel.textColor = UIColor(r: selectRGB.0 - deltaRGB.0 * progress, g: selectRGB.1 - deltaRGB.1 * progress, b: selectRGB.2 - deltaRGB.2 * progress)
        newLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        
        // 3.渐变BottomLine
        if style.isShowBottomLine {
            let deltaX = newLabel.frame.origin.x - oldLabel.frame.origin.x
            let deltaW = newLabel.frame.width - oldLabel.frame.width
            bottomLine.frame.origin.x = oldLabel.frame.origin.x + deltaX * progress
            bottomLine.frame.size.width = oldLabel.frame.width + deltaW * progress
        }
        
        // 4.调整缩放
        if style.isTitleScale {
            let deltaScale = style.scaleRange - 1.0
            oldLabel.transform = CGAffineTransform(scaleX: style.scaleRange - deltaScale * progress, y: style.scaleRange - deltaScale * progress)
            newLabel.transform = CGAffineTransform(scaleX: 1.0 + deltaScale * progress, y: 1.0 + deltaScale * progress)
        }
        
        // 5.调整coverView
        if style.isShowCoverView {
            let oldW = style.isScrollEnable ? (oldLabel.frame.width + style.titleMargin) : (oldLabel.frame.width - 2 * style.coverMargin)
            let newW = style.isScrollEnable ? (newLabel.frame.width + style.titleMargin) : (newLabel.frame.width - 2 * style.coverMargin)
            let deltaW = newW - oldW
            let deltaX = newLabel.center.x - oldLabel.center.x
            coverView.frame.size.width = oldW + deltaW * progress
            coverView.center.x = oldLabel.center.x + deltaX * progress
        }
    }
    
    private func getGRBValue(_ color : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        guard  let components = color.cgColor.components else {
            fatalError("文字颜色请按照RGB方式设置")
        }
        
        return (components[0] * 255, components[1] * 255, components[2] * 255)
    }
}
