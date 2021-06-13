//  ARIndoorNav
//
//  Protocols.swift
//  Protocols
//      - ViewControllerDelegate
//      - SearchControllerDelegate
//      - ManageMapsControllerDelegate
//      - ARScnViewDelegate
//      - loginControllerDelegate
//      - signUpControllerDelegate
//
//  Created by Bryan Ung on 6/30/20.
//  Copyright © 2021 Bryan Ung. All rights reserved.
//
//  This swift file houses the protocol definitions that classes within the app use

import Foundation
protocol ViewControllerDelegate {
    func handleMenuButtonToggle(forMenuOption menuOption: MenuOption?)
    func handleAddButton()
    func handleUndoButton()
    func handleEndButton()
}
protocol SearchControllerDelegate{
    func destinationFound(destination: String)
}
protocol ManageMapsControllerDelegate{
    func createCustomMapProcess()
}
protocol ARScnViewDelegate{
    func destinationReached()
    func toggleUndoButton(shouldShow: Bool)
    func toggleEndButton(shouldShow: Bool)
    func toggleSaveButton(shouldShow: Bool)
    func toggleAddButton(shouldShow: Bool)
}
protocol loginControllerDelegate {
    func handleLoginButton()
}
protocol signUpControllerDelegate {
    func handleSignUpButton(email: String, password: String)
    func handleReloadOfProfile()
}
