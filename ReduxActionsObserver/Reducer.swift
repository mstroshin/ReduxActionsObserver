//
//  Reducer.swift
//  ReduxActionsObserver
//
//  Created by Maxim Troshin on 07.07.2020.
//  Copyright © 2020 Maxim Troshin. All rights reserved.
//

import Foundation

func appStateReducer(state: AppState, action: Action) -> AppState {
    var state = state
    
    switch action {
    case let action as AppActions.AddTodo:
        state.todos.append(TodoState(title: action.title))
    case let action as AppActions.RemoveTodos:
        state.todos.remove(atOffsets: action.indexes)
    default:
        state.todos = state.todos.map { todoStateReducer(state: $0, action: action) }
    }
    
    return state
}

func todoStateReducer(state: TodoState, action: Action) -> TodoState {
    var state = state
    
    switch action {
    case let action as TodoActions.ChangeTodo:
        state.isDone = action.isDone
        state.title = action.title
    default:
        break
    }
    
    return state
}
