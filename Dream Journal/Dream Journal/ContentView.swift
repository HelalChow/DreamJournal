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
    var body: some View {
        NavigationView {
            ZStack {
                WaveAnimation()
                JournalList()
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
            }
//            .background(Color.black)
            .edgesIgnoringSafeArea(.vertical)
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
    @Published var noData = false
    
    let currEmail = "h3lal99@gmail.com"

    init() {
        let db = Firestore.firestore()
        db.collection("user").document("e0cdEmwKOGvPDTADtgFu").collection("journals").order(by: "date", descending: false).addSnapshotListener { (snap, err) in
            if err != nil {
                self.noData = true
                return
            }
            if snap!.documentChanges.isEmpty {
                self.noData = true
                return
            }
            for journal in snap!.documentChanges {
                if journal.type == .added {
                    let id = journal.document.documentID
                    let title = journal.document.get("title") as! String
                    let description = journal.document.get("description") as! String
                    let date = journal.document.get("date") as! Timestamp
                    
                    let format = DateFormatter()
                    format.dateFormat = "dd/MM/yyyy hh:mm a"
                    let dateString = format.string(from: date.dateValue())
                    
                    self.datas.append(Journal(id: id, title: title, description: description, date: dateString))
                }
                if journal.type == .modified {
                    //when modified
                    let id = journal.document.documentID
                    let title = journal.document.get("title") as! String
                    let description = journal.document.get("description") as! String
                    for i in 0..<self.datas.count {
                        if self.datas[i].id == id {
                            self.datas[i].title = title
                            self.datas[i].description = description
                        }
                    }
                }
                if journal.type == .removed {
                    //when removed
                    let id = journal.document.documentID
                    for i in 0..<self.datas.count {
                        if self.datas[i].id == id {
                            self.datas.remove(at: i)
                            if self.datas.isEmpty {
                                self.noData = true
                            }
                            return
                        }
                    }
                }
                
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
    case edit = "pencil"
}

struct Indicator: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<Indicator>) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Indicator>) {
    }
}

struct MultiLineTF: UIViewRepresentable {
    func makeCoordinator() -> MultiLineTF.Coordinator {
        return MultiLineTF.Coordinator(parent1: self)
    }
    
    @Binding var txt: String
    
    func makeUIView(context: UIViewRepresentableContext<MultiLineTF>) -> UITextView {
        let view = UITextView()
        if self.txt != "" {
            view.text = self.txt
            view.textColor = .black
        }
        else {
            view.text = "Type Something"
            view.textColor = .lightGray
        }
        
        view.font = .systemFont(ofSize: 16)
        view.isEditable = true
        view.backgroundColor = .clear
        view.delegate = context.coordinator
        return view
    }
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultiLineTF>) {
    }
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: MultiLineTF
        init(parent1: MultiLineTF) {
            parent = parent1
        }
        func textViewDidBeginEditing(_ textView: UITextView) {
            if self.parent.txt == "" {
                textView.text = ""
                textView.textColor = .black
            }
        }
        func textViewDidChange(_ textView: UITextView) {
            self.parent.txt = textView.text
        }
    }
}
