//
//  UserTableViewCell.swift
//  StackOverflowUsers
//
//  Created by Colin Walsh on 9/4/20.
//  Copyright © 2020 Colin Walsh. All rights reserved.
//

import UIKit
import Kingfisher
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
        goldLabel.text = viewModel.getGoldBadgeCount()
        silverLabel.text = viewModel.getSilverBadgeCount()
        bronzeLabel.text = viewModel.getBronzeBadgeCount()
        
        viewModel
            .getIsLoadingImage()
            .drive(onNext: {[unowned self] in
                self.loadingActivityView.isHidden = !$0})
            .disposed(by: _disposeBag)
        
        viewModel.updateIsLoading(value: true)
        
        let kfManager = KingfisherManager.shared
        
        guard let url = viewModel.getProfileUrl()
            else {return}
        
        // Initially I was using RxKingfisher, but it was causing runtime errors, so I opted for the normal library instead
        kfManager
            .retrieveImage(with: url,
                           options: nil) {[unowned self] result in
                            
                            DispatchQueue.main.async {
                                viewModel.updateIsLoading(value: false)
                                switch result {
                                case .success(let value):
                                    self.profileImageView
                                        .maskCircle(anyImage: value.image)
                                case .failure(let error):
                                    self.profileImageView
                                        .maskCircle(anyImage: UIImage(systemName: "questionmark")!)
                                    print(error)
                                }
                            }
        }
    }
}
