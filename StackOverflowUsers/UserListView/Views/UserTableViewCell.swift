//
//  UserTableViewCell.swift
//  StackOverflowUsers
//
//  Created by Colin Walsh on 9/4/20.
//  Copyright © 2020 Colin Walsh. All rights reserved.
//

import UIKit
import Kingfisher
import RxKingfisher
import RxSwift
import RxCocoa

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var silverLabel: UILabel!
    @IBOutlet weak var bronzeLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    private var _disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self._disposeBag = DisposeBag()
    }
    
    func setUIWithViewModel(_ viewModel: UserViewModel) {
        
        userNameLabel.text = viewModel.getDisplayName()
        goldLabel.text = String(viewModel.getGoldBadgeCount())
        silverLabel.text = String(viewModel.getSilverBadgeCount())
        bronzeLabel.text = String(viewModel.getBronzeBadgeCount())
        
        profileImageView.kf.indicatorType = .activity
        Observable.of(viewModel.getProfileUrl()!)
            .flatMapLatest { KingfisherManager
                                .shared
                                .rx
                                .retrieveImage(with: $0) }
            .observeOn(MainScheduler.instance)
            .subscribe (onNext: {[unowned self] in
                self.profileImageView.maskCircle(anyImage: $0)
            })
            .disposed(by: _disposeBag)
    }
}
