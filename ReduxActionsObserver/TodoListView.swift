//
//  TodoListView.swift
//  ReduxActionsObserver
//
//  Created by Maxim Troshin on 07.07.2020.
//  Copyright © 2020 Maxim Troshin. All rights reserved.
//

import SwiftUI

struct TodoListViewConnector: Connector {
    func map(state: AppState, store: Store<AppState>, actionsObserver: ActionsObserver) -> some View {
        print("TodoListViewConnector")
        actionsObserver.setup(targetActions: [AppActions.AddTodo.self, AppActions.RemoveTodos.self])
        
        let todos = state.todos
        
        return TodoListView(todos: todos, onDelete: { indexSet in
            store.dispatch(action: AppActions.RemoveTodos(indexes: indexSet))
        })
    }
}

struct TodoListView: View {
    var todos: [TodoState]
    let onDelete: (IndexSet) -> Void
    
    var body: some View {
        List {
            ForEach(todos) { todo in
                TodoItemViewConnector(todoId: todo.id)
            }
            .onDelete(perform: onDelete)
        }
    }
}
