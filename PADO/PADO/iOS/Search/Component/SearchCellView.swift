//
//  FriendCellView.swift
//  BeReal
//
//  Created by 최동호 on 1/2/24.
//
// ITEM

import Kingfisher
import SwiftUI

struct SearchCellView: View {
    // MARK: - PROPERTY
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var followVM: FollowViewModel
    let user: User

    // MARK: - BODY
    var body: some View {
        NavigationStack {
            HStack {
                NavigationLink {
                    OtherUserProfileView(user: user)
                } label: {
                    HStack(spacing: 0) {
                        if let image = user.profileImageUrl {
                            KFImage(URL(string: image))
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(50)
                                .padding(.trailing)
                        } else {
                            Image("defaultProfile")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(50)
                                .padding(.trailing)
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text(user.nameID)
                                .foregroundStyle(.white)
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                            if !user.username.isEmpty {
                                Text(user.username)
                                    .font(.system(size: 12))
                                    .fontWeight(.regular)
                                    .foregroundStyle(Color(.systemGray))
                            }
                        }
                        
                        Spacer()
                    }
                }
            } //: HSTACK
            .padding(.horizontal)
        } //: NAVI
    }
}


