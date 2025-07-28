//
//  Spacing.swift
//  Grain
//
//  Created by Vlad Antonov on 28.07.2025.
//

import SwiftUI

public protocol Spacing {
    init(_ value: Double)
}

extension Int: Spacing {}
extension UInt: Spacing {}
extension Float: Spacing {}
extension Double: Spacing {}
extension CGFloat: Spacing {}

extension Spacing {
    /// 0
    static var none: Self { Self(0) }
    /// 4
    static var xs: Self { Self(4) }
    /// 8
    static var s: Self { Self(8) }
    /// 16
    static var m: Self { Self(16) }
    /// 24
    static var l: Self { Self(24) }
    /// 32
    static var xl: Self { Self(32) }
}
