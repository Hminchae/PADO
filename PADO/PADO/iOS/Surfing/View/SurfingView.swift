//
//  SurfingView.swift
//  PADO
//
//  Created by 황성진 on 1/23/24.
//

import Photos
import PhotosUI
import SwiftUI

struct SurfingView: View {
    @ObservedObject var surfingVM: SurfingViewModel
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var followVM: FollowViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.main.ignoresSafeArea()
                VStack {
                    Spacer()
                    // 이미 선택된 이미지를 표시하는 영역
                    if surfingVM.selectedUIImage != Image(systemName: "photo") {
                        surfingVM.selectedUIImage
                            .resizable()
                            .frame(width: surfingVM.photoImageSize.size.width,
                                   height: surfingVM.photoImageSize.size.height)
                            .scaledToFit()
                        
                    } else if surfingVM.cameraImage != Image(systemName: "photo") {
                        surfingVM.cameraImage
                            .resizable()
                            .frame(width: surfingVM.cameraImageSize.size.width,
                                   height: surfingVM.cameraImageSize.size.height)
                            .scaledToFit()
                    } else {
                        SurfingOnboardingView(surfingVM: surfingVM,
                                              followVM: followVM)
                    }
                    Spacer()
                }
                .navigationTitle("새로운 파도")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color.main, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .background {
                    Color.main
                        .ignoresSafeArea()
                }
                .onChange(of: surfingVM.selectedUIImage) { _, _ in
                    surfingVM.isShowingPhotoModal = false
                }
                .onAppear {
                    surfingVM.checkPhotoLibraryPermission()
                }
                .alert(isPresented: $surfingVM.showingPermissionAlert) {
                    Alert(title: Text("권한 필요"),
                          message: Text("사진 라이브러리 접근 권한이 필요합니다."),
                          dismissButton: .default(Text("확인")))
                }
                .sheet(isPresented: $surfingVM.isShownCamera) {
                    CameraAccessView(isShown: $surfingVM.isShownCamera,
                                     myimage: $surfingVM.cameraImage,
                                     myUIImage: $surfingVM.cameraUIImage,
                                     mysourceType: $surfingVM.sourceType,
                                     mycameraDevice: $surfingVM.cameraDevice)
                }
                .onDisappear {
                    surfingVM.isShownCamera = false
                }
                .sheet(isPresented: $surfingVM.isShowingPhotoModal, content: {
                    PhotoTypeModal(surfingVM: surfingVM)
                    .presentationDetents([.fraction(0.3)])
                    .presentationDragIndicator(.visible)
                    
                })
                .sheet(isPresented: $surfingVM.isShowPopularModal, content: {
                    FeedGuideView(title: "먼저 계정을 팔로우해주세요",
                                  content: "서퍼로 등록이 되어야 파도를\n보낼 수 있어요",
                                  popularUsers: feedVM.popularUsers)
                    .presentationDetents([.fraction(0.8), .large])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(30)
                })
                .sheet(isPresented: $surfingVM.isShowFollowingModal, content: {
                    SurfingGuideView()
                        .presentationDetents([.fraction(0.8), .large])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(30)
                })
                .navigationDestination(isPresented: $surfingVM.showCropView) {
                    PostCropView(surfingVM: surfingVM,
                                 feedVM: feedVM,
                                 followVM: followVM) { croppedImage, status in
                        if let croppedImage {
                            surfingVM.postingUIImage = croppedImage
                        }
                    }
                }
                .toolbar {
                    // 다음 버튼을 toolbarItem으로 추가
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if surfingVM.cameraImage != Image(systemName: "photo")
                            || surfingVM.selectedUIImage != Image(systemName: "photo") {
                            // 변경될 수 있음
                            Button("다음") {
                                if surfingVM.cameraImage != Image(systemName: "photo") {
                                    surfingVM.postingImage = surfingVM.cameraImage
                                    surfingVM.postingUIImage = surfingVM.cameraUIImage
                                } else if surfingVM.selectedUIImage != Image(systemName: "photo") {
                                    surfingVM.postingImage = surfingVM.selectedUIImage
                                    surfingVM.postingUIImage = surfingVM.selectedImage ?? UIImage()
                                }
                                surfingVM.showCropView.toggle()
                            }
                            .font(.system(.body, weight: .semibold))
                        }
                    }
                }
            }
        }
    }
}
