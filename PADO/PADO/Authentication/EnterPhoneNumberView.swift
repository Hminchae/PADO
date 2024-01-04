//
//  EnterPhoneNumberView.swift
//  BeReal
//
//  Created by 강치우 on 1/2/24.
//

import SwiftUI

struct EnterPhoneNumberView: View {
    
    @State var showCountryList = false
    @State var buttonActive = false
    
    @Binding var phoneNumberButtonClicked: Bool
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Text("PADO.")
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 22))
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("휴대폰 번호를 입력해주세요")
                        .foregroundStyle(.white)
                        .fontWeight(.heavy)
                        .font(.system(size: 16))
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(lineWidth: 1)
                            .frame(width: 75, height: 45)
                            .foregroundStyle(.gray)
                            .overlay {
                                Text("\(viewModel.country.flag(country: viewModel.country.isoCode))")
                                +
                                Text("+\(viewModel.country.phoneCode)")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 12))
                                    .fontWeight(.bold)
                            }
                            .onTapGesture {
                                self.showCountryList.toggle()
                            }
                        
                        TextField("NUMBER", text: $viewModel.phoneNumber)
                            .frame(width: 280)
                            .keyboardType(.numberPad)
                            .foregroundStyle(.white)
                            .font(.system(size: 30))
                            .fontWeight(.heavy)
                            .tint(.cursor)
                            .onChange(of: viewModel.phoneNumber) { newValue, _ in
                                viewModel.phoneNumber = formatPhoneNumber(newValue)
                            }
                    }
                    
                    if viewModel.showAlert {
                        Text(viewModel.errorMessage)
                            .foregroundStyle(.red)
                            .font(.system(size: 14))
                            .padding(.top, 10)
                    }
                    Spacer()
                }
                .padding(.top, 50)
                
                VStack {
                    Spacer()
                    
                    Text("계속 진행시 개인정보처리방침과 이용약관에 동의처리 됩니다")
                        .foregroundStyle(Color(red: 70/255, green: 70/255, blue: 73/255))
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    Button {
                        Task {
                            await viewModel.sendOtp()
                        }
                    } label: {
                        WhiteButtonView(buttonActive: $buttonActive, text: "인증 문자 보내기")
                            .onChange(of: viewModel.phoneNumber) { oldValue, newValue in
                                if !newValue.isEmpty {
                                    buttonActive = true
                                } else if newValue.isEmpty {
                                    buttonActive = false
                                }
                            }
                    }
                    .disabled(viewModel.phoneNumber.isEmpty ? true : false)
                }
            }
        }
        .sheet(isPresented: $showCountryList, content: {
            SelectCountryView(countryChosen: $viewModel.country)
        })
        .overlay {
            ProgressView()
                .opacity(viewModel.isLoading ? 1 : 0)
        }
        .background {
    
            NavigationLink(tag: "VERIFICATION", selection: $viewModel.navigationTag) {
                EnterCodeView()
                    .environmentObject(viewModel)           // 수정 해야할 부분
            } label: {
                
            }
            .labelsHidden()
        }
        .environment(\.colorScheme, .dark)
    }
}

extension EnterPhoneNumberView {
    func formatPhoneNumber(_ number: String) -> String {
        let cleanNumber = number.filter("0123456789".contains)
        let mask = "XXX-XXXX-XXXX"
        
        var result = ""
        var index = cleanNumber.startIndex
        for ch in mask where index < cleanNumber.endIndex {
            if ch == "X" {
                result.append(cleanNumber[index])
                index = cleanNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}

//#Preview {
//    EnterPhoneNumberView()
//}
