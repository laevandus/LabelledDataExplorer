//
//  ContentView+ListGroupView.swift
//  LabelledDataExplorer
//
//  Created by Toomas Vahter on 23.11.2023.
//

import APIServices
import SwiftUI

extension ContentView {
    struct ListGroupView: View {
        @Binding var items: [LabelledItem]

        var body: some View {
            ForEach($items, editActions: .all) { $item in
                if item.isLeaf {
                    NavigationLink {
                        LabelledItemDetailsView(id: item.id)
                    } label: {
                        Text(item.label)
                    }

                } else {
                    DisclosureGroup(item.label) {
                        ListGroupView(items: $item.children)
                    }
                }
            }
        }
    }
}
