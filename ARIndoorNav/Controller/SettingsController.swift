//  ARIndoorNav
//
//  SettingsController.swift
//  Class - SettingsController.swift
//  Extensions - UITableViewDelegate, UITableViewDataSource
//
//  Created by Bryan Ung on 9/14/20.
//  Copyright © 2021 Bryan Ung. All rights reserved.
//
//  This class represents the settings controller within the app.
//  Currently not implemented yet.

import UIKit
private let reuseIdentifier = "SettingsCell"
class SettingsController: UIViewController {
    
    //MARK: - Properties
    
    var tableView: UITableView!
    
    //MARK: - Init
    
    override func viewDidLoad() {
        configureUI()
        
    }
    
    //MARK: - Configurations
    
    private func configureUI(){
        view.backgroundColor = AppThemeColorConstants.white
        configureNavigationBar()
        configureTableView()
    }
    private func configureNavigationBar(){
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = AppThemeColorConstants.blue
            appearance.titleTextAttributes = [.foregroundColor: AppThemeColorConstants.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: AppThemeColorConstants.white]
            
            self.navigationController?.navigationBar.tintColor = AppThemeColorConstants.white
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.compactAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            self.navigationController?.navigationBar.tintColor = AppThemeColorConstants.white
            self.navigationController?.navigationBar.barTintColor = AppThemeColorConstants.white
            self.navigationController?.navigationBar.isTranslucent = false
        }
        self.navigationController?.navigationBar.prefersLargeTitles = true //makes bigger
        self.navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "Settings"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleDismiss))
    }
    private func configureTableView(){
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.tableFooterView = UIView()
    }
    
    //MARK: - Handler
    
    @objc func handleDismiss(){
        self.dismiss(animated: true, completion: nil)
    }
}
extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        return cell
    }
    
    
}
