//
//  EditDetails.swift
//  Dream Journal
//
//  Created by Helal Chowdhury on 7/28/20.
//  Copyright © 2020 Helal. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase

struct EditView: View {
    @Binding var title: String
    @Binding var description: String
    @Binding var docID: String
    @Binding var show: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            WaveAnimation()
            VStack {
                HStack {
                    Text("New Journal Entry")
                        .fontWeight(.bold)
                        .font(.system(size: 26))
                        .foregroundColor(.blue)
                        .opacity(0.8)
                        .padding([.top, .leading], 20)
                        .shadow(color: .gray, radius: 1, x: 0.5, y: 0.5)
                    Spacer()
                    Button(action: {
                        self.show.toggle()
                        self.SaveData()
                        self.description = ""
                    }) {
                        Text("Save")
                            .fontWeight(.bold)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 1, x: 1, y: 1)
                            
                    }
                    .background(Color.blue.opacity(0.7))
                    .clipShape(Capsule())
                    .padding([.top, .trailing], 20)
                    .shadow(color: .gray, radius: 5, x: 2, y: 2)
                }
                
                HStack {
                    Text("Title:")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                        .opacity(0.7)
                        .padding([.top, .leading], 20)
                    Spacer()
                }
                TextField("Enter Title", text: self.$title)
                    .font(.system(size: 16))
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
                
                HStack {
                    Text("Journal Entry:")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                        .opacity(0.7)
                        .padding([.top, .leading], 20)
                    Spacer()
                }
                VStack {
                    MultiLineTF(txt: self.$description)
                        .padding(.horizontal, 15)
                        .opacity(0.7)
                    Spacer()
                }
                .modifier(Keyboard())
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .simultaneousGesture(
            TapGesture()
                .onEnded {_ in
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        )
    }
    func SaveData() {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        if self.docID != "" {
            db.collection("user").document(uid!).collection("journals").document(self.docID).updateData(["title": self.title, "description": self.description, "date": Date()]) { (err) in
                if err != nil {
                    return
                }
            }
        }
        else {
            db.collection("user").document(uid!).collection("journals").document().setData(["title": self.title, "description": self.description, "date": Date()]) { (err) in
                if err != nil {
                    return
                }
            }
        }
    }
}

