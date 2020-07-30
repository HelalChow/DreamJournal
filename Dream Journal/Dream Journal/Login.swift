//
//  Login.swift
//  Dream Journal
//
//  Created by Helal Chowdhury on 7/29/20.
//  Copyright © 2020 Helal. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase

struct Authenticate: View {
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View {
        VStack {
            if self.status {
                JournalList()
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
            }
            else {
                ZStack {
                    NavigationLink(destination: SignUp(show: self.$show), isActive: self.$show) {
                        Text("")
                    }
                    .hidden()

                    Login(show: self.$show)
                }
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
            }
        }
    }
}

struct Login: View {
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @Binding var show: Bool
    @State var alert = false
    @State var error = ""
    
    var body: some View {
        ZStack {
            ZStack(alignment: .topTrailing) {
                GeometryReader{_ in
                    VStack {
                        Image("wave")
                            .resizable()
                            .frame(width: 150, height: 150)
                        Text("Log in to your account")
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
                        
                        HStack {
                            HStack {
                                Button(action: {
                                    self.show.toggle()
                                }) {
                                    Text("Register")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                        .shadow(color: .black, radius: 1, x: 1, y: 1)
                                }.padding(.horizontal, 5)
                            }
                            .padding(8)
                            .background(Color.blue.opacity(0.7))
                            .cornerRadius(20)
                            .shadow(color: .gray, radius: 5, x: 1, y: 1)
                            
                            Spacer()
                            
                            Button(action: {
                                self.reset()
                            }) {
                                Text("Forgot password")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.blue)
                            }.padding(.horizontal, 5)
                        }
                        .padding(.top, 20)
                        
                        Button(action: {
                            self.verify()
                        }) {
                            Text("Log in")
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
                    .padding(.top, 40)
                    .padding(.horizontal, 25)
                }
                
            }
            
            if self.alert {
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
    }
    func verify() {
        if self.email != "" && self.pass != "" {
            Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res, err) in
                if err != nil {
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                print("Success")
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }
        }
        else {
            self.error = "Please fill in the contents properly"
            self.alert.toggle()
        }
    }
    
    func reset() {
        if self.email != "" {
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                if err != nil {
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                self.error = "RESET"
                self.alert.toggle()
            }
        }
        else {
            self.error = "Email ID is empty"
            self.alert.toggle()
        }
    }
}

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
                }
            }
            if self.alert {
                ErrorView(alert: self.$alert, error: self.$error)
            }
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
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    
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
        let uid = Auth.auth().currentUser?.uid
        db.collection("user").document(uid!).setData(["email": self.email])
    }
}

struct ErrorView: View {
    @State var color = Color.black.opacity(0.7)
    @Binding var alert: Bool
    @Binding var error: String
    
    
    var body: some View {
        GeometryReader {_ in
            VStack {
                HStack {
                    Text(self.error == "RESET" ? "Message" : "Error")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                    Spacer()
                }.padding(.horizontal, 25)
                
                Text(self.error == "RESET" ? "Password reset link has been sent successfully" : self.error)
                    .foregroundColor(self.color)
                    .padding(.top)
                    .padding(.horizontal, 25)
                
                Button(action: {
                    self.alert.toggle()
                }) {
                    Text(self.error == "RESET" ? "OK" : "Cancel")
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
