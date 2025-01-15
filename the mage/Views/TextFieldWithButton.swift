//
//  TextFieldWithButton.swift
//  the mage
//
//  Created by Enie Weiß on 15.01.25.
//

import SwiftUI

struct TextFieldWithButton: View {
    @Binding var text: String
    var placeholder: String
    var onSubmit: (String) -> Void
    var onChange: ((String, String) -> Void)?
    
    @FocusState private var isNameFieldFocused: Bool
    @State private var canSubmit: Bool = false
    
    var body: some View {
        HStack {
            TextField("Enter your name", text: $text)
                .focused($isNameFieldFocused)
                .onChange(of: $text.wrappedValue, { oldValue, newValue in
                    onChange?(oldValue, newValue)
                    withAnimation(.easeInOut(duration: 0.2)) {
                        canSubmit = text.count != 0
                    }
                })
                .font(.title)
                .autocorrectionDisabled()
                .onSubmit {
                    onSubmit(text)
                }
            Button {
                onSubmit(text)
            } label: {
                Image("crystal ball")
                    .resizable()
                    .frame(width: 32, height: 32)
            }
            .disabled(!canSubmit)
            .opacity(canSubmit ? 1.0 : 0.33)
            
        }
        .padding(24)
        .background(.white)
        .cornerRadius(32)
        .shadow(radius: isNameFieldFocused ? 10 : 2, y: isNameFieldFocused ? 10 : 2)
        .animation(.easeInOut(duration: 0.1), value: isNameFieldFocused)
    }
}

#Preview {
    @Previewable @State var text: String = ""
    TextFieldWithButton(text: $text, placeholder: "Enter some text", onSubmit: { text in
        print("\(text)")
    }, onChange: { oldValue, newValue in
        print("new Value: \(newValue)")
    })
    .padding()
}
