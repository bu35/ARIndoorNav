//  ARIndoorNav
//
//  MapOptionCell.swift
//  class - MapOptionCell
//
//  Created by Bryan Ung on 7/7/20.
//  Copyright © 2021 Bryan Ung. All rights reserved.
//
//  This file serves as a model for a custom map cell option within the ManageMapsController

import UIKit

class MapOptionCell: UITableViewCell {

    //MARK: - Properties
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.tintColor = AppThemeColorConstants.blue
        return iv
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppThemeColorConstants.blue
        label.font = UIFont.systemFont(ofSize: mapViewConstants.font)
        label.text = "Sample Text"
        return label
    }()
    
    //MARK: - Init
    
    /*/ init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
     inits and styles the cell
     */
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = AppThemeColorConstants.white
        self.selectionStyle = .default
        
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: TableViewConstants.leftPadding).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: mapViewConstants.height).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: mapViewConstants.width).isActive = true
        
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: mapViewConstants.leftDescriptionPadding).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
