//
//  Connector.swift
//  ReduxActionsObserver
//
//  Created by Maxim Troshin on 07.07.2020.
//  Copyright © 2020 Maxim Troshin. All rights reserved.
//

import SwiftUI

protocol Connector: View {
    associatedtype Content: View
    func map(state: AppState, store: Store<AppState>, actionsObserver: ActionsObserver) -> Content
}

extension Connector {
    var body: some View {
        Connected<Content>(map: map)
    }
}

fileprivate struct Connected<V: View>: View {
    typealias Map = (_ state: AppState, _ store: Store<AppState>, _ actionsObserver: ActionsObserver) -> V

    @EnvironmentObject var store: Store<AppState>
    @ObservedObject var actionsObserver = ActionsObserver()
    let map: Map

    var body: V {
        actionsObserver.store = store
        return map(store.state, store, actionsObserver)
    }
}
