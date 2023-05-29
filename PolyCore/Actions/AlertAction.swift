//
//  Alert.swift
//  GitApp
//
//  Created by Kevin Dang on 1/22/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation

public struct AlertTaskAction<T: Task, R>: Action where T.TaskResult == R {
    public let task: T
    public let taskQueue: TaskQueue
    public let alert: ConfirmAlert
    public let completion: ((Result<R, Error>) -> ())?
    
    public init(task: T, taskQueue: TaskQueue, alert: ConfirmAlert, completion: ((Result<R, Error>) -> ())? = nil) {
        self.task = task
        self.taskQueue = taskQueue
        self.alert = alert
        self.completion = completion
    }
    
    public func perform(with viewController: UIViewController) {
        var a = alert
        a.confirmFunc = {
            _ = self.taskQueue.add(self.task, progress: nil, completion: { result in
                switch result {
                case .success:
                    self.completion?(result)
                case .failure(let error):
                    ShowErrorAction_NoCancelled(error: error, completion: {
                        self.completion?(result)
                    }).perform(with: viewController)
                }
            })
        }
        a.cancelFunc = {
            self.completion?(.failure(StringError("User cancelled")))
        }
        a.perform(with: viewController)
    }
}

public struct AlertButton {
    public var title: String?
    public var style: UIAlertAction.Style = .default
    public var action: Action?
    
    public init(title: String? = nil, style: UIAlertAction.Style = .default, action: Action? = nil) {
        self.title = title
        self.style = style
        self.action = action
    }
}

public struct Alert: Action {
    public var title: String?
    public var subtitle: String?
    public var buttons: [AlertButton] = []
    public var preferredButtonIndex: Int?
    public var presentOverKeyboard: Bool = false
    
    public init(title: String? = nil, subtitle: String? = nil, buttons: [AlertButton] = [], preferredButtonIndex: Int? = nil, presentOverKeyboard: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.buttons = buttons
        self.preferredButtonIndex = preferredButtonIndex
        self.presentOverKeyboard = presentOverKeyboard
    }
    
    public func perform(with viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        for idx in 0..<buttons.count {
            let button = buttons[idx]
            let action = UIAlertAction(title: button.title, style: button.style, handler: {_ in
                button.action?.perform(with: viewController)
            })
            alert.addAction(action)
            if idx == preferredButtonIndex {
                alert.preferredAction = action
            }
        }
        if presentOverKeyboard, let keyboardWindow = UIApplication.shared.windows.last, keyboardWindow.windowLevel.rawValue == 10_000_001.0 {
            // If keyboard is open, present on that window. https://stackoverflow.com/a/47068284/14112868
            keyboardWindow.rootViewController?.present(alert, animated: true, completion: nil)
        } else {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}

public struct ConfirmAlert: Action {
    public var title: String?
    public var subtitle: String?
    public var confirmButtonTitle: String?
    public var destructive: Bool
    public var confirmFunc: (() -> ())?
    public var cancelFunc: (() -> ())?
    
    public init(title: String? = nil, subtitle: String? = nil, confirmButtonTitle: String? = nil, destructive: Bool = false, confirmFunc: (() -> ())? = nil, cancelFunc: (() -> ())? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.confirmButtonTitle = confirmButtonTitle
        self.destructive = destructive
        self.confirmFunc = confirmFunc
        self.cancelFunc = cancelFunc
    }
    
    public func perform(with viewController: UIViewController) {
        var confirmButton = AlertButton()
        confirmButton.title = confirmButtonTitle
        confirmButton.style = destructive ? .destructive: .default
        confirmButton.action = BlockAction({_ in self.confirmFunc?()})
        
        var cancelButton = AlertButton()
        cancelButton.title = NSLocalizedString("Cancel", comment: "")
        cancelButton.style = .cancel
        cancelButton.action = BlockAction({_ in self.cancelFunc?()})
        
        var alert = Alert()
        alert.title = title
        alert.subtitle = subtitle
        alert.buttons = [confirmButton, cancelButton]
        alert.perform(with: viewController)
    }
}

public struct ActionSheetAlert: Action, ViewAction, BarButtonAction {
    public var title: String?
    public var subtitle: String?
    public var actions: [(String, Action?)]
    public var cancelFunc: (() -> ())?
    public var permittedArrowDirections: UIPopoverArrowDirection = .any
    
    public init(title: String? = nil, subtitle: String? = nil, actions: [(String, Action?)], cancelFunc: (() -> ())? = nil, permittedArrowDirections: UIPopoverArrowDirection = .any) {
        self.title = title
        self.subtitle = subtitle
        self.actions = actions
        self.cancelFunc = cancelFunc
        self.permittedArrowDirections = permittedArrowDirections
    }
    
    public func perform(with vc: UIViewController) {
        perform(with: vc, barButtonItem: nil, view: nil)
    }
    
    public func perform(with vc: UIViewController, barButtonItem: UIBarButtonItem) {
        perform(with: vc, barButtonItem: barButtonItem, view: nil)
    }
    
    public func perform(with vc: UIViewController, view: UIView) {
        perform(with: vc, barButtonItem: nil, view: view)
    }
    
    public func perform(with vc: UIViewController, barButtonItem: UIBarButtonItem?, view: UIView?) {
        guard view != nil || barButtonItem != nil else {
            ShowErrorAction_NoCancelled(error: StringError("No target view to display popover"), completion: nil).perform(with: vc)
            return
        }
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .actionSheet)
        for i in actions {
            let alertAction = UIAlertAction(title: i.0, style: .default, handler: { _ in
                let action = i.1
                if let viewAction = action as? ViewAction, let view = view {
                    viewAction.perform(with: vc, view: view)
                } else if let barButtonAction = action as? BarButtonAction, let barButtonItem = barButtonItem {
                    barButtonAction.perform(with: vc, barButtonItem: barButtonItem)
                } else {
                    action?.perform(with: vc)
                }
            })
            alertAction.isEnabled = i.1 != nil
            alert.addAction(alertAction)
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in self.cancelFunc?()}))
        alert.popoverPresentationController?.sourceView = view
        alert.popoverPresentationController?.barButtonItem = barButtonItem
        alert.popoverPresentationController?.permittedArrowDirections = permittedArrowDirections
        vc.present(alert, animated: true, completion: nil)
    }
}

public struct TextInputAlert: Action {
    public var title: String?
    public var subtitle: String?
    public var confirmButtonTitle: String?
    public var defaultValue: String?
    public var placeholder: String?
    public var secureTextEntry: Bool = false
    public var confirmFunc: ((String) -> ())?
    public var cancelFunc: (() -> ())?
    
    public init(title: String? = nil, subtitle: String? = nil, confirmButtonTitle: String? = nil, defaultValue: String? = nil, placeholder: String? = nil, secureTextEntry: Bool = false, confirmFunc: ((String) -> ())? = nil, cancelFunc: (() -> ())? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.confirmButtonTitle = confirmButtonTitle
        self.defaultValue = defaultValue
        self.placeholder = placeholder
        self.secureTextEntry = secureTextEntry
        self.confirmFunc = confirmFunc
        self.cancelFunc = cancelFunc
    }

    public func perform(with viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = self.placeholder
            textField.text = defaultValue
            textField.isSecureTextEntry = secureTextEntry
        })
        let confirmAction = UIAlertAction(title: confirmButtonTitle ?? NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
            if let text = alert.textFields?.first?.text {
                self.confirmFunc?(text)
            } else {
                self.cancelFunc?()
            }
        })
        alert.addAction(confirmAction)
        let action = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
            self.cancelFunc?()
        })
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
}

public struct TextInput2Alert: Action {
    public var title: String?
    public var subtitle: String?
    public var confirmButtonTitle: String
    public var placeholder: String?
    public var secureTextEntry: Bool = false
    public var placeholder2: String?
    public var secureTextEntry2: Bool = false
    public var confirmFunc: ((String, String) -> ())?
    public var cancelFunc: (() -> ())?
    
    public init(title: String? = nil, subtitle: String? = nil, confirmButtonTitle: String, placeholder: String? = nil, secureTextEntry: Bool = false, placeholder2: String? = nil, secureTextEntry2: Bool = false, confirmFunc: ((String, String) -> ())? = nil, cancelFunc: (() -> ())? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.confirmButtonTitle = confirmButtonTitle
        self.placeholder = placeholder
        self.secureTextEntry = secureTextEntry
        self.placeholder2 = placeholder2
        self.secureTextEntry2 = secureTextEntry2
        self.confirmFunc = confirmFunc
        self.cancelFunc = cancelFunc
    }


    public func perform(with viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = self.placeholder
            textField.isSecureTextEntry = self.secureTextEntry
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = self.placeholder2
            textField.isSecureTextEntry = self.secureTextEntry2
        })
        let confirmAction = UIAlertAction(title: confirmButtonTitle, style: .default, handler: { _ in
            if let text = alert.textFields?.first?.text, let text2 = alert.textFields?[safe: 1]?.text {
                self.confirmFunc?(text, text2)
            } else {
                self.cancelFunc?()
            }
        })
        alert.addAction(confirmAction)
        let action = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
            self.cancelFunc?()
        })
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
}

// Internal copy of ShowErrorAction
struct ShowErrorAction_NoCancelled: Action {
    var error: Error
    var completion: (() -> ())?
    func perform(with viewController: UIViewController) {
//        if case CustomError.cancelled = error {
//            self.completion?()
//            return
//        }
        let button = AlertButton(title: NSLocalizedString("OK", comment: ""), style: .default, action: BlockAction({ _ in
            self.completion?()
        }))
        Alert(title: NSLocalizedString("Error", comment: ""), subtitle: error.localizedDescription, buttons: [button]).perform(with: viewController)
    }
}
