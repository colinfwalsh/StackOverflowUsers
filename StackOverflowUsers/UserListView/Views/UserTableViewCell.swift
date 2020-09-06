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
    private let _viewModel: BehaviorRelay<UserViewModel?> = BehaviorRelay(value: nil)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        _disposeBag = DisposeBag()
        
    }
    
    override func layoutSubviews() {
        _viewModel
            .asDriver()
            .drive(onNext: {[unowned self] in
                if let vm = $0 {
                    self.setUIWithViewModel(vm)
                }
            })
            .disposed(by: _disposeBag)
    }
    
    func setViewModel(_ viewModel: UserViewModel) {
        _viewModel.accept(viewModel)
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
        
        let kfManager = KingfisherManager.shared
        Observable.of(viewModel.getProfileUrl()!)
            .flatMapLatest {[unowned kfManager] in
                kfManager
                    .rx
                    .retrieveImage(with: $0,
                                   options: [
                                    .forceTransition,
                    ])}
            .observeOn(MainScheduler.asyncInstance)
            .subscribe (onNext: {[unowned self, unowned viewModel] in
                self.profileImageView.maskCircle(anyImage: $0)
                viewModel.updateIsLoading(value: false)
            })
            .disposed(by: _disposeBag)
    }
}
