//
//  Filter.swift
//  Grain
//
//  Created by Vlad Antonov on 13.01.2025.
//

import Foundation

protocol Filter {
    var title: String { get }
    var range: ClosedRange<Float> { get }
    var defaultValue: Float { get }
    var current: Float { get set }
}
