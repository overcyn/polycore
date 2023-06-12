//
//  ContentView.swift
//  GitApp
//
//  Created by Kevin Dang on 3/31/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation

public enum ViewControllerVisibility {
    case notVisible
    case appearing
    case visible
    case disappearing
}

public class ContentViewController: UIViewController {
    public var contentView: ContentView = ContentView()
    public var visibility: ViewControllerVisibility = .notVisible
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.view = contentView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Assumes the view controller has already been added as a child.
    var _contentViewController: UIViewController? = nil
    public var contentViewController: UIViewController? {
        set {
            // We choose not to automaticallyForwardAppearanceMethods, because it does not send consistent appearance calls.
            // For example, if you switch modes between viewWillAppear and viewDidAppear calls, the removed view controller
            // will not get notified that is no longer visible.
            
            switch visibility {
            case .notVisible:
                break
            case .appearing:
                _contentViewController?.beginAppearanceTransition(false, animated: false)
                _contentViewController?.endAppearanceTransition()
            case .visible:
                _contentViewController?.beginAppearanceTransition(false, animated: false)
                _contentViewController?.endAppearanceTransition()
            case .disappearing:
                _contentViewController?.endAppearanceTransition()
            }
            _contentViewController = newValue
            contentView.content = _contentViewController?.view
            switch visibility {
            case .notVisible:
                break
            case .appearing:
                _contentViewController?.beginAppearanceTransition(true, animated: false)
            case .visible:
                _contentViewController?.beginAppearanceTransition(true, animated: false)
                _contentViewController?.endAppearanceTransition()
            case .disappearing:
                _contentViewController?.beginAppearanceTransition(true, animated: false)
                _contentViewController?.beginAppearanceTransition(false, animated: false)
            }
        }
        get {
            return _contentViewController
        }
    }
    
    // MARK: UIViewController
    
    public override func loadView() {
        view = contentView
    }
    
    public override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return false
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch visibility {
        case .notVisible:
            contentViewController?.beginAppearanceTransition(true, animated: animated)
        case .appearing:
            break
        case .visible:
            break
        case .disappearing:
            contentViewController?.beginAppearanceTransition(true, animated: animated)
        }
        visibility = .appearing
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        switch visibility {
        case .notVisible:
            contentViewController?.beginAppearanceTransition(true, animated: animated)
            contentViewController?.endAppearanceTransition()
        case .appearing:
            contentViewController?.endAppearanceTransition()
        case .visible:
            break
        case .disappearing:
            contentViewController?.beginAppearanceTransition(true, animated: animated)
            contentViewController?.endAppearanceTransition()
        }
        visibility = .visible
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        switch visibility {
        case .notVisible:
            break
        case .appearing:
            contentViewController?.beginAppearanceTransition(false, animated: animated)
        case .visible:
            contentViewController?.beginAppearanceTransition(false, animated: animated)
        case .disappearing:
            break
        }
        visibility = .disappearing
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        switch visibility {
        case .notVisible:
            break
        case .appearing:
            contentViewController?.beginAppearanceTransition(false, animated: animated)
            contentViewController?.endAppearanceTransition()
        case .visible:
            contentViewController?.beginAppearanceTransition(false, animated: animated)
            contentViewController?.endAppearanceTransition()
        case .disappearing:
            contentViewController?.endAppearanceTransition()
        }
        visibility = .notVisible
    }
}

public class ContentView: UIView, ThemeControllerObserver {
    public var contentSize: CGSize? = nil
    var _contentView: UIView? = nil
    
    public convenience init(content: UIView) {
        self.init(frame: CGRect.zero)
        self.content = content
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        ThemeController.shared.observers.append(WeakThemeControllerObserver(self))
        updateTheme()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var content: UIView? {
        set {
            _contentView?.removeFromSuperview()
            _contentView = newValue
            guard let v = newValue else {
                return
            }
            v.frame = bounds
            insertSubview(v, at: 0)
            _contentView?.translatesAutoresizingMaskIntoConstraints = false
            if let contentSize = contentSize {
                let c1 = _contentView?.widthAnchor.constraint(equalToConstant: contentSize.width)
                c1?.priority = .defaultLow
                c1?.isActive = true
                let c2 = _contentView?.heightAnchor.constraint(equalToConstant: contentSize.height)
                c2?.priority = .defaultLow
                c2?.isActive = true
                _contentView?.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor).isActive = true
                _contentView?.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor).isActive = true
                _contentView?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
                _contentView?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            } else {
                _contentView?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
                _contentView?.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
                _contentView?.topAnchor.constraint(equalTo: topAnchor).isActive = true
                _contentView?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            }
        }
        get {
            return _contentView
        }
    }
    
    // MARK: ThemeControllerObserver
    
    public func themeControllerOnUpdate(_: ThemeController) {
        updateTheme()
    }
    
    // MARK: Internal
    
    func updateTheme() {
        let theme = ThemeController.shared.theme()
        self.backgroundColor = UI.backgroundColor(theme)
    }
}
