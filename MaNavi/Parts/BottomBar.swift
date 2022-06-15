//
//  BottomBar.swift
//  MaNavi
//
//  Created by Yu Takahashi on 2022/06/11.
//

import SwiftUI

struct BottomBar: View {
    
    @Binding var isBarShown: Bool
    @ObservedObject var sheetModel: SheetModel
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Text("MaNavi")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    sheetModel.closeDetails()
                    sheetModel.showSearch()
                }, label: {
                    Image(systemName: "list.bullet.rectangle.portrait")
                        .foregroundColor(Color(.label))
                        .font(.system(size: 18, weight: .bold))
                })
                .frame(width: 40, height: 40)
                .background(Color(.secondarySystemBackground).opacity(0.7))
                .cornerRadius(20)
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isBarShown.toggle()
                    }
                }, label: {
                    Image(systemName: isBarShown ? "eye.slash" : "eye")
                        .foregroundColor(Color(.label))
                        .font(.system(size: 18, weight: .bold))
                        .padding()
                })
                .frame(width: 40, height: 40)
                .background(Color(.secondarySystemBackground).opacity(0.7))
                .cornerRadius(20)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .padding(.horizontal, 15)
            .padding(.bottom, 30)
            .shadow(radius: 10)
        }
    }
}

struct BottomBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomBar(isBarShown: .constant(true), sheetModel: SheetModel())
    }
}
