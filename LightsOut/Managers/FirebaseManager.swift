//
//  FirebaseManager.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

struct FirebaseManager {
    
    static let shared = FirebaseManager()
    let db = Firestore.firestore()
    
    func authAnonymous(completion: @escaping(String, LOError?) -> Void) {
        var uid = ""
        Auth.auth().signInAnonymously { authResult, error in
            if error != nil {
                completion(uid, .pleaseReopenApp)
            } else {
                guard let user = authResult?.user else { return }
                uid = user.uid
                completion(uid, nil)
            }
        }
    }
    
    func getCurrentUser() -> String? {
        if Auth.auth().currentUser != nil {
            return Auth.auth().currentUser?.uid
        } else {
            return nil
        }
    }
    
    func getAllRecordsFromFirestore(completion: @escaping([RecordModel], LOError?) -> Void) {
        var records = [RecordModel]()
        db.collection("records").order(by: "recordTime").getDocuments { snapshot, error in
            if error != nil {
                completion(records, .unableToGetAllRecords)
            } else {
                for document in snapshot!.documents {
                    let recordUid = document.documentID
                    let userUid = document.data()["userUid"] as! String
                    let name = document.data()["name"] as! String
                    let timeStamp = document.data()["timeStamp"] as! Double
                    let recordTime = document.data()["recordTime"] as! String
                    
                    let record = RecordModel(userUid: userUid, timeStamp: timeStamp, recordTime: recordTime, name: name, recordUid: recordUid, isSaved: true, isOnline: true)
                    records.append(record)
                    
                    if records.count == 50 {
                        break
                    }
                }
                completion(records, nil)
            }
        }
    }
    
    
    func createLeagueToFirebase(league: LeagueModel, completed: @escaping (Result<LeagueModel,LOError>) -> Void) {
        do {
            try db.collection("leagues").document("\(league.leagueId)").setData(from: league)
        } catch {
            completed(.failure(.createLeagueError))
        }
        completed(.success(league))
    }
    
    
    
    func getLeagueDetails(leagueId: Int, completion: @escaping(Result<LeagueModel, Error>) -> Void) {
        let docRef = db.collection("leagues").document(String(leagueId))
        docRef.getDocument(as: LeagueModel.self, completion: completion)
        
    }
    
    func joinLeague(leagueNumber: String, leaguePassword: String, userUid: String, completion: @escaping(LOError?) -> Void) {
        guard let password = Int(leaguePassword) else {
            completion(.wrongLeaguePassword)
            return
        }
   
        let docRef = db.collection("leagues").document(leagueNumber)
        docRef.getDocument(as: LeagueModel.self) { result in
            switch result {
            case .success(let league):
                if league.participantsUids.contains(userUid) {
                    completion(.alreadyInLeague)
                } else {
                    if password == league.leaguePassword {
                        var leagueParticipants = league.participantsUids
                        var leagueParticipantsCount = league.participantCount
                        leagueParticipants.append(userUid)
                        leagueParticipantsCount += 1
                        docRef.updateData(["participantsUids": leagueParticipants, "participantCount": leagueParticipantsCount]) { error in
                            guard error != nil else {
                                completion(nil)
                                return
                                
                            }
                            completion(.cantJoinLeague)
                        }
                    } else {
                        completion(.wrongLeaguePassword)
                    }
                }
            case .failure(_):
                completion(.cantFoundLeague)
            }
        }
    }
 
    func getYourLeagues(userUid: String, completion: @escaping([LeagueModel],LOError?) -> Void) {
        var yourLeagues = [LeagueModel]()
        
        db.collection("leagues").whereField("participantsUids", arrayContains: userUid).getDocuments { snapshot, error in
            if error != nil {
                completion(yourLeagues, .cantGetYourLeagues)
            } else {
                for document in snapshot!.documents {
                    
                    let leagueId = document.data()["leagueId"] as! Int
                    let leagueName = document.data()["leagueName"] as! String
                    let leaguePassword = document.data()["leaguePassword"] as! Int
                    let creatorUid = document.data()["creatorUid"] as! String
                    let participantCount = document.data()["participantCount"] as! Int
                    let participantsUids = document.data()["participantsUids"] as! [String]
                    let recordsInLeagues = document.data()["recordsInLeagues"] as? [OnlineRecordModel]
                    
                    let newLeague = LeagueModel(leagueId: leagueId, leagueName: leagueName, leaguePassword: leaguePassword, creatorUid: creatorUid, participantCount: participantCount, participantsUids: participantsUids, recordsInLeagues: recordsInLeagues)
                    yourLeagues.append(newLeague)
                }
                completion(yourLeagues,nil)
            }
        }
    }
    
    
    func getrecordsInLeague(leagueId: Int, completion: @escaping([OnlineRecordModel]?, LOError?) -> Void) {
        let docRef = db.collection("leagues").document("\(leagueId)")
        docRef.getDocument(as: LeagueModel.self) { result in
            switch result {
            case .success(let league):
                completion(league.recordsInLeagues, nil)
            case .failure(_):
                completion(nil, .cantGetRecordsInLeague)
            }
        }
    }
    
    
    
    func saveRecordToFirebase(record: RecordModel, completion: @escaping(Error?) -> Void) {
        db.collection("records").order(by: "recordTime").getDocuments { snapshot, error in
            if let error = error {
                completion(error)
            } else {
                if snapshot!.documents.count >= 51 {
                    self.db.collection("records").document(snapshot!.documents[50].documentID).delete()
                }
                
                let recordData = ["userUid": record.userUid,
                                  "recordTime": record.recordTime,
                                  "name": record.name ?? "",
                                  "timeStamp": record.timeStamp,
                                  "recordUid": record.recordUid] as [String : Any]
                
                self.db.collection("records").document(record.recordUid).setData(recordData, completion: completion)
            }
        }
    }
    
    func saveRecordToFirendLeague(records: [RecordModel], leagueNumber: Int?, completion: @escaping(Error?) -> Void) {
        var recordDatas = [[String:Any]]()
        for record in records {
            let recordData = ["userUid": record.userUid,
                              "recordTime": record.recordTime,
                              "name": record.name ?? "",
                              "timeStamp": record.timeStamp,
                              "recordUid": record.recordUid] as [String : Any]
            recordDatas.append(recordData)
        }
        
        
        
        guard let leagueNumber = leagueNumber else { return }
        
        let docRef = db.collection("leagues").document("\(leagueNumber)")
        docRef.updateData(["recordsInLeagues": FieldValue.arrayUnion(recordDatas)], completion: completion)
    }
    
    
    func deleteAllRecordsInFriendsLeague(leagueNumber: Int?, completion: @escaping(Error?) -> Void) {
        guard let leagueNumber = leagueNumber else { return }
        let docRef = db.collection("leagues").document("\(leagueNumber)")
        docRef.updateData(["recordsInLeagues": FieldValue.delete()], completion: completion)
    }
    
    func deleteOwnRecordInFriendsLeague(userUid: String, leagueNumber: Int, completion: @escaping(Error?) -> Void) {
        var recordDatas = [[String:Any]]()
        
        let docRef = db.collection("leagues").document("\(leagueNumber)")
        
        docRef.getDocument(as: LeagueModel.self) { result in
            switch result {
            case .success(let league):
                guard let onlineRecords = league.recordsInLeagues else { return }
                for record in onlineRecords {
                    let recordData = ["userUid": record.userUid,
                                      "recordTime": record.recordTime,
                                      "name": record.name ?? "",
                                      "timeStamp": record.timeStamp,
                                      "recordUid": record.recordUid] as [String : Any]
                    recordDatas.append(recordData)
                }
                
                let deletedRecords = recordDatas.filter {$0["userUid"] as! String == userUid}
                
                docRef.updateData(["recordsInLeagues": FieldValue.arrayRemove(deletedRecords)], completion: completion)
            case .failure(let error):
                completion(error)
                
            }
        }
    }

    func exitLeague(userUid: String, leagueNumber: Int, owner: Bool, completion: @escaping(Error?) -> Void) {
        let docRef = db.collection("leagues").document("\(leagueNumber)")
        docRef.updateData(["participantsUids": FieldValue.arrayRemove([userUid])]) { error in
            if let error = error {
                completion(error)
            } else {
                if owner {
                    docRef.delete(completion: completion)
                } else {
                    deleteOwnRecordInFriendsLeague(userUid: userUid, leagueNumber: leagueNumber, completion: completion)
                }
                
            }
        }
    }
    
    func loadRankingRefreshMessage(completion: @escaping(RefreshMessage, Error?) -> Void) {
        
        var refreshMessage = RefreshMessage(title: "Info", message: "Info message")
        
        let languageSettings = LocalizedStrings.languageSettings
        
        db.collection("refreshMessage_\(languageSettings)").getDocuments { (snapshot, error) in
            if let error = error {
                completion(refreshMessage,error)
            } else {
                for document in snapshot!.documents {
                    let title = document.data()["title"] as! String
                    let message = document.data()["message"] as! String
                    
                    refreshMessage = RefreshMessage(title: title, message: message)
                }
                completion(refreshMessage, error)
            }
        }
    }
    
}

