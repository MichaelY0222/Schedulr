//
//  AdminView.swift
//  Schedulr
//
//  Created by Michael Yu on 2025/2/9.
//

import SwiftUI

struct AdminView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginSuccess: Bool = false
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Admin Override")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                Text("Login")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                TextField("Username", text: $username)
                    .padding()
                    .background(Color("ModuleBackground"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onTapGesture {vibrate(.medium)}
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color("ModuleBackground"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .onTapGesture {vibrate(.medium)}
                Button {
                    vibrate(.medium)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.init("ButtonBackground"))
                        Text("Login")
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .foregroundColor(.init("ButtonText"))
                    }
                    .frame(width: 150, height: 50)
                }
                .padding(.top)
                Spacer()
            }
            .background(Color("Background"))
        }
    }
}

#Preview {
    AdminView()
}
