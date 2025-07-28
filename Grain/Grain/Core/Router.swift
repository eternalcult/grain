import SwiftUI

// MARK: - Router

@MainActor
protocol Router: AnyObject {
    var path: NavigationPath { get set }
    associatedtype DestinationView: View
    func view(for route: any Route, completion: OptionalCompletion) -> DestinationView
    func push(_ route: any Route)
    func pop()
    func popToRoot()
}

extension Router {
    func push(_ route: any Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}

typealias Route = Hashable
