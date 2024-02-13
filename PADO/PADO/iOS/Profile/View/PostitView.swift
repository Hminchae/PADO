//
//  PostitView.swift
//  PADO
//
//  Created by 최동호 on 2/9/24.
//
import Kingfisher
import SwiftUI

struct PostitView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @ObservedObject var postitVM: PostitViewModel
    
    @Binding var isShowingMessageView: Bool
    
    @FocusState private var isTextFieldFocused: Bool
    @State private var isFocused: Bool = false
    @State private var isShowingLoginPage: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Divider()
                ScrollView {
                    VStack {
                        if !postitVM.messages.isEmpty {
                            ForEach(postitVM.messages) { message in
                                PostitCell(postitVM: postitVM,
                                           message: message)
                            }
                        } else {
                            Text("아직 방명록에 글이 없어요")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                                .padding(.top, 150)
                        }
                    }
                    .padding(.top)
                }
                
                Divider()
                
                HStack {
                    if let user = viewModel.currentUser {
                        CircularImageView(size: .small, user: user)
                    }
                    
                    HStack {
                        if postitVM.ownerID == userNameID {
                            TextField("내 방명록에 글 남기기",
                                      text: $postitVM.inputcomment,
                                      axis: .vertical)
                            .font(.system(size: 14))
                            .tint(Color(.systemBlue).opacity(0.7))
                            .focused($isTextFieldFocused)
                            
                        } else {
                            TextField("\(postitVM.ownerID)님의 방명록에 글 남기기",
                                      text: $postitVM.inputcomment,
                                      axis: .vertical)
                            .font(.system(size: 14))
                            .tint(Color(.systemBlue).opacity(0.7))
                            .focused($isTextFieldFocused)
                        }
                        
                        if !postitVM.inputcomment.isEmpty {
                            Button {
                                if !userNameID.isEmpty {
                                    Task {
                                        await postitVM.writeMessage(ownerID: postitVM.ownerID,
                                                                    imageUrl: viewModel.currentUser?.profileImageUrl ?? "",
                                                                    inputcomment: postitVM.inputcomment)
                                    }
                                } else {
                                    isShowingLoginPage = true
                                }
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 26)
                                        .frame(width: 48, height: 28)
                                        .foregroundStyle(.blue)
                                    Image(systemName: "arrow.up")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.white)
                                }
                            }
                            .padding(.vertical, -5)
                            .sheet(isPresented: $isShowingLoginPage, content: {
                                StartView()
                                    .presentationDragIndicator(.visible)
                            })
                        } else {
                            Button {
                                //
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 26)
                                        .frame(width: 48, height: 28)
                                        .foregroundStyle(.gray)
                                    Image(systemName: "arrow.up")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                    }
                }
                .padding([.horizontal, .vertical], 8)
            }
            .background(.main, ignoresSafeAreaEdges: .all)
            .navigationBarBackButtonHidden()
            .navigationTitle("방명록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingMessageView = false
                    } label: {
                        HStack(spacing: 2) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                            
                            Text("닫기")
                                .font(.system(size: 16))
                                .fontWeight(.medium)
                        }
                    }
                }
            }
            .toolbarBackground(Color(.main), for: .navigationBar)
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

