//
//  SwiftUIView.swift
//  
//
//  Created by Toomas Vahter on 23.11.2023.
//

import SwiftUI

public struct TitledValueRowView: View {
    let title: String
    let value: String

    public init(title: String, value: String) {
        self.title = title
        self.value = value
    }

    public var body: some View {
        HStack {
            Text(verbatim: title)
            Spacer()
            Text(verbatim: value)
        }
    }
}

#Preview {
    Form {
        TitledValueRowView(title: "Title", value: "Value")
    }
}
