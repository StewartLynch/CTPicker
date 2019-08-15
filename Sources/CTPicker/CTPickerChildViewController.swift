//
//  ACViewController.swift
//  AutoCompletModal
//
//  Created by Stewart Lynch on 8/2/19.
//  Copyright © 2019 Stewart Lynch. All rights reserved.
//

import UIKit
@available(iOS 12.0, *)
public protocol CTPickerChildDelegate: AnyObject {
    func setValue(value:String, new:Bool)
    func cancel()
}

@available(iOS 12.0, *)
public class CTPickerChildViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    weak var delegate:CTPickerChildDelegate?
    var items:[String] = []
    // Optional Navbar Colors
    var navBarBarTintColor:UIColor?
    var navBarTintColor:UIColor?
    var actionTintColor:UIColor?
    
    var originalItemsList:[String] = []
    var searchTitle:String?
    var currentItem:String?
    var isAddEnabled:Bool!
    
    var tableView:UITableView = {
        let tblView = UITableView()
        return tblView
    }()
    
    var txtSearchBar:UITextField = {
        let txtField = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10.0, height: txtField.frame.size.height))
        txtField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        txtField.leftView = paddingView
        txtField.leftViewMode = .always
        txtField.placeholder = "Filter by entering text..."
        txtField.font = UIFont.systemFont(ofSize: 17)
        txtField.clearButtonMode = .whileEditing
        txtField.layer.cornerRadius = 10
        return txtField
    }()
    
    var instrLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.text = "Tap on a line to select, or tap '+' to add a new entry."
        label.numberOfLines = 2
        return label
    }()
    
    var tableFooterView: UIView!
    
    var noValuesFooter:UIView = {
        let footerView = UIView()
        if #available(iOS 13, *) {
            footerView.backgroundColor = .systemBackground
        } else {
            
            footerView.backgroundColor = .white
        }
        footerView.clipsToBounds = false
        footerView.layer.cornerRadius = 10
        footerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return footerView
    }()
    
    var filterView:UIView = {
        let view = UIView()
        if #available(iOS 13, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        return view
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        setupView()
        tableView.delegate = self
        tableView.dataSource = self
        txtSearchBar.delegate = self
        txtSearchBar.addTarget(self, action: #selector(searchRecords(_ :)), for: .editingChanged)
        items = items.sorted()
        originalItemsList = items
        setupNavBar()
        if let currentItem = currentItem {
            txtSearchBar.text = currentItem
            searchRecords(txtSearchBar)
        }
        txtSearchBar.becomeFirstResponder()
    }
    
    
    // MARK: - NavBar Stuff
    fileprivate func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        let navigationBarAppearance = self.navigationController!.navigationBar
        navigationBarAppearance.isTranslucent = false
        if let navBarTintColor = navBarTintColor {
            navigationBarAppearance.tintColor = navBarTintColor
        }
        if let navBarBarTintColor = navBarBarTintColor {
            navigationBarAppearance.barTintColor = navBarBarTintColor
        }
        
        self.navigationItem.title = searchTitle
        navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel)), animated: true)
        
        if isAddEnabled {
            self.navigationItem.title = searchTitle
            navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem)), animated: true)
        }
    }
    
    // MARK: - ViewSetup
    fileprivate func setupView() {
        view.backgroundColor = .clear
        tableView.backgroundColor = .clear
        filterView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterView)
        filterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        filterView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        filterView.addSubview(instrLabel)
        filterView.addSubview(txtSearchBar)
        
        instrLabel.translatesAutoresizingMaskIntoConstraints = false
        instrLabel.topAnchor.constraint(equalTo: filterView.topAnchor,constant: 10).isActive = true
        instrLabel.leadingAnchor.constraint(equalTo: filterView.leadingAnchor,constant: 10).isActive = true
        instrLabel.trailingAnchor.constraint(equalTo: filterView.trailingAnchor,constant: -10).isActive = true
        
        txtSearchBar.translatesAutoresizingMaskIntoConstraints = false
        txtSearchBar.topAnchor.constraint(equalTo: instrLabel.bottomAnchor,constant: 10).isActive = true
        txtSearchBar.leadingAnchor.constraint(equalTo: filterView.leadingAnchor,constant: 10).isActive = true
        txtSearchBar.trailingAnchor.constraint(equalTo: filterView.trailingAnchor,constant: -10).isActive = true
        txtSearchBar.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(noValuesFooter)
        noValuesFooter.translatesAutoresizingMaskIntoConstraints = false
        noValuesFooter.topAnchor.constraint(equalTo: filterView.bottomAnchor).isActive = true
        noValuesFooter.leadingAnchor.constraint(equalTo: filterView.leadingAnchor).isActive = true
        noValuesFooter.trailingAnchor.constraint(equalTo: filterView.trailingAnchor).isActive = true
        noValuesFooter.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: txtSearchBar.bottomAnchor,constant: 10).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    fileprivate func buildFooterView(numRows: Int) {
        if numRows > 0 {
            tableView.isHidden = false
            tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
            tableFooterView.clipsToBounds = false
            tableFooterView.layer.cornerRadius = 10
            tableFooterView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
             if #available(iOS 13, *) {
                tableFooterView.backgroundColor = .systemBackground
             } else {
                tableFooterView.backgroundColor = UIColor.white
            }
            tableView.tableFooterView = tableFooterView
            noValuesFooter.isHidden = true
        } else {
            tableView.tableFooterView = UIView()
            tableView.isHidden = true
            noValuesFooter.isHidden = false
        }
    }
    
    @objc fileprivate func cancel() {
        delegate?.cancel()
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Enter new \(searchTitle ?? "item")", message: nil, preferredStyle: .alert)
        ac.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.keyboardType = UIKeyboardType.default
            textField.autocapitalizationType = .words
            if self.txtSearchBar.text != "" {
                textField.text = self.txtSearchBar.text
            }
        })
        
        let submitAction = UIAlertAction(title: "Add", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            if answer.text != "" {
                self.delegate?.setValue(value: answer.text!, new: true)
            }
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(submitAction)
        if let actionTintColor = actionTintColor {
            ac.view.tintColor = actionTintColor
        }
        present(ac, animated: true)
        
    }
    
    //MARK:- UITextFieldDelegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtSearchBar.resignFirstResponder()
        return true
    }
    
    // MARK: - Search Records
    @objc func searchRecords(_ textField: UITextField) {
        self.items.removeAll()
        if textField.text?.count != 0 {
            for item in originalItemsList {
                if let itemToSearch = textField.text{
                    let range = item.lowercased().range(of: itemToSearch, options: .caseInsensitive, range: nil, locale: nil)
                    if range != nil {
                        self.items.append(item)
                    }
                }
            }
        } else {
            for item in originalItemsList {
                items.append(item)
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - TableView Stuff
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        buildFooterView(numRows: items.count)
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel!.text = items[indexPath.row]
        if #available(iOS 13, *) {
            cell.backgroundColor = .systemBackground
            cell.textLabel?.textColor = .label
        } else {
            cell.backgroundColor = .white
            cell.textLabel?.textColor = .black
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.setValue(value: items[indexPath.row], new: false)
    }
}

