//
//  ViewDetails.swift
//  Dream Journal
//
//  Created by Helal Chowdhury on 7/28/20.
//  Copyright © 2020 Helal. All rights reserved.
//

import Foundation
import SwiftUI

struct ViewJournal: View {
    var journal: Journal
    @State var show2 = false
    @State var title = ""
    @State var description = ""
    @State var docID = ""
    @State var animationShow = false
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack(alignment: .topLeading) {
            WaveAnimation()
            VStack(spacing: 0) {
                HStack {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(journal.title)
                                    .fontWeight(.bold)
                                    .font(.system(size: 24))
                                    .foregroundColor(.white).opacity(1)
                                Text(journal.date)
                                    .fontWeight(.bold)
                                    .font(.system(size: 14))
                            }
                            Spacer()
                        }.padding(.top, 38)
                    }
                    Spacer()
                }
                .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + -30)
                .padding(.horizontal)
                .padding(.bottom, 20)
                .background(Color.blue.opacity(0.5))
                
                HStack {
                    Spacer()
                    HStack(alignment: .top, spacing: 10) {
                        Button(action: {
                            self.docID = self.journal.id
                            self.title = self.journal.title
                            self.description = self.journal.description
                            self.animationShow.toggle()
                            self.show2.toggle()
                        }) {
                            Image(systemName: "pencil")
                                .resizable()
                                .frame(width: 19, height: 19)
                                .foregroundColor(.white).padding(8)
                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                        }
                        .background(Color.blue.opacity(0.7))
                        .cornerRadius(20)
                        .shadow(color: .gray, radius: 5, x: 1, y: 1)
                        
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Back")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                        }
                         .frame(width: 70, height: 35)
                        .background(Color.blue.opacity(0.7))
                        .cornerRadius(20)
                        .shadow(color: .gray, radius: 5, x: 1, y: 1)
                    }
                    .padding([.trailing, .top], 15)
                }
                
                ScrollView {
                    HStack {
                        VStack (alignment: .leading) {
                            Text(journal.description)
                                .foregroundColor(.black)
                                .padding(.top, 15)
                            Spacer()
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                }
                Spacer()
            }
             .edgesIgnoringSafeArea(.top)
            
        }
        .navigationBarBackButtonHidden(true)
//            .onAppear {
//                self.animationShow = true
//            }
        .sheet(isPresented: self.$show2) {
            EditView(title: self.$title, description: self.$description, docID: self.$docID, show: self.$show2)
        }
    }
}
