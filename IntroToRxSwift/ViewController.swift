//
//  ViewController.swift
//  IntroToRxSwift
//
//  Created by hideto c. on 2021/06/08.
//

import UIKit
import RxSwift
import RxCocoa

struct Product {
    let imageName: String
    let title: String
}

struct ProductViewModel {
    var items = PublishSubject<[Product]>()
    
    func fetchItems() {
        let products = [
            Product(imageName: "house", title: "Home"),
            Product(imageName: "gear", title: "Settings"),
            Product(imageName: "person.circle", title: "Profile"),
            Product(imageName: "airplane", title: "Flights"),
            Product(imageName: "bell", title: "Activity")
        ]
        
        items.onNext(products)
        items.onCompleted()
    }
}

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var viewModel = ProductViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        bindTableData()
    }

    func bindTableData() {
        // Bind items to table
        viewModel.items.bind(to: tableView.rx.items(
                                cellIdentifier: "cell",
                                cellType: UITableViewCell.self)
        ) { row, model, cell in
            cell.textLabel?.text = model.title
            cell.imageView?.image = UIImage(systemName: model.imageName)
        }
        .disposed(by: disposeBag)
        
        // Bind a model selected handler
        tableView.rx.modelSelected(Product.self).bind { product in
            print(product.title)
        }
        .disposed(by: disposeBag)
        
        // fetch items
        viewModel.fetchItems()
    }
}

