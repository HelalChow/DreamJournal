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
    var body: some View {

        ZStack {
            WaveAnimation()
            VStack {
                HStack {
                    VStack (alignment: .leading) {
                        Text(journal.title)
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(.blue).opacity(0.7)
                        Text(journal.date)
                            .fontWeight(.bold)
                            .font(.system(size: 14))
                    }
                    .padding(.top, 25)
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
            }.edgesIgnoringSafeArea(.top)
        }
    }
}
