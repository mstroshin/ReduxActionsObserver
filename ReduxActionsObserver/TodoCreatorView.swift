//
//  TodoCreatorView.swift
//  ReduxActionsObserver
//
//  Created by Maxim Troshin on 07.07.2020.
//  Copyright © 2020 Maxim Troshin. All rights reserved.
//

import SwiftUI

struct TodoCreatorViewConnector: Connector {
    func map(state: AppState, store: Store<AppState>, actionsObserver: ActionsObserver) -> some View {
        print("TodoCreatorViewConnector")
        
        return TodoCreatorView { title in
            store.dispatch(action: AppActions.AddTodo(title: title))
        }
    }
}

struct TodoCreatorView: View {
    @State private var title = ""
    var addAction: (String) -> Void
    
    var body: some View {
        HStack {
            TextField("Todo", text: $title).padding(24)
            Button(action: {
                self.addAction(self.title)
                self.title = ""
            }) {
                Image(systemName: "plus")
            }.disabled(title.count == 0)
        }
    }
}
