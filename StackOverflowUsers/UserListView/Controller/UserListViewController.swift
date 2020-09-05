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
            .drive(onNext: {[unowned self] in
                self.loadingIndicator.isHidden = !$0})
            .disposed(by: _disposeBag)
        
    }
    
    func generateAlert() {
        let alert = UIAlertController(title: "Failure fetching data", message: "Most likely you're having internet connectivity issues.  Hit retry to try fetching again.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: {_ in
            self._viewModel.userFetch()
        }))

        self.present(alert, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        _viewModel
            .getDidError()
            .drive(onNext: {[unowned self] in
                if $0 {
                    self.generateAlert()
                }
            })
            .disposed(by: _disposeBag)
        
        _viewModel
            .getUserList()
            .drive(self.tableView.rx.items(cellIdentifier: "userCell",
                                           cellType: UserTableViewCell.self))
            {row, viewModel, cell in
                cell.setUIWithViewModel(viewModel)
                if row == self._viewModel.getCurrentUserCount()-5 {
                    self._viewModel.userFetch()
                }
        }
            .disposed(by: self._disposeBag)
    }
}

