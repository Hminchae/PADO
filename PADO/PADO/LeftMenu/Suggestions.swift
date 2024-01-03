//
//  Suggestions.swift
//  BeReal
//
//  Created by 강치우 on 1/2/24.
//

import SwiftUI

struct Suggestions: View {
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 65)
                        .foregroundStyle(Color(red: 40/255, green: 40/255, blue: 35/255))
                        .overlay {
                            HStack {
                                Image("pp")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(20)
                                
                                VStack(alignment: .leading) {
                                    Text("PADO 초대")
                                        .foregroundStyle(.white)
                                        .fontWeight(.semibold)
                                    
                                    Text("pa.do/kangciu")
                                        .foregroundStyle(.gray)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 18))
                            }
                            .padding(.horizontal)
                        }
                        .padding(.horizontal)
                    
                    VStack {
                        HStack {
                            Text("PADO 연락처")
                                .foregroundStyle(Color(red: 205/255, green: 204/255, blue: 209/255))
                                .fontWeight(.semibold)
                                .font(.system(size: 14))
                            
                            Spacer()
                        }
                        .padding(.leading, 14)
                        .padding(.bottom, 10)
                        
                        ForEach(1..<10) { _ in
                            SuggestionCellView()
                        }
                    }
                    .padding(.top)
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
            .padding(.top, 110)
        }
    }
}

#Preview {
    Suggestions()
}