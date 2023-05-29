//
//  LYCollectionViewCustomBehavior.swift
//  GitApp
//
//  Created by Kevin Dang on 3/7/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation

public class LYInsetBehavior: NSObject, LYCollectionViewBehavior {
    public var insets: UIEdgeInsets = .zero
    public var maxWidth: CGFloat = CGFloat.greatestFiniteMagnitude
    
    public func getAttributes(_ input: LYCollectionViewBehaviorInput!) -> LYCollectionViewBehaviorOutput! {
        let indexPath = IndexPath(item: 0, section: input.section)
        guard let delegate = input.collectionView.delegate as? LYCollectionViewDelegateLayout else {
            return nil
        }
        var size = input.collectionView.frame.size
        size.width -= insets.right + insets.left + input.collectionView.safeAreaInsets.left + input.collectionView.safeAreaInsets.right
        if size.width > maxWidth {
            size.width = maxWidth
        }
        
        var frame = CGRect()
        frame.origin.y = input.y
        frame.size = delegate.collectionView(input.collectionView, sizeThatFits: size, at: indexPath)
        frame.origin.x = round((input.collectionView.frame.size.width - frame.size.width) / 2.0)
        let attr = LYCollectionViewLayoutAttributes(forCellWith: indexPath)
        attr.frame = frame
        return LYCollectionViewBehaviorOutput(attributes: [attr], height: frame.size.height, scrollIndicatorInsets: .zero)
    }
    
    public func updateAttributes(_ attributes: [UICollectionViewLayoutAttributes]!, with input: LYCollectionViewBehaviorInput!) {
        // no-op
    }
}

// Permanently pins to the top, adjusting the scroll indicators. Only supports 1 item.
public class LYFixedTopBehavior: NSObject, LYCollectionViewBehavior {
    public func getAttributes(_ input: LYCollectionViewBehaviorInput!) -> LYCollectionViewBehaviorOutput! {
        let indexPath = IndexPath(item: 0, section: input.section)
        guard let delegate = input.collectionView.delegate as? LYCollectionViewDelegateLayout else {
            return nil
        }
        var frame = CGRect()
        frame.size = delegate.collectionView(input.collectionView, sizeThatFits: input.collectionView.frame.size, at: indexPath)
        let attr = LYCollectionViewLayoutAttributes(forCellWith: indexPath)
        attr.zIndex = 10000
        attr.frame = frame
        return LYCollectionViewBehaviorOutput(attributes: [attr], height: frame.size.height, scrollIndicatorInsets: UIEdgeInsets(top: frame.size.height, left: 0, bottom: 0, right: 0))
    }
    
    public func updateAttributes(_ attributes: [UICollectionViewLayoutAttributes]!, with input: LYCollectionViewBehaviorInput!) {
        let adjustedContentInset = input.collectionView.adjustedContentInset
        let contentOffset = input.collectionView.contentOffset
        attributes[0].frame.origin.y = contentOffset.y + adjustedContentInset.top
    }
}

public class LYFixedBottomBehavior: NSObject, LYCollectionViewBehavior {
    public var bottomOffset: CGFloat = 0
    public var insets: UIEdgeInsets = .zero
    public var maxWidth: CGFloat = CGFloat.greatestFiniteMagnitude
    public var includeBottomOffsetInHeight: Bool = false
    
    public func getAttributes(_ input: LYCollectionViewBehaviorInput!) -> LYCollectionViewBehaviorOutput! {
        let indexPath = IndexPath(item: 0, section: input.section)
        guard let delegate = input.collectionView.delegate as? LYCollectionViewDelegateLayout else {
            return nil
        }
        
        var size = input.collectionView.frame.size
        size.width -= insets.right + insets.left + input.collectionView.safeAreaInsets.left + input.collectionView.safeAreaInsets.right
        if size.width > maxWidth {
            size.width = maxWidth
        }
        
        bottomOffset = input.scrollIndicatorInsets.bottom
        var frame = CGRect()
        frame.size = delegate.collectionView(input.collectionView, sizeThatFits: size, at: indexPath)
        frame.origin.x = round((input.collectionView.frame.size.width - frame.size.width) / 2.0)
        let attr = LYCollectionViewLayoutAttributes(forCellWith: indexPath)
        attr.zIndex = 10000
        attr.frame = frame
        if includeBottomOffsetInHeight {
            bottomOffset -= 50
            attr.frame.size.height += 50
        }
        return LYCollectionViewBehaviorOutput(attributes: [attr], height: frame.size.height, scrollIndicatorInsets: UIEdgeInsets(top: 0, left: 0, bottom: frame.size.height, right: 0))
    }
    
    public func updateAttributes(_ attributes: [UICollectionViewLayoutAttributes]!, with input: LYCollectionViewBehaviorInput!) {
        let adjustedContentInset = input.collectionView.adjustedContentInset
        let contentInset = input.collectionView.contentInset // subtract any insets from add by IQKeyboardManager
        let contentOffset = input.collectionView.contentOffset
        attributes[0].frame.origin.y = contentOffset.y + input.collectionView.frame.size.height - adjustedContentInset.bottom + contentInset.bottom - attributes[0].frame.size.height - bottomOffset
    }
}

public class LYFixedBeneathBottomBehavior: NSObject, LYCollectionViewBehavior {
    public func getAttributes(_ input: LYCollectionViewBehaviorInput!) -> LYCollectionViewBehaviorOutput! {
        let indexPath = IndexPath(item: 0, section: input.section)
        guard let delegate = input.collectionView.delegate as? LYCollectionViewDelegateLayout else {
            return nil
        }
        var frame = CGRect()
        frame.size = delegate.collectionView(input.collectionView, sizeThatFits: input.collectionView.frame.size, at: indexPath)
        let attr = LYCollectionViewLayoutAttributes(forCellWith: indexPath)
        attr.zIndex = 10000
        attr.frame = frame
        return LYCollectionViewBehaviorOutput(attributes: [attr], height: 0, scrollIndicatorInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    public func updateAttributes(_ attributes: [UICollectionViewLayoutAttributes]!, with input: LYCollectionViewBehaviorInput!) {
        let adjustedContentInset = input.collectionView.adjustedContentInset
        let contentOffset = input.collectionView.contentOffset
        attributes[0].frame.origin.y = contentOffset.y + input.collectionView.frame.size.height - adjustedContentInset.bottom
    }
}
