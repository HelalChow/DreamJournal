//
//  Home.swift
//  Dream Journal
//
//  Created by Helal Chowdhury on 7/28/20.
//  Copyright © 2020 Helal. All rights reserved.
//

import Foundation
import SwiftUI

struct JournalList: View {
    @State var show = false
    @State var txt = ""
    @State var show2 = false
    @State var txt2 = ""
    @State var docID = ""
    @ObservedObject var data = getData()

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                HStack {
                    if !show {
                         Text("Dream Journal")
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundColor(.blue)
                            .opacity(0.7)
                    }
                    Spacer(minLength: 0)
                    HStack {
                        if self.show {
                            Image(systemName: Constants.searchIcon.rawValue)
                                .padding(.horizontal, 8)
                                .foregroundColor(.white)
                            TextField("Search Dreams", text: self.$txt)
                                .foregroundColor(.white)
                            Button(action: {
                                withAnimation {
                                    self.txt = ""
                                    self.show.toggle()
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.white
                                )
                            }
                            .padding(.horizontal, 8)
                        }
                        else {
                            Button(action: {
                                withAnimation {
                                    self.show.toggle()
                                }
                            }) {
                                Image(systemName: Constants.searchIcon.rawValue)
                                    .foregroundColor(.white).padding(10)
                            }
                        }
                    }
                    .padding(self.show ? 10 : 0)
                    .background(Color.blue)
                    .opacity(0.7)
                    .cornerRadius(20)
                }
                .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 15)
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                if self.data.datas.isEmpty {
                    if self.data.noData {
                        Spacer()
                        Text("There are no journals")
                        Spacer()
                    }
                    else {
                        Spacer()
                        Indicator()
                        Spacer()
                    }
                }
                else {
                    ScrollView(.vertical, showsIndicators: false) {
                        if self.txt != "" {
                            VStack(spacing: 15) {
                                if self.data.datas.filter({$0.title.lowercased().contains(self.txt.lowercased())}).count == 0 {
                                    Text("No Results Found")
                                        .padding(.top, 10)
                                }
                                else {
                                    ForEach(self.data.datas.filter({$0.title.lowercased().contains(self.txt.lowercased())})) {entry in
                                        cellView(journal: entry)
                                    }
                                }
                            }
                            .padding(.horizontal, 15)
                            .padding(.top, 10)
                            
                        }
                        else {
                            VStack (spacing: 15) {
                                ForEach(self.data.datas) {entry in
                                    Button(action: {
                                        self.docID = entry.id
                                        self.txt2 = entry.title
                                        self.show2.toggle()
                                    }) {
                                        cellView(journal: entry)
                                    }
                                }
                            }
                            .padding(.horizontal, 15)
                            .padding(.top, 10)
                        }
                    }
                }
            }
            
            Button(action: {
                self.txt2 = ""
                self.docID = ""
                self.show2.toggle()
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.white)
            }.padding()
            .background(Color.blue)
            .opacity(0.8)
            .clipShape(Circle())
            .padding()
        }
        .sheet(isPresented: self.$show2) {
            EditView(txt: self.$txt2, docID: self.$docID, show: self.$show2)
        }
    }
}

struct cellView: View {
    var journal: Journal

    var body: some View {
        ZStack {
            Rectangle().fill(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 3, x: 1, y: 1)
                .opacity(0.8)
            VStack {
                HStack {
                    VStack (alignment: .leading) {
                        Text(journal.title).bold()
                            .padding(.top, 8.0)
                        Text(journal.date)
                            .font(.caption).padding(.bottom, 10.0)
                        Text(journal.description)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .lineLimit(2)
                            .padding(.bottom, 10.0)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.leading, 15.0)
                    Spacer()
                }
//                HStack {
//                    Spacer()
//                    NavigationLink(destination: ViewDetails(deeplink: deeplink)) {
//                        Text("View Details")
//                            .foregroundColor(.blue)
//                            .font(.system(size: 15))
//                            .bold()
//                    }
//                    .padding(.trailing, 10)
//                    NavigationLink(destination: ViewDetails(deeplink: deeplink)) {
//                        Text("Edit")
//                            .foregroundColor(.blue)
//                            .font(.system(size: 15))
//                            .bold()
//                    }
//                }
//                .padding(.bottom, 8)
//                .padding(.trailing, 15)
            }
        }.padding(.top, 1.0)
    }
}

