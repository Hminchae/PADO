//
//  SettingProfileView.swift
//  PADO
//
//  Created by 황민채 on 1/15/24.
//

import PhotosUI
import SwiftUI

struct SettingProfileView: View {
    // MARK: - PROPERTY
    @State var width = UIScreen.main.bounds.width
    @State private var isActive: Bool = false
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment (\.dismiss) var dismiss
    
    // MARK: - BODY
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                // MARK: - 프로필수정, 탑셀
                VStack {
                    ZStack {
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Text("취소")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 18))
                            }
                            
                            Spacer()
                            
                            Button {
                                // 버튼이 활성화된 경우 실행할 로직
                                if isActive {
                                    Task {
                                        await viewModel.profileSaveData()
                                        dismiss()
                                    }
                                }
                                // 비활성화 상태일 때는 아무 작업도 수행하지 않음
                            } label: {
                                Text("저장")
                                    .foregroundStyle(isActive ? .white : .gray) // 활성화 상태에 따라 텍스트 색상 변경
                                    .font(.system(size: 18))
                            }
                            .disabled(!isActive) // 버튼 비활성화 여부 결정
                            .onChange(of: viewModel.changedValue) { newValue, oldValue in
                                isActive = !newValue // viewModel의 changedValue에 따라 isActive 상태 업데이트
                            }
                        }
                        .padding(.horizontal, width * 0.05)
                        
                        Text("프로필 수정")
                            .foregroundStyle(.white)
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        
                        SettingProfileDivider()
                    }
                    
                    Spacer()
                }
                
                VStack {
                    VStack {
                        PhotosPicker(selection: $viewModel.selectedItem) {
                            if let image = viewModel.userSelectImage {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 129, height: 129)
                                    .clipShape(Circle())
                                    .onAppear {
                                        viewModel.imagePick.toggle()
                                        viewModel.checkForChanges()
                                    }
                            } else {
                                CircularImageView(size: .xxLarge)
                            }
                        }
                        // MARK: - 프로필수정, 이름
                        VStack {
                            SettingProfileDivider()
                            
                            HStack {
                                HStack {
                                    Text("닉네임")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 16))
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.22)
                                
                                HStack {
                                    if let originUsername = viewModel.currentUser?.username, !originUsername.isEmpty {
                                        TextField(originUsername, text: $viewModel.username)
                                            .font(.system(size: 16))
                                            .foregroundStyle(.white)
                                            .padding(.leading, width * 0.05)
                                            .onChange(of: viewModel.username) { _, _ in
                                                viewModel.checkForChanges()
                                            }
                                    } else {
                                        TextField("닉네임", text: $viewModel.username)
                                            .font(.system(size: 16))
                                            .foregroundStyle(.white)
                                            .padding(.leading, width * 0.05)
                                            .onChange(of: viewModel.username) { _, _  in
                                                viewModel.checkForChanges()
                                            }
                                    }
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.63)
                            }
                            .padding(.top, 4)
                            
                            SettingProfileDivider()
                            
                            // MARK: - 프로필수정
                            HStack {
                                HStack {
                                    Text("Instagram")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 16))
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.22)
                                
                                HStack {
                                    if let insta = viewModel.currentUser?.instaAddress, !insta.isEmpty {
                                        TextField(insta, text: $viewModel.instaAddress)
                                            .font(.system(size: 16))
                                            .foregroundStyle(.white)
                                            .padding(.leading, width * 0.05)
                                            .onChange(of: viewModel.instaAddress) { _, _  in
                                                viewModel.checkForChanges()
                                            }

                                    } else {
                                        TextField("계정명", text: $viewModel.instaAddress)
                                            .font(.system(size: 16))
                                            .foregroundStyle(.white)
                                            .padding(.leading, width * 0.05)
                                            .onChange(of: viewModel.instaAddress) { _, _  in
                                                viewModel.checkForChanges()
                                            }
                                    }
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.63)
                            }
                            .padding(.top, 4)
                            
                            SettingProfileDivider()
                            
                            // MARK: - 프로필수정, 틱톡주소
                            HStack {
                                HStack {
                                    Text("tiktok")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 16))
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.22)
                                
                                HStack {
                                    if let tiktok = viewModel.currentUser?.tiktokAddress, !tiktok.isEmpty {
                                        TextField(tiktok, text: $viewModel.tiktokAddress)
                                            .font(.system(size: 16))
                                            .foregroundStyle(.white)
                                            .padding(.leading, width * 0.05)
                                            .onChange(of: viewModel.tiktokAddress) { _, _  in
                                                viewModel.checkForChanges()
                                            }
                                    } else {
                                        TextField("계정명", text: $viewModel.tiktokAddress)
                                            .font(.system(size: 16))
                                            .foregroundStyle(.white)
                                            .padding(.leading, width * 0.05)
                                            .onChange(of: viewModel.tiktokAddress) { _, _  in
                                                viewModel.checkForChanges()
                                            }
                                    }
                            
                                    Spacer()
                                }
                                .frame(width: width * 0.63)
                                
                            }
                            
                            SettingProfileDivider()
                                .padding(.top, 4)
                            
                        }
                        .padding(.horizontal, width * 0.05)
                        .padding(.top, 24)
                        
                        Spacer()
                    }
                    .padding(.top, UIScreen.main.bounds.height * 0.08)
                }
            }
        }
        .onAppear {
            viewModel.fetchUserProfile()
        }
        .navigationBarBackButtonHidden(true)
    }
}
