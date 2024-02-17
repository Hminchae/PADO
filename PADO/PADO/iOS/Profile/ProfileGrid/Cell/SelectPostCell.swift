//
//  GridCell.swift
//  PADO
//
//  Created by 강치우 on 2/7/24.
//

import Firebase
import FirebaseFirestoreSwift
import Kingfisher
import Lottie
import SwiftUI

struct SelectPostCell: View {
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var feedVM: FeedViewModel
    
    @State var heartLoading: Bool = false
    @State var isHeartCheck: Bool = false
    
    @State var postUser: User? = nil
    @State var surferUser: User? = nil
    @State var postOwnerButtonOnOff: Bool = false
    @State var postSurferButtonOnOff: Bool = false
    
    @State private var isHeaderVisible: Bool = true
    @State private var heartCounts: Int = 0
    @State private var commentCounts: Int = 0
    @State private var isShowingReportView: Bool = false
    @State private var isShowingCommentView: Bool = false
    @State private var isShowingLoginPage: Bool = false
    @State private var isShowingMoreText: Bool = false
    @State private var textColor: Color = .white
    
    @Binding var post: Post
    let cellType: PostViewType
    
    var body: some View {
        ZStack {
            if feedVM.currentPadoRideIndex == nil || feedVM.padoRidePosts.isEmpty {
                Rectangle()
                    .foregroundStyle(.black)
                    .containerRelativeFrame([.horizontal,.vertical])
                    .overlay {
                        // MARK: - 사진
                        if let imageUrl = URL(string: post.imageUrl) {
                            ZStack {
                                KFImage.url(imageUrl)
                                    .resizable()
                                    .onSuccess { result in
                                        let uiImage = result.image
                                        
                                        if let averageColor = uiImage.averageColor(), averageColor.isLight() {
                                            textColor = .black
                                        } else {
                                            textColor = .white
                                        }
                                    }
                                    .scaledToFill()
                                    .containerRelativeFrame([.horizontal,.vertical])
                            }
                            .overlay {
                                if feedVM.isHeaderVisible {
                                    LinearGradient(colors: [.black.opacity(0.5),
                                                            .black.opacity(0.4),
                                                            .black.opacity(0.3),
                                                            .black.opacity(0.2),
                                                            .black.opacity(0.1),
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .black.opacity(0.1),
                                                            .black.opacity(0.2),
                                                            .black.opacity(0.3),
                                                            .black.opacity(0.4),
                                                            .black.opacity(0.5)],
                                                   startPoint: .top,
                                                   endPoint: .bottom
                                    )
                                    .ignoresSafeArea()
                                }
                            }
                        }
                    }
            } else if let currentIndex = feedVM.currentPadoRideIndex, feedVM.padoRidePosts.indices.contains(currentIndex) {
                // PadoRide 이미지 표시
                let padoRide = feedVM.padoRidePosts[currentIndex]
                
                KFImage.url(URL(string:padoRide.imageUrl))
                    .resizable()
                    .blur(radius: 150)
                    .containerRelativeFrame([.horizontal,.vertical])
                    .overlay {
                        // MARK: - 사진
                        if let imageUrl = URL(string: padoRide.imageUrl) {
                            ZStack {
                                KFImage.url(imageUrl)
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.65)
                                    .cornerRadius(15)
                                    .scaledToFit()
                                    .containerRelativeFrame([.horizontal,.vertical])
                            }
                            .overlay {
                                if feedVM.isHeaderVisible {
                                    LinearGradient(colors: [.black.opacity(0.5),
                                                            .black.opacity(0.4),
                                                            .black.opacity(0.3),
                                                            .black.opacity(0.2),
                                                            .black.opacity(0.1),
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .black.opacity(0.1),
                                                            .black.opacity(0.2),
                                                            .black.opacity(0.3),
                                                            .black.opacity(0.4),
                                                            .black.opacity(0.5)],
                                                   startPoint: .top,
                                                   endPoint: .bottom
                                    )
                                    .ignoresSafeArea()
                                }
                            }
                        }
                    }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(feedVM.padoRidePosts[currentIndex].id ?? "") 님이 꾸민 파도")
                            .font(.headline)
                            .padding(.top, UIScreen.main.bounds.height * 0.09)
                            .padding(.leading, 20)
                        Spacer()
                    }
                    Spacer()
                }
            }
            
            VStack {
                Spacer()
                
                HStack(alignment: .bottom) {
                    // MARK: - 아이디 및 타이틀
                    VStack(alignment: .leading, spacing: 12) {
                        if !post.title.isEmpty {
                            Button {
                                isShowingMoreText.toggle()
                            } label: {
                                if isShowingMoreText {
                                    Text("\(post.title)")
                                        .multilineTextAlignment(.leading)
                                } else {
                                    Text("\(post.title)")
                                        .lineLimit(1)
                                }
                            }
                            .font(.system(size: 16))
                            .foregroundStyle(textColor)
                            .lineSpacing(1)
                            .fontWeight(.bold)
                            .padding(.trailing, 20)
                            
                            // MARK: - 서퍼
                            if let surferUser = surferUser {
                                NavigationLink {
                                    OtherUserProfileView(buttonOnOff: $postSurferButtonOnOff,
                                                         user: surferUser)
                                } label: {
                                    Text("surf. @\(post.surferUid)")
                                }
                                .font(.system(size: 14))
                                .fontWeight(.heavy)
                                .foregroundStyle(.white)
                                .padding(8)
                                .background(.modal.opacity(0.8))
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                                .padding(.bottom, 4)
                                .padding(.trailing, 24)
                            }
                        } else {
                            if let surferUser = surferUser {
                                NavigationLink {
                                    OtherUserProfileView(buttonOnOff: $postSurferButtonOnOff,
                                                         user: surferUser)
                                } label: {
                                    Text("surf. @\(post.surferUid)")
                                }
                                .font(.system(size: 14))
                                .fontWeight(.heavy)
                                .foregroundStyle(.white)
                                .padding(8)
                                .background(.modal.opacity(0.8))
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                                .padding(.bottom, 4)
                                .padding(.trailing, 24)
                            }
                        }
                        
                        HStack(spacing: 12) {
                            NavigationLink {
                                if let postUser = postUser {
                                    OtherUserProfileView(buttonOnOff: $postOwnerButtonOnOff,
                                                         user: postUser)
                                }
                            } label: {
                                if let postUser = postUser {
                                    CircularImageView(size: .small,
                                                      user: postUser)
                                }
                            }
                            NavigationLink {
                                if let postUser = postUser {
                                    OtherUserProfileView(buttonOnOff: $postOwnerButtonOnOff,
                                                         user: postUser)
                                }
                            } label: {
                                HStack {
                                    if let user = postUser {
                                        if !user.username.isEmpty {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("\(user.username)님의 프로필")
                                                    .font(.system(size: 12))
                                                    .fontWeight(.medium)
                                                
                                                Text("@\(post.ownerUid)")
                                                    .font(.system(size: 10))
                                                    .fontWeight(.medium)
                                                    .foregroundStyle(.gray)
                                            }
                                        } else {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("\(post.ownerUid)님의 프로필")
                                                    .font(.system(size: 12))
                                                    .fontWeight(.medium)
                                                
                                                Text("@\(post.ownerUid)")
                                                    .font(.system(size: 10))
                                                    .fontWeight(.medium)
                                                    .foregroundStyle(.gray)
                                            }
                                        }
                                    }
                            
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.white)
                                        .padding(.leading, 90)
                                }
                                .padding(10)
                                .background(Color(.systemGray4).opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                            }
                        }
                    }
                    .foregroundStyle(.white)
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        VStack(spacing: 10) {
                            // MARK: - 멍게
                            VStack(spacing: 10) {
                                Button {
                                    withAnimation {
                                        // 햅틱 피드백 생성
                                        let generator = UIImpactFeedbackGenerator(style: .light)
                                        generator.impactOccurred()
                                        // feedVM.isHeaderVisible.toggle()
                                    }
                                    
                                    if let currentIndex = feedVM.currentPadoRideIndex {
                                        // 다음 이미지로 이동
                                        let nextIndex = currentIndex + 1
                                        if nextIndex < feedVM.padoRidePosts.count {
                                            feedVM.currentPadoRideIndex = nextIndex
                                            feedVM.isShowingPadoRide = true
                                        } else {
                                            // 모든 PadoRide 이미지를 보여준 후, 원래 포스트로 돌아감
                                            feedVM.currentPadoRideIndex = nil
                                            feedVM.isShowingPadoRide = false
                                            feedVM.padoRidePosts = []
                                        }
                                    } else {
                                        // 최초로 PadoRide 이미지 보여주기
                                        // PadoRidePosts가 이미 로드되었는지 확인
                                        if feedVM.padoRidePosts.isEmpty {
                                            Task {
                                                await feedVM.fetchPadoRides(postID: post.id ?? "")
                                                if !feedVM.padoRidePosts.isEmpty {
                                                    feedVM.isShowingPadoRide = true
                                                    feedVM.currentPadoRideIndex = 0
                                                }
                                            }
                                        } else {
                                            feedVM.isShowingPadoRide = false
                                            feedVM.currentPadoRideIndex = 0
                                        }
                                    }
                                } label: {
                                    Circle()
                                        .frame(width: 30)
                                        .foregroundStyle(.clear)
                                        .overlay {
                                            LottieView(animation: .named("button"))
                                                .looping()
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 200, height: 200)
                                        }
                                }
                            }
                            .padding(.bottom, 15)
                            
                            // MARK: - 하트
                            VStack(spacing: 10) {
                                if isHeartCheck {
                                    Button {
                                        
                                        if !heartLoading && !blockPost(post: post) {
                                            Task {
                                                heartLoading = true
                                                if let postID = post.id {
                                                    await UpdateHeartData.shared.deleteHeart(documentID: postID)
                                                    isHeartCheck = await UpdateHeartData.shared.checkHeartExists(documentID: postID)
                                                    heartLoading = false
                                                }
                                                await profileVM.fetchHighlihts(id: userNameID)
                                            }
                                        }
                                    } label: {
                                        Circle()
                                            .frame(width: 24)
                                            .foregroundStyle(.clear)
                                            .overlay {
                                                LottieView(animation: .named("Heart"))
                                                    .playing()
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 65, height: 65)
                                            }
                                    }
                                } else {
                                    Button {
                                        if userNameID.isEmpty {
                                            isShowingLoginPage = true
                                        } else if !heartLoading && !blockPost(post: post) {
                                            Task {
                                                heartLoading = true
                                                if let postID = post.id, let postUser = postUser {
                                                    await UpdateHeartData.shared.addHeart(documentID: postID)
                                                    isHeartCheck = await UpdateHeartData.shared.checkHeartExists(documentID: postID)
                                                    heartLoading = false
                                                    await UpdatePushNotiData.shared.pushPostNoti(targetPostID: postID,
                                                                                                 receiveUser: postUser,
                                                                                                 type: .heart,
                                                                                                 message: "",
                                                                                                 post: post)
                                                }
                                                await profileVM.fetchHighlihts(id: userNameID)
                                                
                                            }
                                        }
                                    } label: {
                                        Image("heart")
                                    }
                                    .sheet(isPresented: $isShowingLoginPage, content: {
                                        StartView()
                                    })
                                }
                                
                                // MARK: - 하트 숫자
                                Text("\(post.heartsCount)")
                                    .font(.system(size: 10))
                                    .fontWeight(.semibold)
                                    .shadow(radius: 1, y: 1)
                            }
                            
                            // MARK: - 댓글
                            VStack(spacing: 10) {
                                Button {
                                    if !blockPost(post: post) {
                                        isShowingCommentView = true
                                    }
                                } label: {
                                    Image("chat")
                                }
                                .sheet(isPresented: $isShowingCommentView) {
                                    if let postUser = postUser, let postID = post.id {
                                        CommentView(isShowingCommentView: $isShowingCommentView,
                                                    postUser: postUser,
                                                    post: post,
                                                    postID: postID)
                                    }
                                }
                                .presentationDetents([.large])
                                
                                // MARK: - 댓글 숫자
                                Text("\(post.commentCount)")
                                    .font(.system(size: 10))
                                    .fontWeight(.semibold)
                                    .shadow(radius: 1, y: 1)
                            }
                            
                            // MARK: - 신고하기
                            VStack(spacing: 10) {
                                Button {
                                    if let padoRideIndex = feedVM.currentPadoRideIndex {
                                        if post.ownerUid == userNameID {
                                            // 내가 받은 게시물의 멍게 삭제 로직
                                            // 완료
                                            print("2")
                                            
                                            let fileName = feedVM.padoRidePosts[padoRideIndex].storageFileName
                                            let subID = feedVM.padoRidePosts[padoRideIndex].id
                                            
                                            Task {
                                                try await DeletePost.shared.deletePadoridePost(postID: post.id ?? "",
                                                                                               storageFileName: fileName,
                                                                                               subID: subID ?? "")
                                            }
                                            
                                            
                                        } else if feedVM.padoRidePosts[padoRideIndex].id == userNameID {
                                            // 내가 보낸 멍게의 삭제 로직
                                            // 포스트 - 파도라이드 - 다큐먼트 네임 == userNameID
                                            // 완료
                                            print("3")
                                            let fileName = feedVM.padoRidePosts[padoRideIndex].storageFileName
                                            
                                            Task {
                                                try await DeletePost.shared.deletePadoridePost(postID: post.id ?? "",
                                                                                               storageFileName: fileName,
                                                                                               subID: userNameID)
                                            }
                                        }
                                    } else {
                                        if post.ownerUid == userNameID {
                                            // 내가 받은 게시물 삭제 로직
                                            print("1")
                                        } else if post.surferUid == userNameID {
                                            print("================")
                                            // 내가 보낸 게시물 삭제 로직
                                            print("4")
                                        } else {
                                            if !userNameID.isEmpty {
                                                isShowingReportView.toggle()
                                            } else {
                                                isShowingLoginPage = true
                                            }
                                        }
                                    }
                                } label: {
                                    VStack {
                                        Text("...")
                                            .font(.system(size: 32))
                                            .fontWeight(.regular)
                                            .foregroundStyle(.white)
                                        
                                        Text("")
                                    }
                                }
                                .sheet(isPresented: $isShowingReportView) {
                                    ReportSelectView(isShowingReportView: $isShowingReportView)
                                        .presentationDetents([.medium, .fraction(0.8)]) // 모달높이 조절
                                        .presentationDragIndicator(.visible)
                                }
                                .sheet(isPresented: $isShowingLoginPage, content: {
                                    StartView()
                                        .presentationDragIndicator(.visible)
                                })
                            }
                            .padding(.top, -15)
                        }
                    }
                }
            }
            .padding()
            .padding(.bottom)
        }
        .onAppear {
            Task {
                self.postUser = await UpdateUserData.shared.getOthersProfileDatas(id: post.ownerUid)
                self.surferUser = await UpdateUserData.shared.getOthersProfileDatas(id: post.surferUid)
                if let postID = post.id {
                    isHeartCheck = await UpdateHeartData.shared.checkHeartExists(documentID: postID)
                }
                self.postOwnerButtonOnOff =  UpdateFollowData.shared.checkFollowingStatus(id: post.ownerUid)
                self.postSurferButtonOnOff =  UpdateFollowData.shared.checkFollowingStatus(id: post.surferUid)
            }
        }
    }
    
    private func descriptionForType(_ type: PostViewType) -> String {
        switch type {
        case .receive:
            return "\(post.surferUid)님에게 받은 파도"
        case .send:
            return "\(post.ownerUid)님에게 보낸 파도"
        case .highlight:
            return "\(post.ownerUid)님의 파도"
        }
    }
    
    private func blockPost(post: Post) -> Bool {
        let blockedUserIDs = Set(blockingUser.map { $0.blockUserID } + blockedUser.map { $0.blockUserID })
        
        return blockedUserIDs.contains(post.ownerUid) || blockedUserIDs.contains(post.surferUid)
    }
}
