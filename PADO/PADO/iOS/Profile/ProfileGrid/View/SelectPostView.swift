//
//  GridDetailView.swift
//  PADO
//
//  Created by 강치우 on 2/7/24.
//

import Kingfisher
import SwiftUI

struct SelectPostView: View {
    @ObservedObject var profileVM: ProfileViewModel
    
    @State private var isDetailViewReady = false
    
    @Binding var isShowingDetail: Bool
    
    @GestureState private var dragState = CGSize.zero
    
    let userID: String
    var viewType: PostViewType
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(showsIndicators: false) {
                    ScrollViewReader { value in
                        LazyVStack(spacing: 0) {
                            switch viewType {
                            case .receive:
                                ForEach(profileVM.padoPosts.indices, id: \.self) { index in
                                    FeedCell(post: $profileVM.padoPosts[index])
                                    .id(profileVM.padoPosts[index].id)
                                    .task {
                                        if index == profileVM.padoPosts.indices.last {
                                            await profileVM.fetchMorePadoPosts(id: userID)
                                        }
                                    }
                                }
                            case .send:
                                ForEach(profileVM.sendPadoPosts.indices, id: \.self) { index in
                                    FeedCell(post: $profileVM.sendPadoPosts[index])
                                    .id(profileVM.sendPadoPosts[index].id)
                                    .task {
                                        if index == profileVM.sendPadoPosts.indices.last {
                                            await profileVM.fetchMoreSendPadoPosts(id: userID)
                                        }
                                    }
                                }
                            case .highlight:
                                ForEach(profileVM.highlights.indices, id: \.self) { index in
                                    FeedCell(post: $profileVM.highlights[index])
                                    .id(profileVM.highlights[index].id)
                                    .task {
                                        if index == profileVM.highlights.indices.last {
                                            await profileVM.fetchMoreHighlihts(id: userID)
                                        }
                                    }
                                }
                            }
                        }
                        .scrollTargetLayout()
                        .task {
                            if profileVM.isFirstPostOpen {
                                try? await Task.sleep(nanoseconds: 1 * 100_000_000)
                                value.scrollTo(profileVM.selectedPostID, anchor: .top)
                                profileVM.isFirstPostOpen.toggle()
                            }
                        }
                    }
                }
                .scrollTargetBehavior(.paging)
                .ignoresSafeArea()
                
                VStack {
                    HStack(alignment: .top) {
                        Button {
                            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.8)) {
                                self.isShowingDetail = false
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(.title3))
                                .fontWeight(.medium)
                        }
                        
                        Spacer()
                        
                        Text(titleForType(viewType))
                            .font(.system(.title3))
                            .fontWeight(.semibold)
                            .padding(.trailing, 15)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
        }
        .onChange(of: resetNavigation) { _, _ in
            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.8)) {
                isShowingDetail = false 
            }
        }
    }
   
    // 각 뷰 타입에 맞는 제목 반환
    private func titleForType(_ type: PostViewType) -> String {
        switch type {
        case .receive:
            return "받은 파도"
        case .send:
            return "보낸 파도"
        case .highlight:
            return "좋아요"
        }
    }
}
