//  ARIndoorNav
//
//  MenuOptionCell.swift
//  class - MenuOptionCell
//
//  Created by Bryan Ung on 7/1/20.
//  Copyright © 2021 Bryan Ung. All rights reserved.
//
//  This file serves as a model for a menu option within the hamburger menu.
//  This is used within MenuController.swift

import UIKit

class MenuOptionCell: UITableViewCell {

    // MARK: - Properties
    
    let iconImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.tintColor = AppThemeColorConstants.white
        return iv
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppThemeColorConstants.white
        label.font = UIFont.systemFont(ofSize: TableViewConstants.font)
        label.text = "Sample Text"
        
        return label
    }()
    
    // MARK: - Init
    
    /*/ init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
     Inits and styles the cell
     */
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = AppThemeColorConstants.blue
        self.selectionStyle = .default
        
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: TableViewConstants.leftPadding).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: TableViewConstants.height).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: TableViewConstants.width).isActive = true
        
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: TableViewConstants.leftPadding).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
