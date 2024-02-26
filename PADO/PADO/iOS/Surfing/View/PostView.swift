//
//  PostView.swift
//  PADO
//
//  Created by 김명현 on 1/23/24.
//

import Kingfisher
import SwiftUI

struct PostView: View {
    // MARK: - PROPERTY
    @State private var postLoading = false
    @State private var showAlert = false
    @State private var postOwner: User? = nil
    
    @ObservedObject var surfingVM: SurfingViewModel
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var followVM: FollowViewModel
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @Environment (\.dismiss) var dismiss
    let updateImageUrl = UpdateImageUrl.shared
    
    // MARK: - BODY
    var body: some View {
        VStack {
            VStack {
                surfingVM.postingImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.4)
                    .padding(.vertical, 20)
                
                Spacer()
                
                VStack {
                    HStack {
                        Text("제목")
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                        
                        Spacer()
                    } //: HSTACK
                    
                    .padding(.leading, 20)
                    
                    TextField("제목을 입력해주세요", text: $surfingVM.postingTitle)
                        .font(.system(size: 14))
                        .padding(.leading, 20)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color(UIColor.systemGray))
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 0.5)
                    
                    HStack {
                        if followVM.selectSurfingID.isEmpty {
                            Text("서핑 리스트")
                                .font(.system(size: 16))
                                .fontWeight(.semibold)
                        } else {
                            KFImage(URL(string: followVM.selectSurfingProfileUrl))
                                .resizable()
                                .placeholder {
                                    // 로딩 중이거나 URL이 nil일 때 표시될 이미지
                                    Image("defaultProfile")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 44, height: 44)
                                        .clipShape(Circle())
                                }
                                .scaledToFill()
                                .frame(width: 44, height: 44)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                if !followVM.selectSurfingUsername.isEmpty {
                                    Text(followVM.selectSurfingID)
                                        .font(.system(size: 14, weight: .semibold))
                                    
                                    Text(followVM.selectSurfingUsername)
                                        .font(.system(.footnote))
                                        .foregroundStyle(Color(.systemGray))
                                } else {
                                    Text(followVM.selectSurfingID)
                                        .font(.system(size: 14, weight: .semibold))
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            followVM.showSurfingList.toggle()
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 18))
                                .foregroundStyle(.white)
                        }
                    } //: HSTACK
                    .padding(20)
                }
                .padding(.bottom, 30)
                
                Button {
                    // 게시요청 로직
                    if followVM.selectSurfingID.isEmpty {
                        // 서핑할 친구가 선택되지 않았을 때 경고 메시지를 표시
                        showAlert = true
                    } else {
                        if !postLoading {
                            postLoading = true
                            Task {
                                do {
                                    // 이미지 업로드 시 이전 입력 데이터 초기화
                                    let uploadedImageUrl = try await updateImageUrl.updateImageUserData(uiImage: surfingVM.postingUIImage,
                                                                                                        storageTypeInput: .post,
                                                                                                        documentid: feedVM.documentID,
                                                                                                        imageQuality: .highforPost,
                                                                                                        surfingID: followVM.selectSurfingID)
                                    await surfingVM.postRequest(imageURL: uploadedImageUrl,
                                                                surfingID: followVM.selectSurfingID)
                                    
                                    postOwner = await UpdateUserData.shared.getOthersProfileDatas(id: followVM.selectSurfingID)
                                    
                                    surfingVM.post = await UpdatePostData.shared.fetchPostById(postId: formattedPostingTitle)
                                    
                                    if let post = surfingVM.post, let postOwner = postOwner {
                                        await UpdatePushNotiData.shared.pushPostNoti(targetPostID: formattedPostingTitle,
                                                                                     receiveUser: postOwner,
                                                                                     type: .requestSurfing,
                                                                                     message: surfingVM.postingTitle,
                                                                                     post: post)
                                    }
                                    
                                    surfingVM.resetImage()
                                    followVM.selectSurfingID = ""
                                    followVM.selectSurfingUsername = ""
                                    followVM.selectSurfingProfileUrl = ""
                                    viewModel.showTab = 0
                                    await feedVM.fetchFollowingPosts()
                                    postLoading = false
                                } catch {
                                    print("파베 전송 오류 발생: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 40)
                            .foregroundStyle(.blueButton)
                        
                        if postLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.5)
                        } else {
                            Text("공유")
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                        }
                    }
                }
                .alert("파도를 보낼 유저를 선택해주세요", isPresented: $showAlert) {
                    Button("확인", role: .cancel) { }
                }
                .padding(.bottom, 20)
            } //: VSTACK
            .sheet(isPresented: $followVM.showSurfingList) {
                SurfingSelectView(followVM: followVM)
                    .presentationDetents([.medium, .large])
            }
        }
        .navigationTitle("새로운 파도")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.main, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.main
                .ignoresSafeArea()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    if let image = surfingVM.selectedImage {
                        surfingVM.postingUIImage = image
                    }
                    followVM.selectSurfingID = ""
                    followVM.selectSurfingUsername = ""
                    followVM.selectSurfingProfileUrl = ""
                    dismiss()
                } label: {
                    Image("dismissArrow")
                }
            }
        }
    }
}
