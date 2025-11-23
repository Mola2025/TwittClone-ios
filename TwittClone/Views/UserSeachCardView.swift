//
//  UserSeachCardView.swift
//  TwittClone
//
//  Created by David Molano on 2025-11-20.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserSeachCardView: View {
    
    let user: TwitterUser
    let currentUser: TwitterUser?
    let onFollowToogle: () -> Void
    
    var isFollowing: Bool {
        currentUser?.followingUserIds?.contains(user.id ?? "") ?? false
    }
    var body: some View {
        HStack(spacing: 15){
            WebImage(url: URL(string: user.profileImageURL ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            VStack(alignment: .leading){
                Text(user.username).font(.body)
            }
            
            Spacer()
            
            Button(action: onFollowToogle){
                Text(isFollowing ? "Unfollow" : "+ Follow")
                    .font(.system(size: 14, weight: .bold))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 14)
                    .background(isFollowing ? Color.gray.opacity(0.2) : Color.blue.opacity(0.8))
                    .foregroundColor(isFollowing ? .black : .white)
                    .cornerRadius(18)
            }
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    UserSeachCardView(
        user: TwitterUser(
                    email: "test@test.com",
                    Fullname: "Test",
                    Username: "tester"
                ),
                currentUser: nil,
                onFollowToogle: {}
    )
}
