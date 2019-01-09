//
//  SearchViewController.swift
//  SexualMediaApp
//
//  Created by 新 真大 on 2018/10/07.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//

import UIKit
import FSPagerView

class StepViewController: UIViewController {
    
   
    @IBOutlet weak var coverFlowSliderView: FSPagerView!{
        didSet {
            self.coverFlowSliderView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    fileprivate var coverflowContents: [Coverflow] = [] {
        didSet {
            self.coverFlowSliderView.reloadData()
        }
    }
    

    @IBOutlet weak var backGroundImage: UIImageView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCoverFlowSliderView()
    }
    
    private func setupCoverFlowSliderView() {
        coverFlowSliderView.delegate = self
        coverFlowSliderView.dataSource = self
        coverFlowSliderView.isInfinite = true
        coverFlowSliderView.itemSize = CGSize(width: 187, height: 334)
        coverFlowSliderView.interitemSpacing = 16
        coverFlowSliderView.transformer = FSPagerViewTransformer(type: .coverFlow)
        
        coverflowContents = Coverflow.getSampleData()
    }
    
    
    
}

extension StepViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return coverflowContents.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let coverflow = coverflowContents[index]
        
        cell.contentView.layer.shadowOpacity = 0.4
        cell.contentView.layer.opacity = 0.86
        
        cell.imageView?.image = coverflow.thumbnail
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        
        if index == pagerView.currentIndex {
            let homeVc = storyboard!.instantiateViewController(withIdentifier: "ViewController") as? ViewController
            homeVc?.modalTransitionStyle = .crossDissolve
            self.present(homeVc!,animated: true, completion: { () in
                 homeVc?.pageMenu?.startWithPage(index)//animatedfalseにしたらいい感じになった。
            })
            //dismiss(animated: true, completion: nil) //できた！
        }
    }
    


    
    
}
