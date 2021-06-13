//  ARIndoorNav
//
//  SearchController.swift
//  Class - SearchController.swift
//  Extensions - UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
//
//  Created by Bryan Ung on 4/30/20.
//  Copyright © 2021 Bryan Ung. All rights reserved.
//
//  This class is responsible for the search view controller which handles user queries searching for a destination.

import UIKit
private let reuseIdentifier = "cellid"

class SearchController: UIViewController{
    
    //MARK: - Properties
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    //List of destinations
    var destinationList = [String]()
    //Used for when querying results, set the display array as this
    var searchTargetArray = [String]()
    var searching = false
    
    //Delegate = ViewController.swift
    var delegate: SearchControllerDelegate?
    
    //MARK: - Init
    
    /*/ viewDidLoad()
     Init function which sends a network request for searchable destinations and populates the destinationList class value.
     Configures the appearance of the view.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDestinationList()
        configureUI()
    }
    /*/ dismissKeyboard()
     Sets the action for dismissing a keyboard.
     */
    @objc override func dismissKeyboard() {
        searchBarCancelButtonClicked(searchBar)
    }
    
    //MARK: - Helper Functions
    
    /*/ fetchDestinationList()
     This sends a network request to get a list of destinations within the database to the nodejs server. Once it is recieved it updates and reloads the tableView.
     */
    func fetchDestinationList(){
        let loadingIndicator = ViewController.getLoadingIndicator()
        present(loadingIndicator, animated: false, completion: {
            NetworkService.networkServiceSharedInstance.requestSearchableDestinations(URLConstants.destinationListRequest) {result in
                switch result{
                    case .failure(_):
                        DispatchQueue.main.async {
                            loadingIndicator.dismiss(animated: false, completion: {
                                self.alert(info: AlertConstants.serverRequestFailed)
                            })
                        }
                    case .success (let data):
                        DispatchQueue.main.async {
                            loadingIndicator.dismiss(animated: false, completion: {
                                //Refers to Formatter.decodeJSONDestinationList function within Formatter.swift in order to decode the query.
                                let jsonDecoded = Formatter.FormatterSharedInstance.decodeJSONDestinationList(JSONdata: data)
                                if jsonDecoded != nil {
                                    //Orders by capitialization
                                    self.destinationList = jsonDecoded!.map {$0.capitalized}
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                } else {
                                    self.alert(info: AlertConstants.serverRequestFailed)
                                }
                            })
                        }
                }
            }
        })
    }

    //MARK: - Configuration
    
    /*/ configureUI()
     configures the appearance of the view controller.
     */
    func configureUI(){
        view.backgroundColor = AppThemeColorConstants.white
        //configureStatusBar()
        self.hideKeyboardWhenTappedAround()
        configureTableView()
        configureNavigationBar()
        configureSearchBar()
    }
    /*/ configureTableView()
     configures the appearance of the tableview. Registers the UITableView's delegate and datasource to this class.
     */
    func configureTableView(){
        view.addSubview(tableView)
        tableView.backgroundColor = AppThemeColorConstants.white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    /*/ configureNavigationBar()
     configures the appearance of the navigation bar.
     */
    func configureNavigationBar(){
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = AppThemeColorConstants.blue
            appearance.titleTextAttributes = [.foregroundColor: AppThemeColorConstants.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: AppThemeColorConstants.white]
            
            self.navigationController?.navigationBar.tintColor = AppThemeColorConstants.white
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.compactAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            self.navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(backFunction))
        }
//        } else {
//            self.navigationController?.navigationBar.tintColor = AppThemeColorConstants.white
//            self.navigationController?.navigationBar.barTintColor = AppThemeColorConstants.white
//            self.navigationController?.navigationBar.isTranslucent = false
//        }
//        self.navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(backFunction))
    }
    /*/ configureSearchBar()
     configures the searchBar, sets its delegate to this class.
     */
    func configureSearchBar(){
        searchBar.delegate = self //allows handling of search bar queries
        searchBar.sizeToFit() //Allows it to fit nicely in nav bar
        showSearchButtonIcon(shouldShow: true)
    }
    
    //MARK: - Handler

    /*/ backFunction()
     handles the back button which dismisses the view controller from the view stack.
     */
    @objc func backFunction(){
        //removes view from stack
        self.dismiss(animated: true, completion: nil)
    }
    /*/ searchFunction()
     handles the search button which shows a searchbar where user enters queries.
     */
    @objc func searchFunction() {
        toggleSearch(shouldShow: true)
        searchBar.becomeFirstResponder()
    }
    /*/ toggleSearch(shouldShow: Bool)
     handles whether the search bar should appear and whether or not the search button icon is showns.
     
     @param: shouldShow - Bool - boolean value determining if the user is searching or not
     */
    func toggleSearch(shouldShow: Bool){
        //only shows when user is not searching.
        showSearchButtonIcon(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        //Removes the titleView within navigationBar if the user is searching
        navigationItem.titleView = shouldShow ? searchBar: nil
    }
    /*/ showSearchButtonIcon(shouldShow: Bool)
     handles whether the search button icon is shown.
     
     @param: shouldShow - Bool - boolean value determining if the user is searching or not
     */
    func showSearchButtonIcon(shouldShow: Bool){
        if shouldShow{
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchFunction))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
}
/*/ Extension - UISearchBarDelegate
 This extension allows the viewcontroller to handle the responsibility of the searchbar.
 Handles the actions related to interacting with the searchbar.
 */
extension SearchController: UISearchBarDelegate{
    /*/ searchBarCancelButtonClicked(_ searchBar: UISearchBar)
     implementation of function which does the necessary UI updates when the searchBar cancel button is clicked.
     */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        toggleSearch(shouldShow: false)
        searching = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    /*/ searchBarSearchButtonClicked(_ searchBar: UISearchBar)
     implementation of function which does the necessary UI updates when the searchBar Searchh button is clicked.
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    /*/ searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
     implementation of function which does the necessary UI updates when the searchBar text changed.
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = true
        searchTargetArray = searchText.isEmpty ? destinationList : destinationList.filter({
            (result) -> Bool in
            result.range(of: searchText, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
}
/*/ Extension - UITableViewDataSource
 This extension allows the viewcontroller to handle the responsibility as the TableView's data source.
 */
extension SearchController: UITableViewDataSource{
    /*/ tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
     implementation of function which handles the number of cells inside the tableview.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchTargetArray.count
        } else {
            return destinationList.count
        }
    }
    /*/ tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
     implementation of function which handles the height constant for each row.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    /*/ tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     implementation of function which handles the contents of each cell.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if searching {
            cell.textLabel?.text = searchTargetArray[indexPath.row]
        } else {
            cell.textLabel?.text = destinationList[indexPath.row]
        }
        cell.backgroundColor = AppThemeColorConstants.white
        cell.textLabel?.textColor = AppThemeColorConstants.blue
        return cell
    }
}
/*/ Extension - UITableViewDelegate
 This extension allows the viewcontroller to handle the responsibility as the TableView's actions
 */
extension SearchController: UITableViewDelegate{
    /*/ tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
     implementation of function which handles the action of selecting a row (destination).
     The delegate is called to handle the necessary actions of updating the state to navigating. 
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dest: String?
        if searching {
            dest = searchTargetArray[indexPath.row]
        } else {
            dest = destinationList[indexPath.row]
        }
        searchBar.resignFirstResponder()
        delegate!.destinationFound(destination: dest!)
        self.dismiss(animated: true, completion: nil)
    }
}
