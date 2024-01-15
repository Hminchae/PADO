//
//  SettingAskView.swift
//  PADO
//
//  Created by 황민채 on 1/15/24.
//

import SwiftUI

struct SettingAskView: View {
    @State var width = UIScreen.main.bounds.width
    @State var height = UIScreen.main.bounds.height
    let placeholder: String = "저희 PADO를 이용하시는 동안 불편한 점이나\n문의사항이 있으시다면 의견을 보내주세요."
    @State var inquiry: String = ""
    @State var filenum: Int = 0
    var body: some View {
        VStack {
            ZStack {
                Color("mainBackgroundColor").ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Text("문의하기")
                            .foregroundStyle(.white)
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                        
                        HStack {
                            Button {
                                // TODO: - 뒤로가기 버튼 구현
                            } label: {
                                Image(systemName: "arrow.backward")
                                    .font(.system(size: 20))
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .foregroundStyle(.white)
                
                VStack {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $inquiry)
                            .foregroundStyle(Color.white)
                            .opacity(0.3)
                            .frame(width: width * 0.9, height: 200)
                            .scrollContentBackground(.hidden) // <- Hide it
                            .background(Color("mainBackgroundColor"))
                            .modifier(RoundedEdge(width: 1.5, color: .gray, cornerRadius: 10))
                            .padding(.bottom)
                        
                        if inquiry.isEmpty {
                            Text(placeholder)
                                .font(.system(size: 14))
                                .lineSpacing(10)
                                .foregroundStyle(Color.white.opacity(0.25))
                                .padding(.horizontal, 50)
                                .padding(.top, 80)
                        }
                    }
                    ZStack {
                        Rectangle()
                            .frame(width: width * 0.9, height: 120)
                            .foregroundStyle(Color("mainBackgroundColor"))
                            .modifier(RoundedEdge(width: 1.5, color: .gray, cornerRadius: 10))
                        VStack {
                            HStack {
                                Text("파일첨부\(filenum)/3")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color.white)
                                    .opacity(0.3)
                                Spacer()
                                
                            }
                            .padding(.horizontal)
                            
                            HStack {
                                Button {
                                    // TODO: 포토피커 첨부 기능 추가
                                } label: {
                                    Image("addFileButton")
                                }
                                
                                Button {
                                    // TODO: 포토피커 첨부 기능 추가
                                } label: {
                                    Image("addFileButton")
                                }
                                
                                Button {
                                    // TODO: 포토피커 첨부 기능 추가
                                } label: {
                                    Image("addFileButton")
                                }
                                
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                    Spacer()
                    
                }
                .padding(.horizontal)
                .padding(.top, 50)
            }
        }
        
    }
}

struct RoundedEdge: ViewModifier {
    let width: CGFloat
    let color: Color
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content.cornerRadius(cornerRadius - width)
            .padding(width)
            .background(color)
            .cornerRadius(cornerRadius)
    }
}
#Preview {
    SettingAskView()
}
