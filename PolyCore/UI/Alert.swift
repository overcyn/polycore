//
//  Alert.swift
//  PolyGit
//
//  Created by Kevin Dang on 4/27/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation

extension UI {
    public static func errorAlert(error: Error, completion: (() -> ())?) -> Alert {
        let button = AlertButton(title: NSLocalizedString("OK", comment: ""), style: .default, action: BlockAction({ _ in
            completion?()
        }))
        return Alert(title: NSLocalizedString("Error", comment: ""), subtitle: error.localizedDescription, buttons: [button])
    }
}
