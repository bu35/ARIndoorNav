//  ARIndoorNav
//
//  MenuController.swift
//  Class - MenuController.swift
//  Extensions - UITableViewDelegate, UITableViewDataSource
//
//  Created by Bryan Ung on 6/30/20.
//  Copyright © 2021 Bryan Ung. All rights reserved.
//
//  Class is a view controller which has menu options: Profile, Maps, Settings. It is nested within the ContainerController.swift. This class calls its delegate(ContainerController) to handle actions within the menuController. The Menu is represented as a UITableView

import UIKit

class MenuController: UIViewController {
    
    //MARK: - Properties
    
    private let reuseIdentifier = "MenuOptionCell"
    var tableView: UITableView!
    //Delegate = ContainerController.swift
    var delegate: ViewControllerDelegate?
    
    //MARK: - Init

    /*/ viewDidLoad()
     Initialization of the MenuController.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    //MARK: - Configurations
    
    /*/ configureTableView()
     Configures the Table View and assigns its delegate to this class.
     */
    func configureTableView(){
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MenuOptionCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = AppThemeColorConstants.blue
        tableView.separatorStyle = .none
        tableView.rowHeight = TableViewConstants.rowHeight
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
/*/ Extension - UITableViewDelegate, UITableViewDataSource
 This extension allows the viewcontroller to handle the responsibility of the tableView.
 Handles the immediate action of a user clicking on a tableview cell and directs its delegate to do action. 
 */
extension MenuController: UITableViewDelegate, UITableViewDataSource{
    /*/ tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
     Implemetation of the function which handles the amount of cells within the table.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOption.allCases.count
    }
    /*/ tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
     Implemetation of the function which handles the view of each cell.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuOptionCell
        
        let menuOption = MenuOption(rawValue: indexPath.row)
        cell.descriptionLabel.text = menuOption?.description
        cell.iconImageView.image = menuOption?.image
        
        return cell
    }
    /*/ tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
     Implemetation of the function which handles the click action of a menu option.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuOption = MenuOption(rawValue: indexPath.row)
        delegate?.handleMenuButtonToggle(forMenuOption: menuOption)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
