//
//  PhotoMoji.swift
//  PADO
//
//  Created by 황성진 on 2/2/24.
//

import FirebaseFirestore

struct PhotoMoji: Identifiable, Decodable, Hashable {
    @DocumentID var id: String?
    
    let userID: String
    let faceMojiImageUrl: String
    let storagename: String
    let time: Timestamp
    let emoji: String
}
