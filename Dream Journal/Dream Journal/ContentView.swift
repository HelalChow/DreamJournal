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
    //        .background(Color.black)
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
        db.collection("user").document("e0cdEmwKOGvPDTADtgFu").collection("journals").addSnapshotListener { (snap, err) in
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
                }
                if journal.type == .removed {
                    //when removed
                }
                
            }
        }
    }
}

func SaveData(txt: String) {
    let db = Firestore.firestore()
    db.collection("user").document("e0cdEmwKOGvPDTADtgFu").collection("journals").document().setData(["title": txt, "description": txt, "date": Date()]) { (err) in
        if err != nil {
            return
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

struct Indicator: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<Indicator>) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Indicator>) {
    }
}

struct EditView: View {
    @State var txt = ""
    @Binding var show: Bool
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            MultiLineTF(txt: self.$txt)
                .padding()
                .background(Color.black.opacity(0.05))
            Button(action: {
                self.show.toggle()
                SaveData(txt: self.txt)
            }) {
                Text("Save")
                    .padding(.vertical)
                    .padding(.horizontal, 25)
                    .foregroundColor(.white)
            }
            .background(Color.blue.opacity(0.8))
            .clipShape(Capsule())
            .padding()
        }
    }
}

struct MultiLineTF: UIViewRepresentable {
    func makeCoordinator() -> MultiLineTF.Coordinator {
        return MultiLineTF.Coordinator(parent1: self)
    }
    
    @Binding var txt: String
    
    func makeUIView(context: UIViewRepresentableContext<MultiLineTF>) -> UITextView {
        let view = UITextView()
        view.text = "Type Something"
        view.font = .systemFont(ofSize: 18)
        view.textColor = .gray
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
            textView.text = ""
            textView.textColor = .black
        }
        func textViewDidChange(_ textView: UITextView) {
            self.parent.txt = textView.text
        }
    }
}
