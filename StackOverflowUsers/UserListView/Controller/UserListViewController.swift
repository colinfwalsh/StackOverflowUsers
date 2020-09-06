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
        
        setupSubscriptions()
    }
    
    func setupSubscriptions() {
        _viewModel
            .getIsLoading()
            .drive(onNext: {[unowned self] in
                self.loadingIndicator.isHidden = !$0})
            .disposed(by: _disposeBag)
        
        _viewModel
            .getErrorMessage()
            .drive(onNext: {[unowned self] in
                if let message = $0 {
                    self.generateAlert(with: message.error_message)
                }
            })
            .disposed(by: _disposeBag)
        
        DispatchQueue.main.async {
            self._viewModel
                .getUserList()
                .bind(to: self.tableView.rx.items(cellIdentifier: "userCell",
                                                  cellType: UserTableViewCell.self))
                {row, viewModel, cell in
                    cell.setUIWithViewModel(viewModel)
                    if row == self._viewModel.getCurrentUserCount()-1 {
                        self._viewModel.userFetch()
                    }
            }
            .disposed(by: self._disposeBag)
        }
    }
    
    func generateAlert(with message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message.capitalized,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Retry",
                                      style: .default,
                                      handler: {[unowned self] _ in
                                        self._viewModel.userFetch()}))
        
        self.present(alert, animated: true)
    }
}

