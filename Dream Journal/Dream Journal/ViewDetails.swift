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
    @State var txt2 = ""
    @State var docID = ""
    
    var body: some View {
            ZStack {
                WaveAnimation()
                VStack(spacing: 0) {
                    HStack {
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(journal.title)
                                        .fontWeight(.bold)
                                        .font(.system(size: 24))
                                        .foregroundColor(.blue).opacity(1)
                                    Text(journal.date)
                                        .fontWeight(.bold)
                                        .font(.system(size: 14))
                                }
                                Spacer()
//                                HStack {
//                                    Spacer()
//                                    HStack {
//                                        Button(action: {
//                                            self.docID = self.journal.id
//                                            self.txt2 = self.journal.title
//                                            self.show2.toggle()
//                                        }) {
//                                            HStack {
//                                                Text("Edit")
//                                                    .foregroundColor(.white)
//                                                    .padding(.leading, 10)
//                                                Image(systemName: Constants.edit.rawValue)
//                                                    .resizable()
//                                                    .frame(width: 18, height: 18)
//                                                    .foregroundColor(.white).padding(10)
//                                            }
//                                        }
//                                        .padding(.horizontal, 8)
//                                        
//                                        NavigationLink(destination: EditView(txt: self.$txt2, docID: self.$docID, show: self.$show2)) {
//                                            HStack {
//                                                Text("Edit")
//                                                    .foregroundColor(.white)
//                                                    .padding(.leading, 10)
//                                                Image(systemName: Constants.edit.rawValue)
//                                                    .resizable()
//                                                    .frame(width: 18, height: 18)
//                                                    .foregroundColor(.white).padding(10)
//                                            }
//                                        }.padding(.horizontal, 8)
//
//                                    }
//                                    .background(Color.blue)
//                                    .opacity(0.7)
//                                    .cornerRadius(20)
//                                }.padding()
                            }.padding(.top, 20)
                        }
                        Spacer()
                    }
                    .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 40)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
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
                    Spacer()
                }
                .edgesIgnoringSafeArea(.top)
            }
//            .sheet(isPresented: self.$show2) {
//                EditView(txt: self.$txt2, docID: self.$docID, show: self.$show2)
//            }
        }
}
