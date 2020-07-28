//
//  ContentView.swift
//  Dream Journal
//
//  Created by Helal Chowdhury on 7/27/20.
//  Copyright © 2020 Helal. All rights reserved.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @ObservedObject var data = getData()
    var body: some View {
        ZStack {
            WaveAnimation()
            JournalList(data: self.$data.datas)
        }
//        .background(Color.black)
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct JournalList: View {
    @State var show = false
    @State var txt = ""
    @Binding var data: [Journal]

    var body: some View {
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
            
            ScrollView(.vertical, showsIndicators: false) {
                if self.txt != "" {
                    VStack(spacing: 15) {
                        if self.data.filter({$0.title.lowercased().contains(self.txt.lowercased())}).count == 0 {
                            Text("No Results Found")
                                .padding(.top, 10)
                        }
                        else {
                            ForEach(self.data.filter({$0.title.lowercased().contains(self.txt.lowercased())})) {entry in
                                cellView(journal: entry)
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.top, 10)
                    
                }
                else {
                    VStack (spacing: 15) {
                        ForEach(self.data) {entry in
                            cellView(journal: entry)
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.top, 10)
                }
            }
            
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
                .opacity(0.7)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class getData: ObservableObject {
    @Published var datas = [Journal]()
    let currEmail = "h3lal99@gmail.com"

    init() {
        let db = Firestore.firestore()
        print("yaaass")
        db.collection("user").document("e0cdEmwKOGvPDTADtgFu").collection("journals").getDocuments { (snap, err) in
            if err != nil {
                return
            }
            let entries = snap?.documents ?? []
            for journal in entries {
                let id = journal.documentID
                let title = journal.get("title") as! String
                let description = journal.get("description") as! String
                let date = journal.get("date") as! String
                self.datas.append(Journal(id: id, title: title, description: description, date: date))
            }
        }
    }
}

struct Journal: Identifiable {
    var id: String
    var title: String
    var description: String
    var date: String
}

enum Constants: String {
    case searchIcon = "magnifyingglass"
    case checkMark = "checkmark"
    case registry = "book.fill"
    case favorites = "heart.fill"
    case history = "folder.fill"
}


