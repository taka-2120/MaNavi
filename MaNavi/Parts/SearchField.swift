//
//  SearchField.swift
//  MaNavi
//
//  Created by Yu Takahashi on 2022/06/13.
//
// Source: https://dev.classmethod.jp/articles/hand-made-search-bar/

import SwiftUI

struct SearchField: View {

    @ObservedObject var sheetModel: SheetModel
    @Binding var searchText: String
    var onSubmit: (String) -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.secondarySystemBackground))
                .frame(height: 36)

            HStack(spacing: 6) {
                Spacer()
                    .frame(width: 0)

                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                TextField("Search", text: $searchText)
                    .onTapGesture {
                        withAnimation {
                            sheetModel.searchOffset = 20
                        }
                    }
                    .submitLabel(.search)
                    .onSubmit {
                        onSubmit(searchText)
                    }

                if !searchText.isEmpty {
                    Button {
                        searchText.removeAll()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 6)
                }
            }
        }
        .padding(.horizontal)
    }
}
