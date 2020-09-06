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
    @IBOutlet weak var loadingActivityView: UIActivityIndicatorView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    private(set) var _disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        _disposeBag = DisposeBag()
    }
    
    func setUIWithViewModel(_ viewModel: UserViewModel) {
        
        userNameLabel.text = viewModel.getDisplayName()
        goldLabel.text = String(viewModel.getGoldBadgeCount())
        silverLabel.text = String(viewModel.getSilverBadgeCount())
        bronzeLabel.text = String(viewModel.getBronzeBadgeCount())
        
        viewModel
            .getIsLoadingImage()
            .drive(onNext: {[unowned self] in
                self.loadingActivityView.isHidden = !$0})
            .disposed(by: _disposeBag)
        
        viewModel.updateIsLoading(value: true)
        
        Observable.of(viewModel.getProfileUrl()!)
            .observeOn(MainScheduler.asyncInstance)
            .flatMapLatest { KingfisherManager
                                .shared
                                .rx
                .retrieveImage(with: $0,
                               options: [.backgroundDecode,
                                         .forceTransition,
                                         .processingQueue(.mainAsync)])}
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive (onNext: {[unowned self, unowned viewModel] in
                self.profileImageView.maskCircle(anyImage: $0)
                viewModel.updateIsLoading(value: false)
            })
            .disposed(by: _disposeBag)
    }
}
