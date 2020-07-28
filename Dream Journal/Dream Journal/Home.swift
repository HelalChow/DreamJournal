//
//  Home.swift
//  Dream Journal
//
//  Created by Helal Chowdhury on 7/28/20.
//  Copyright © 2020 Helal. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase

struct JournalList: View {
    @State var show = false
    @State var txt = ""
    @State var show2 = false
    @State var txt2 = ""
    @State var docID = ""
    @State var remove = false
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
                        Button(action: {
                            withAnimation {
                                self.remove.toggle()
                            }
                        }) {
                            Image(systemName: self.remove ? "xmark.circle" : "trash").resizable().frame(width: 23, height: 23).foregroundColor(.white)
                        }
                        .padding(.horizontal, 8)
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
                                        HStack {
                                            cellView(journal: entry)
                                            if self.remove {
                                                Button(action: {
                                                    let db = Firestore.firestore()
                                                    db.collection("user").document("e0cdEmwKOGvPDTADtgFu").collection("journals").document(entry.id).delete()
                                                }) {
                                                    Image(systemName: "minus.circle.fill")
                                                        .resizable()
                                                        .frame(width: 20, height: 20)
                                                        .foregroundColor(.red)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 15)
                            .padding(.top, 10)
                        }
                        else {
                            VStack (spacing: 15) {
                                ForEach(self.data.datas) {entry in
                                    HStack {
                                        cellView(journal: entry)
                                        if self.remove {
                                            Button(action: {
                                                let db = Firestore.firestore()
                                                db.collection("user").document("e0cdEmwKOGvPDTADtgFu").collection("journals").document(entry.id).delete()
                                            }) {
                                                Image(systemName: "minus.circle.fill")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .foregroundColor(.red)
                                            }
                                        }
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
        NavigationLink(destination: ViewJournal(journal: journal)) {
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
                                .fixedSize(horizontal: false, vertical: true)
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
                }
            }.padding(.top, 1.0)
        }
    }
}

