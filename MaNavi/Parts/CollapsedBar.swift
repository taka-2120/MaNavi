//
//  CollapsedBar.swift
//  MaNavi
//
//  Created by Yu Takahashi on 2022/06/11.
//

import SwiftUI

struct CollapsedBar: View {
    @Binding var isBarShown: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                
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
                .padding(.horizontal, 30)
                .padding(.bottom, 45)
            }
        }
    }
}

struct CollapsedBar_Previews: PreviewProvider {
    static var previews: some View {
        CollapsedBar(isBarShown: .constant(false))
    }
}
