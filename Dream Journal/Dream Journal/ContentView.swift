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
    @ObservedObject var Journals = getData()
    var body: some View {
        ZStack {
            WaveAnimation()
            JournalList()
        }
//        .background(Color.black)
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct JournalList: View {
    @State var show = false
    @State var txt = ""

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
            
            Spacer()
            
        }
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
        db.collection("user").getDocuments { (snap, err) in
            if err != nil {
                return
            }
            let entries = snap?.documents ?? []
            for journal in entries {
                print(journal.get("email"))
//                let id = deeplink.documentID
//                guard let name = deeplink.get("name") as? String else {
//                    return
//                }
//                guard let url = deeplink.get("url") as? String else {
//                    return
//                }
//                guard let description = deeplink.get("description") as? String else {
//                    return
//                }
//                self.datas.append(Deeplink(id: id, name: name, url: url, description: description))
            }
        }
    }
}

struct Journal {
    var title: String
}

enum Constants: String {
    case searchIcon = "magnifyingglass"
    case checkMark = "checkmark"
    case registry = "book.fill"
    case favorites = "heart.fill"
    case history = "folder.fill"
}


