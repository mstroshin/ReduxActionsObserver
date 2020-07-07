//
//  State.swift
//  ReduxActionsObserver
//
//  Created by Maxim Troshin on 07.07.2020.
//  Copyright © 2020 Maxim Troshin. All rights reserved.
//

import Foundation

struct AppState: FluxState {
    var todos = [TodoState]()
    
    func by(id: String) -> TodoState? {
        todos.first(where: { $0.id == id })
    }
}

struct TodoState: FluxState, Identifiable {
    var id: String
    var title: String
    var isDone: Bool
    
    init(title: String) {
        self.id = UUID().uuidString
        self.title = title
        self.isDone = false
    }
}
