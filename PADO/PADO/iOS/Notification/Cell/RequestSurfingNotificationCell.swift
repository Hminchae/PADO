//
//  CreateFeedCell.swift
//  PADO
//
//  Created by 강치우 on 1/16/24.
//

import Kingfisher
import SwiftUI

struct RequestSurfingNotificationCell: View {
    @ObservedObject var notiVM: NotificationViewModel
    
    var notification: Noti
    
    var body: some View {
        Button {
            notiVM.showRequestSurfingPost = true
        } label: {
            HStack(spacing: 0) {
                if let user = notiVM.notiUser[notification.sendUser] {
                    CircularImageView(size: .medium,
                                           user: user)
                    .padding(.trailing, 10)
                }
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("\(notification.sendUser)님이 회원님에게 파도를 보냈어요. 확인해주세요! ")
                            .font(.system(.subheadline))
                            .fontWeight(.medium)
                        +
                        Text(notification.createdAt.formatDate(notification.createdAt))
                            .font(.system(.footnote))
                            .foregroundStyle(Color(.systemGray))
                    }
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                }
                
                Spacer()
                
                if let postID = notification.postID,
                   let post = notiVM.notiPosts[postID],
                   let image = URL(string: post.imageUrl) {
                    KFImage(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            }
        }
        .sheet(isPresented: $notiVM.showRequestSurfingPost) {
            if let postID = notification.postID,
               let post = notiVM.notiPosts[postID] {
                NavigationStack {
                    FeedCell(post: .constant(post))
                    .presentationDragIndicator(.visible)
                }
            }
        }
    }
}
