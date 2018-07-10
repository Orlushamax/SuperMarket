//
//  ProfileVC.swift
//  SuperMarket
//
//  Created by Орлов Максим on 14.06.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import UIKit

protocol ProfileViewType: class {
    func showCustomer(customer: Customer, orderLineList: [OrderLine], orderSum: Int)
    func showChageQtyAlert(orderLine: OrderLine, indexPath: IndexPath)
    func updateFooterView(orderSum: Int)
}

class ProfileVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var customer: Customer?
    private var orderLineList = [OrderLine]()
    private var presenter: ProfilePresenter?
    private var orderSum = 0
    private let totalPrice = UILabel()
    private let kProfileTableViewCellNib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
    private let kProfileTableViewCellReuseIdentifier = "kProfileTableViewCellReuseIdentifier"
    private let kBucketTableViewCellNib = UINib(nibName: "BucketTableViewCell", bundle: nil)
    private let kBucketTableViewCellReuseIdentifier = "kBucketTableViewCellReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.topItem?.title = "Профиль"
        self.navigationController?.navigationBar.isTranslucent = false
        presenter?.getCustomerInfo()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(kProfileTableViewCellNib, forCellReuseIdentifier: kProfileTableViewCellReuseIdentifier)
        tableView.register(kBucketTableViewCellNib, forCellReuseIdentifier: kBucketTableViewCellReuseIdentifier)
    }
    
    private func setupView() {
        totalPrice.backgroundColor = barTintColor
        totalPrice.textColor = .white
        totalPrice.textAlignment = .center
        presenter = ProfilePresenter(view: self)
    }
}

extension ProfileVC: ProfileViewType {
    
    func showChageQtyAlert(orderLine: OrderLine, indexPath: IndexPath) {
        let ac = UIAlertController(title: "Укажите количество", message: nil, preferredStyle: .alert)
        ac.view.tintColor = barTintColor
        ac.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "1"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        let okAction = UIAlertAction(title: "Изменить", style: .default, handler: { action in
            let difficultTextField = ac.textFields![0] as UITextField
            let qty = Int(difficultTextField.text!) ?? 1
            if qty != 0 {
                self.presenter?.changeOrderLineQty(orderLine: orderLine, qty: qty)
            } else {
                self.presenter?.deleteOrderLine(orderLine: orderLine)
                self.orderLineList.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .left)
                self.presenter?.updateTotalPrice(orderLineList: self.orderLineList)
            }
        })
        let deleteAction = UIAlertAction(title: "Удалить из списка", style: .destructive, handler: {action in
            self.presenter?.deleteOrderLine(orderLine: orderLine)
            self.orderLineList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .left)
            self.presenter?.updateTotalPrice(orderLineList: self.orderLineList)
        })
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        ac.addAction(okAction)
        ac.addAction(cancelAction)
        ac.addAction(deleteAction)
        self.present(ac, animated: true, completion: nil)
    }
    
    func showCustomer(customer: Customer, orderLineList: [OrderLine], orderSum: Int) {
        self.customer = customer
        self.orderLineList = orderLineList
        self.orderSum = orderSum
        self.totalPrice.text = "Всего товаров на сумму: \(self.orderSum) руб."
        tableView.reloadData()
    }
    
    func updateFooterView(orderSum: Int) { //MARK: Обновляем футер 
        self.orderSum = orderSum
        self.totalPrice.text = "Всего товаров на сумму: \(self.orderSum) руб."
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return orderLineList.count
        }
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: kProfileTableViewCellReuseIdentifier, for: indexPath) as! ProfileTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: kBucketTableViewCellReuseIdentifier, for: indexPath) as! BucketTableViewCell
            let orderLine = orderLineList[indexPath.row]
            cell.configureSelf(withModel: orderLine)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let orderLine = orderLineList[indexPath.row]
        presenter?.showChangeQtyAlert(orederLine: orderLine, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return totalPrice
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            if orderLineList.isEmpty {
                return 0
            } else {
                return 40
            }
        }
    }
}

