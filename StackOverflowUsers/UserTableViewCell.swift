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
    
    private let _disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUIWithViewModel(_ viewModel: UserViewModel) {
        
        profileImageView.layer.cornerRadius = 10
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.blue.cgColor
        
        userNameLabel.text = viewModel.getDisplayName()
        goldLabel.text = String(viewModel.getGoldBadgeCount())
        silverLabel.text = String(viewModel.getSilverBadgeCount())
        bronzeLabel.text = String(viewModel.getBronzeBadgeCount())
        
        self.profileImageView.kf.indicatorType = .activity
        Observable.of(viewModel.getProfileUrl())
            .observeOn(MainScheduler.instance)
            .bind(to: self.profileImageView.kf.rx.image(options: [.alsoPrefetchToMemory, .forceTransition]))
        .disposed(by: _disposeBag)
        
       //     .flatMapLatest { KingfisherManager.shared.rx.retrieveImage(with: $0) }
        //.observeOn(MainScheduler.instance)
        
    }
}
