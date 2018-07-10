//
//  ItemListVC.swift
//  SuperMarket
//
//  Created by Орлов Максим on 13.06.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import UIKit

protocol ItemListViewType: class {
    func showItemList(itemList: [Item])
    func showQtyAlert(item: Item)
}

class ItemListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var launchBefore = false
    private var itemList = [Item]()
    var oderId = 0
    private var presenter: ItemListPresenter?
    private let kItemListTableViewCellNib = UINib(nibName: "ItemListTableViewCell", bundle: nil)
    private let kItemListTableViewCellReuseIdentifier = "kItemListTableViewCellReuseIdentifier"
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(kItemListTableViewCellNib, forCellReuseIdentifier: kItemListTableViewCellReuseIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        presenter = ItemListPresenter(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.topItem?.title = "Магазин"
        presenter?.getItemList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        UserDefaults.standard.set(false, forKey: "launchedBefore")
    }
}

extension ItemListVC: ItemListViewType {
    func showItemList(itemList: [Item]) {
        self.itemList = itemList
        guard let launchBefore = presenter?.checkIfLauchedBefore() else { return }
        self.launchBefore = launchBefore
        tableView.reloadData()
    }
    
    func showQtyAlert(item: Item) {
        let ac = UIAlertController(title: "Укажите количество", message: nil, preferredStyle: .alert)
        ac.view.tintColor = barTintColor
        ac.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "1"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        let okAction = UIAlertAction(title: "Купить", style: .default, handler: { action in
            let difficultTextField = ac.textFields![0] as UITextField
            let qty = Int(difficultTextField.text!) ?? 1
            if qty != 0 {
                self.presenter?.addToCustomerItems(item: item, qty: qty)
            }
        })
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        ac.addAction(okAction)
        ac.addAction(cancelAction)
        self.present(ac, animated: true, completion: nil)
    }
}

extension ItemListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kItemListTableViewCellReuseIdentifier, for: indexPath) as! ItemListTableViewCell
        cell.configureSelf(withModel: itemList[indexPath.row])
        cell.itemPriceButton.addTarget(self, action: #selector(itemPriceButtonPressed), for: .touchUpInside)
        if launchBefore {
            cell.itemPriceButton.pulsate()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = itemList[indexPath.row]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let itemDetailVC = storyBoard.instantiateViewController(withIdentifier: "ItemDetailVC") as! ItemDetailVC
        itemDetailVC.itemId = item.id
        self.navigationController?.pushViewController(itemDetailVC, animated: true)
    }
    
    @objc func itemPriceButtonPressed(sender: UIButton!) {
        let cell = sender.superview?.superview as! ItemListTableViewCell
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let item = itemList[indexPath.row]
        presenter?.showQtyAlert(item: item)
    }
}
