//
//  JDContentView.swift
//  JDPageView
//
//  Created by 张江东 on 17/2/7.
//  Copyright © 2017年 58kuaipai. All rights reserved.
//

import UIKit

private let kContentCellID = "kContentCellID"

protocol JDContentViewDelegate : class {
    func contentView(_ contentView : JDContentView, targetIndex : Int, progress : CGFloat)
    func contentView(_ contentView : JDContentView, endScroll inIndex : Int)
}

class JDContentView: UIView {
    
    // MARK: 定义属性
    weak var delegate : JDContentViewDelegate?
    
    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    
    fileprivate lazy var startOffsetX : CGFloat = 0
    fileprivate lazy var isForbidDelegate : Bool = false
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        
        return collectionView
    }()
    
    // MARK: 构造函数
    init(frame : CGRect, childVcs : [UIViewController], parentVc : UIViewController) {
        
        self.childVcs = childVcs
        self.parentVc = parentVc
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("不能从xib中加载")
    }
}


// MARK:- 设置UI界面
extension JDContentView {
    fileprivate func setupUI() {
        // 1.将childVc添加到父控制器中
        for vc in childVcs {
            parentVc.addChildViewController(vc)
        }
        
        // 2.初始化用于显示子控制器View的View（UIScrollView/UICollectionView）
        addSubview(collectionView)
    }
}


// MARK:- 遵守UICollectionViewDataSource协议
extension JDContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        let vc = childVcs[indexPath.item]
        vc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(vc.view)
        
        return cell
    }
}


// MARK:- 遵守UICollectionViewDelegate协议
extension JDContentView : UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionViewEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            collectionViewEndScroll()
        }
    }
    
    private func collectionViewEndScroll() {
        // 1.获取结束时，对应的indexPath
        let endIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        
        // 2.通知titleView改变下标
        delegate?.contentView(self, endScroll: endIndex)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 记录开始的位置
        isForbidDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x == startOffsetX || isForbidDelegate { return }
        
        // 1.定义目标的index、进度
        var targetIndex : Int = 0
        var progress : CGFloat = 0
        
        // 2.判断用户是左滑还是右滑
        if scrollView.contentOffset.x > startOffsetX { // 左滑
            targetIndex = Int(startOffsetX / scrollView.bounds.width) + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            progress = (scrollView.contentOffset.x - startOffsetX) / scrollView.bounds.width
        } else { // 右滑
            targetIndex = Int(startOffsetX / scrollView.bounds.width) - 1
            if targetIndex < 0 {
                targetIndex = 0
            }
            progress = (startOffsetX - scrollView.contentOffset.x) / scrollView.bounds.width
        }
        
        // 3.将数据传递给titleView
        delegate?.contentView(self, targetIndex: targetIndex, progress: progress)
    }
}

// MARK:- 遵守JDTitleViewDelegate协议
extension JDContentView : JDTitleViewDeleate {
    func titleView(_ titleView: JDTitleView, didSelected currentIndex: Int) {
        
        isForbidDelegate = true
        
        let indexPath = IndexPath(item: currentIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}
