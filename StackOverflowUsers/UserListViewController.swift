//
//  ViewController.swift
//  StackOverflowUsers
//
//  Created by Colin Walsh on 9/4/20.
//  Copyright © 2020 Colin Walsh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private let _disposeBag = DisposeBag()
    private let _viewModel = UserListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _viewModel
            .getIsLoading()
            .drive(onNext: { [unowned self] in
                self.loadingIndicator.isHidden = !$0
            }).disposed(by: _disposeBag)
        
        DispatchQueue.main.async {
            self._viewModel
                .getUserList()
                .drive(self.tableView.rx.items(cellIdentifier: "userCell", cellType: UserTableViewCell.self)) {
                    row, viewModel, cell in
                    cell.setUIWithViewModel(viewModel)
            }.disposed(by: self._disposeBag)
        }
    }
}

