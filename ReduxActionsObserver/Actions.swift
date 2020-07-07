//
//  Actions.swift
//  ReduxActionsObserver
//
//  Created by Maxim Troshin on 07.07.2020.
//  Copyright © 2020 Maxim Troshin. All rights reserved.
//

import Foundation

struct AppActions {
    struct AddTodo: Action {
        var title: String
    }
    
    struct RemoveTodos: Action {
        var indexes: IndexSet
    }
}

struct TodoActions {
    struct ChangeTodo: Action {
        var id: String
        var title: String
        var isDone: Bool
    }
}
