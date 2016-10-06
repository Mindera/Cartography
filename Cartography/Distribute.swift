//
//  Distribute.swift
//  Cartography
//
//  Created by Robert Böhnke on 17/02/15.
//  Copyright (c) 2015 Robert Böhnke. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    #else
    import AppKit
#endif

typealias Accumulator = ([NSLayoutConstraint], LayoutProxy)

@discardableResult private func reduce(_ first: LayoutProxy, rest: ArraySlice<LayoutProxy>, combine: (LayoutProxy, LayoutProxy) -> NSLayoutConstraint) -> [NSLayoutConstraint] {
    rest.last?.view.car_translatesAutoresizingMaskIntoConstraints = false

    return rest.reduce(([], first)) { (acc, current) -> Accumulator in
        let (constraints, previous) = acc

        return (constraints + [ combine(previous, current) ], current)
    }.0
}

private func reduce(_ first: LayoutProxy, rest: [LayoutProxy], combine: (LayoutProxy, LayoutProxy) -> NSLayoutConstraint) -> [NSLayoutConstraint] {
    return reduce(first, rest: rest[0..<rest.count], combine: combine)
}

private func reduce(_ views: [LayoutProxy], combine: (LayoutProxy, LayoutProxy) -> NSLayoutConstraint) -> [NSLayoutConstraint] {
    return reduce(views.first!, rest: views[1..<views.count], combine: combine)
}

/// Distributes multiple views horizontally.
///
/// All views passed to this function will have
/// their `translatesAutoresizingMaskIntoConstraints` properties set to `false`.
///
/// - parameter amount: The distance between the views.
/// - parameter views:  The views to distribute.
///
/// - returns: An array of `NSLayoutConstraint` instances.
///
@discardableResult public func distribute(by amount: CGFloat, horizontally first: LayoutProxy, _ rest: LayoutProxy...) -> [NSLayoutConstraint] {
    return reduce(first, rest: rest) { $0.trailing == $1.leading - amount }
}

public func distribute(by amount: CGFloat, horizontally views: [LayoutProxy]) -> [NSLayoutConstraint] {
    return reduce(views) { $0.trailing == $1.leading - amount }
}

/// Distributes multiple views horizontally from left to right.
///
/// All views passed to this function will have
/// their `translatesAutoresizingMaskIntoConstraints` properties set to `false`.
///
/// - parameter amount: The distance between the views.
/// - parameter views:  The views to distribute.
///
/// - returns: An array of `NSLayoutConstraint` instances.
///
@discardableResult public func distribute(by amount: CGFloat, leftToRight first: LayoutProxy, _ rest: LayoutProxy...) -> [NSLayoutConstraint] {
    return reduce(first, rest: rest) { $0.right == $1.left - amount  }
}

public func distribute(by amount: CGFloat, leftToRight views: [LayoutProxy]) -> [NSLayoutConstraint] {
    return reduce(views) { $0.right == $1.left - amount  }
}

/// Distributes multiple views vertically.
///
/// All views passed to this function will have
/// their `translatesAutoresizingMaskIntoConstraints` properties set to `false`.
///
/// - parameter amount: The distance between the views.
/// - parameter views:  The views to distribute.
///
/// - returns: An array of `NSLayoutConstraint` instances.
///
@discardableResult public func distribute(by amount: CGFloat, vertically first: LayoutProxy, _ rest: LayoutProxy...) -> [NSLayoutConstraint] {
    return reduce(first, rest: rest) { $0.bottom == $1.top - amount }
}

public func distribute(by amount: CGFloat, vertically views: [LayoutProxy]) -> [NSLayoutConstraint] {
    return reduce(views) { $0.bottom == $1.top - amount }
}

