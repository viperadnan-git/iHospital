//
//  Router.swift
//  iHospital
//
//  Created by Adnan Ahmad on 13/07/24.
//

import SwiftUI

final class Navigation: ObservableObject {
    @Published var path = NavigationPath()
}

extension EnvironmentValues {
    private struct NavigationKey: EnvironmentKey {
        static let defaultValue = Navigation()
    }

    var navigation: Navigation {
        get { self[NavigationKey.self] }
        set { self[NavigationKey.self] = newValue }
    }
}
