//
//  Register.swift
//  Dream Journal
//
//  Created by Helal Chowdhury on 7/30/20.
//  Copyright © 2020 Helal. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase

struct SignUp: View {
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var repass = ""
    @State var visible = false
    @State var revisible = false
    @Binding var show: Bool
    @State var alert = false
    @State var error = ""
    @State var value: CGFloat = 0
    @State var verify = false
    @State var emailSent = false
    @State var registerPressed = false

    var body: some View {
        ZStack {
            WaveAnimation()
            ZStack(alignment: .topLeading) {
                GeometryReader{_ in
                    VStack {
                        Image("wave")
                            .resizable()
                            .frame(width: 150, height: 150)
                        Text("Sign up for an account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(self.color)
                            .padding(.top, 0)
                        TextField("Email", text: self.$email)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color(.blue) : self.color, lineWidth:  2))
                            .padding(.top, 25)
                        
                        HStack(spacing: 15) {
                            VStack {
                                if self.visible {
                                    TextField("Password", text: self.$pass)
                                        .autocapitalization(.none)
                                }
                                else {
                                    SecureField("Password", text: self.$pass)
                                        .autocapitalization(.none)
                                }
                            }
                            Button(action: {
                                self.visible.toggle()
                            }) {
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color(.blue) : self.color, lineWidth:  2))
                        .padding(.top, 25)
                        
                        HStack(spacing: 15) {
                            VStack {
                                if self.revisible {
                                    TextField("Re-enter Password", text: self.$repass)
                                        .autocapitalization(.none)
                                }
                                else {
                                    SecureField("Re-enter Password", text: self.$repass)
                                        .autocapitalization(.none)
                                }
                            }
                            Button(action: {
                                self.revisible.toggle()
                            }) {
                                Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.repass != "" ? Color(.blue) : self.color, lineWidth:  2))
                        .padding(.top, 25)
                        
                        Button(action: {
                            self.register()
                            self.registerPressed.toggle()
                        }) {
                            Text("Sign Up")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                        }
                        .background(Color.blue.opacity(0.7))
                        .cornerRadius(20)
                        .padding(.top, 25)
                        .shadow(color: .gray, radius: 5, x: 1, y: 1)
                        
                        Spacer()
                    }
                    .padding(.top, 100)
                    .padding(.horizontal, 25)
                    .modifier(Keyboard())
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded {_ in
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                    )
                }
            }
            if self.alert {
                ErrorView(alert: self.$alert, error: self.$error)
            }
            if self.verify {
                SuccessView(verify: self.$verify, emailSent: self.$emailSent, show: self.$show)
            }
            VStack {
                if registerPressed && !verify {
                    Spacer()
                    Indicator()
                    Spacer()
                }
            }
            .padding(.horizontal)
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    func register() {
        if self.email != "" {
            if self.pass == self.repass {
                Auth.auth().createUser(withEmail: self.email, password: self.pass) { (res, err) in
                    if err != nil {
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    self.createUser()
                }
            }
            else {
                self.error = "Password mismatch"
                self.alert.toggle()
            }
        }
        else {
            self.error = "Please fill all the contents properly"
            self.alert.toggle()
        }
    }
    
    func createUser() {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        db.collection("user").document(user!.uid).setData(["email": self.email])
        if self.error == "" {
            user?.sendEmailVerification { (error) in
                guard let error = error else {
                    self.verify.toggle()
                    return
                }
                self.error = "There was an issue verifying email"
                self.alert.toggle()
            }
        }
    }
}

struct SuccessView: View {
    @State var color = Color.black.opacity(0.7)
    @Binding var verify: Bool
    @Binding var emailSent: Bool
    @Binding var show: Bool
    
    
    var body: some View {
        GeometryReader {_ in
            VStack {
                HStack {
                    Text("Email Sent")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                    Spacer()
                }.padding(.horizontal, 25)
                
                Text("A verification link has been sent to your email")
                    .foregroundColor(self.color)
                    .padding(.top)
                    .padding(.horizontal, 25)
                
                Button(action: {
                    self.show.toggle()
                    self.emailSent.toggle()
                }) {
                    Text("OK")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(Color.blue)
                .cornerRadius(20)
                .padding(.top, 25)
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
            .cornerRadius(25)
        }
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
    }
}

