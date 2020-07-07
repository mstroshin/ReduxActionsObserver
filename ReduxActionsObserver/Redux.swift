//
//  Redux.swift
//  ReduxActionsObserver
//
//  Created by Maxim Troshin on 07.07.2020.
//  Copyright © 2020 Maxim Troshin. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


//MARK: - State
public protocol FluxState { }

//MARK: - Action
public protocol Action { }

//MARK: - Dispatch
public typealias DispatchFunction = (Action) -> Void

//MARK: - Reducer
public typealias Reducer<FluxState> =
(_ state: FluxState, _ action: Action) -> FluxState

//MARK: - Middleware
public typealias StateSupplier = () -> FluxState?

public protocol Middleware {
    func execute(getState: StateSupplier, action: Action, dispatch: @escaping DispatchFunction)
}

//MARK: - Store
final public class Store<StoreState: FluxState>: ObservableObject {
    public var state: StoreState
    public let actionsNotifier = PassthroughSubject<Action, Never>()

    private var dispatchFunction: DispatchFunction!
    private let reducer: Reducer<StoreState>
    
    public init(reducer: @escaping Reducer<StoreState>,
                middleware: [Middleware] = [],
                state: StoreState) {
        self.reducer = reducer
        self.state = state
        
        var dispatchFunction = { [unowned self] action in self._dispatch(action: action) }
        middleware
            .forEach({ [unowned self] middleware in
               dispatchFunction = { next in
                { [unowned self] action in
                    middleware.execute(getState: { [weak self] in self?.state }, action: action, dispatch: next)
                }
               }(dispatchFunction)
            })
        self.dispatchFunction = dispatchFunction
    }

    public func dispatch(action: Action) {
        DispatchQueue.main.async {
            self.dispatchFunction(action)
        }
    }
    
    private func _dispatch(action: Action) {
        self.state = reducer(state, action)
        self.actionsNotifier.send(action)
    }
}

//MARK: - ActionsObserver
public class ActionsObserver: ObservableObject {
    var cancellable: AnyCancellable?
    var store: Store<AppState>!

    func setup(targetActions: [Action.Type]) {
        guard self.cancellable == nil else { return }
        
        self.cancellable = store.actionsNotifier.sink { action in
            targetActions.forEach { targetAction in
                if type(of: action) == targetAction {
                    self.objectWillChange.send()
                }
            }
        }
    }
    
    func setup(predicate: @escaping (Action) -> Bool) {
        guard self.cancellable == nil else { return }

        self.cancellable = store.actionsNotifier.sink { action in
            if predicate(action) {
                self.objectWillChange.send()
            }
        }
    }
    
    deinit {
        self.cancellable?.cancel()
    }
}

