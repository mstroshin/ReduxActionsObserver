//
//  TodoItemView.swift
//  ReduxActionsObserver
//
//  Created by Maxim Troshin on 07.07.2020.
//  Copyright © 2020 Maxim Troshin. All rights reserved.
//

import SwiftUI

struct TodoItemViewConnector: Connector {
    let todoId: String
    
    func map(state: AppState, store: Store<AppState>, actionsObserver: ActionsObserver) -> some View {
        print("TodoItemViewConnector todoId: \(todoId)")
        
        actionsObserver.setup {
            switch $0 {
            case let action as TodoActions.ChangeTodo:
                return action.id == self.todoId
            default:
                return false
            }
        }
        
        let todo = state.by(id: todoId)!
        return TodoItemView(title: Binding(get: {
            todo.title
        }, set: {
            store.dispatch(action: TodoActions.ChangeTodo(id: self.todoId, title: $0, isDone: todo.isDone))
        }), isDone: Binding(get: {
            todo.isDone
        }, set: {
            store.dispatch(action: TodoActions.ChangeTodo(id: self.todoId, title: todo.title, isDone: $0))
        }))
    }
}

struct TodoItemView: View {
    @Binding var title: String
    @Binding var isDone: Bool
    
    var body: some View {
        HStack {
            TextField("What to do", text: $title)
            Button(
                action: { self.isDone.toggle() },
                label: { EmptyView() }
            )
            if isDone {
                Image(systemName: "checkmark")
            }
        }
    }
}
