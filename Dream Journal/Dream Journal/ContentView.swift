//
//  ContentView.swift
//  Dream Journal
//
//  Created by Helal Chowdhury on 7/27/20.
//  Copyright © 2020 Helal. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            WaveAnimation()
            JournalList()
        }
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
                        .foregroundColor(.white)
                }
                Spacer(minLength: 0)
                HStack {
                    if self.show {
                        Image(systemName: Constants.searchIcon.rawValue)
                            .padding(.horizontal, 8)
                        TextField("Search Deeplinks", text: self.$txt)
                        Button(action: {
                            withAnimation {
                                self.txt = ""
                                self.show.toggle()
                            }
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
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
                                .foregroundColor(.black).padding(10)
                        }
                    }
                }
                .padding(self.show ? 10 : 0)
                .background(Color.white)
                .cornerRadius(20)
            }
            .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 15)
            .padding(.horizontal)
            .padding(.bottom, 20)
            .background(Color.blue)
            
            Spacer()
            
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum Constants: String {
    case searchIcon = "magnifyingglass"
    case checkMark = "checkmark"
    case registry = "book.fill"
    case favorites = "heart.fill"
    case history = "folder.fill"
}


