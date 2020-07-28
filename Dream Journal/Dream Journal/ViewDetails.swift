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

        VStack (alignment: .leading) {
            VStack (alignment: .leading) {
                Text(journal.title)
                    .fontWeight(.bold)
                    .font(.system(size: 24))
                Text(journal.date)
                    .font(.system(size: 14))
            }
            .padding(.top, 25)
            .padding(.leading, 15)

            Text(journal.description)
                .foregroundColor(.gray)
                .padding(.top, 30)
                .padding(.horizontal, 15)
            Spacer()
        }
    }
}
