//
//  RootView.swift
//  ReduxActionsObserver
//
//  Created by Maxim Troshin on 07.07.2020.
//  Copyright © 2020 Maxim Troshin. All rights reserved.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationView {
            VStack {
                TodoCreatorViewConnector()
                TodoListViewConnector()
            }
            .padding(16)
            .navigationBarTitle("My Todo")
        }
    }
}
