//  ARIndoorNav
//
//  MenuOption.swift
//  enum - MenuOption
//
//  Created by Bryan Ung on 7/1/20.
//  Copyright © 2021 Bryan Ung. All rights reserved.
//
//  This file serves as a model for a MenuOption on the hamburger menu
import UIKit
enum MenuOption: Int, CaseIterable, CustomStringConvertible {
    
    case Profile
    //case Inbox
    //case Notifications
    case Maps
    case Settings
    
    var description: String {
        switch self {
            case .Profile: return "Profile"
            //case .Inbox: return "Inbox"
            //case .Notifications: return "Notifications"
            case .Maps: return "Manage Maps"
            case .Settings: return "Settings"
        }
    }
    
    var image: UIImage {
        switch self {
            case .Profile: return UIImage(systemName: "person") ?? UIImage()
            //case .Inbox: return UIImage(systemName: "envelope.open.fill") ?? UIImage()
            //case .Notifications: return UIImage(systemName: "exclamationmark.square") ?? UIImage()
            case .Maps: return UIImage(systemName: "map.fill") ?? UIImage()
            case .Settings: return UIImage(systemName: "gear") ?? UIImage()
        }
    }
}
