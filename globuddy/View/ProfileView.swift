//
//  ProfileView.swift
//  globuddy
//
//  Created by BAHATTIN KOC on 14.11.2024.
//

import SwiftUI

struct ProfileView: View {

    // MARK: - PROPERTIES

    var profileImage: UIImage
    var name: String
    var description: String

    var body: some View {
        HStack {
            Image(uiImage: profileImage)
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .padding()

            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.black)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()

            Button(action: {
                print("Message send")
            }) {
                Image(systemName: "ellipsis.message.fill")
                    .font(.title)
                    .foregroundColor(.purple.opacity(0.4))
                    .padding()
            }
        }
        .background(.purple.opacity(0.1))
        .cornerRadius(30)
        .padding()
    }
}

#Preview {
    ProfileView(profileImage: .ironman, name: "Iron Man", description: "Superhero")
}
