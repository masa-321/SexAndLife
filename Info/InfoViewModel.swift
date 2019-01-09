//
//  InfoViewModel.swift
//  SexualMediaApp
//
//  Created by 新真大 on 2018/10/12.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//

import Foundation

class InfoViewModel: NSObject {
    var infoCellViewModel: [Any]!{
        didSet{
            didChange?()
        }
    }
    
    private var didChange: (() -> Void)?
    //これ何も処理していなくないか？いや、var str = ""の関数バージョンか
    
    func bind(didChange: @escaping () -> Void) {
        self.didChange = didChange
    }
    //@escaping処理をしたdidChangeを改めてdidCahgeに格納している。didChangeはクロージャーの外でも参照できるようになった？
    
    enum CellViewType: Int, CaseIterable{
        
        case profile
        
        case socialNetwork
        
        case notification
        
        case inquiry //お問い合わせ
        
        //case cacheClear
        
        //case frequentQA
        
        //case review
        
        case privacyPolicy
        
        case licenseInfo
    }
    //CellViewTypeを配列にし、数えられるようにしている。多分ここを減らしたり増やしたりしたら、項目を操作できる。
    
    
    func createCellViewModel() {
        var viewModel: [Any] = []
        for i in 0..<CellViewType.allCases.count {
            guard let type = CellViewType(rawValue: i) else { break }
            //typeにCellViewTypeを順々に入れ込んでいる。
            viewModel.append(InfoCellViewModel(type: type))
            //typeに対応するInfoCellViewModelを、viewModelに追加し、プログラムで操作できる方向へ？
        }
        infoCellViewModel = viewModel
    }
    
}
