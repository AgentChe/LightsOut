//
//  DatabaseManager.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import Foundation
import SQLite

class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    
    private var db: Connection!
    private var recordsTable = Table("records")
    
    private var id = Expression<Int64>("id")
    private var recordUid = Expression<String>("recordUid")
    private var userUid = Expression<String>("userUid")
    private var recordTime = Expression<String>("recordTime")
    private var timeStamp = Expression<Double>("timeStamp")
    private var recordName = Expression<String>("recordName")
    private var isSaved = Expression<Bool>("isSaved")
    private var isOnline = Expression<Bool>("isOnline")
    
    
    func connectDatabase(completion: @escaping(LOError?) -> Void) {
        do {
            db = try Connection("\(path)/records.sqlite3")
            print(path)
            completion(nil)
        } catch {
            completion(.unableToConnectDatabase)
        }
    }
    
    
    func createTableIfWasNotCreated(completed: @escaping(LOError?) -> Void) {
//        recordsTable = Table("records")
        let isDbCreated = UserDefaults.standard.bool(forKey: Constants.Keys.isDbCreated)
        if !isDbCreated {
            print("DEBUG: Table was not created so create table function works")
            do {
                try db.run(recordsTable.create(block: { t in
                    t.column(id, primaryKey: true)
                    t.column(recordUid)
                    t.column(userUid)
                    t.column(recordTime)
                    t.column(timeStamp)
                    t.column(recordName)
                    t.column(isSaved)
                    t.column(isOnline)
                }))
                
                UserDefaults.standard.set(true, forKey: Constants.Keys.isDbCreated)
                completed(nil)
            } catch {
                completed(.unableToCreateDatabase)
            }
        }
    }
    


    func addNewRecordToSqliteDb(record: RecordModel, completed: @escaping(LOError?) -> Void) {
        //Check record count
        do {
        let recordCountInTable = try db.scalar(recordsTable.count)
            if recordCountInTable == 50 {
                let newRecordsTable = recordsTable.order(recordTime.desc).limit(1)
                try db.run(newRecordsTable.delete())
            }
        } catch {
            completed(.unableToSaveNewRecord)
        }
        
        //Save
        do {
            try db.run(recordsTable.insert(userUid <- record.userUid,
                                           timeStamp <- record.timeStamp,
                                           recordTime <- record.recordTime,
                                           recordName <- record.name ?? "",
                                           recordUid <- record.recordUid,
                                           isSaved <- record.isSaved,
                                           isOnline <- record.isOnline))
            completed(nil)
        } catch {
            completed(.unableToSaveNewRecord)
        }
    }

    
    func getLastFiveDaysRecordsFromSqliteDb(completed: @escaping (Swift.Result<[Double], LOError>) -> Void) {
        var firstDayArray = [Double]()
        var secondDayArray = [Double]()
        var thirdDayArray = [Double]()
        var fourthDayArray = [Double]()
        var fifthDayArray = [Double]()
        var sixthDayArray = [Double]()
        var seventhDayArray = [Double]()
        
        var lastWeekDaysEndDate = [Date]()
        var lastWeekDaysStartDate = [Date]()
        if let endOfTheday = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date()) {
            for i in 0...6 {
                let endDate = Calendar.current.date(byAdding: .day, value: -i, to: endOfTheday)!
                lastWeekDaysEndDate.append(endDate)
                let startOfTheDay = Calendar.current.startOfDay(for: endDate)
                lastWeekDaysStartDate.append(startOfTheDay)
            }
        }
 
        do {
            for record in try db.prepare(recordsTable) {
                let recordFromDb = RecordModel(userUid: record[userUid], timeStamp: record[timeStamp], recordTime: record[recordTime], name: record[recordName], recordUid: record[recordUid], isSaved: record[isSaved], isOnline: record[isOnline])
                
                let recordDate = Date(timeIntervalSince1970: recordFromDb.timeStamp)
                if recordDate <= lastWeekDaysEndDate[0] && recordDate >= lastWeekDaysStartDate[0] {
                    firstDayArray.append(Double(recordFromDb.recordTime) ?? 0.0)
                } else if recordDate <= lastWeekDaysEndDate[1] && recordDate >= lastWeekDaysStartDate[1] {
                    secondDayArray.append(Double(recordFromDb.recordTime) ?? 0.0)
                } else if recordDate <= lastWeekDaysEndDate[2] && recordDate >= lastWeekDaysStartDate[2] {
                    thirdDayArray.append(Double(recordFromDb.recordTime) ?? 0.0)
                } else if recordDate <= lastWeekDaysEndDate[3] && recordDate >= lastWeekDaysStartDate[3] {
                    fourthDayArray.append(Double(recordFromDb.recordTime) ?? 0.0)
                } else if recordDate <= lastWeekDaysEndDate[4] && recordDate >= lastWeekDaysStartDate[4] {
                    fifthDayArray.append(Double(recordFromDb.recordTime) ?? 0.0)
                } else if recordDate <= lastWeekDaysEndDate[5] && recordDate >= lastWeekDaysStartDate[5] {
                    sixthDayArray.append(Double(recordFromDb.recordTime) ?? 0.0)
                } else if recordDate <= lastWeekDaysEndDate[6] && recordDate >= lastWeekDaysStartDate[6] {
                    seventhDayArray.append(Double(recordFromDb.recordTime) ?? 0.0)
                }
            }
        } catch {
            completed(.failure(.cantCalculateAvarageForChart))
        }
        
        let firstDayAvarage = firstDayArray.reduce(0.0, +) / Double(firstDayArray.count)
        let secondDayAvarage = secondDayArray.reduce(0.0, +) / Double(secondDayArray.count)
        let thirdDayAvarage = thirdDayArray.reduce(0.0, +) / Double(thirdDayArray.count)
        let fourthDayAvarage = fourthDayArray.reduce(0.0, +) / Double(fourthDayArray.count)
        let fifthDayAvarage = fifthDayArray.reduce(0.0, +) / Double(fifthDayArray.count)
        let sixthDayAvarage = sixthDayArray.reduce(0.0, +) / Double(sixthDayArray.count)
        let seventhDayAvarage = seventhDayArray.reduce(0.0, +) / Double(seventhDayArray.count)
        
        
        completed(.success([firstDayAvarage,secondDayAvarage,thirdDayAvarage,fourthDayAvarage,fifthDayAvarage,sixthDayAvarage,seventhDayAvarage]))
        
    }
    
    

    func getAllRecordsFromSqliteDb(completed: @escaping (Swift.Result<[RecordModel], LOError>) -> Void) {
        var recordsArray: [RecordModel] = []
        let newRecordsTable = recordsTable.order(recordTime.asc)
        
        
        
        do {
            for (index, record) in try db.prepare(newRecordsTable).enumerated() {
                let recordFromDb = RecordModel(id: index ,userUid: record[userUid], timeStamp: record[timeStamp], recordTime: record[recordTime], name: record[recordName], recordUid: record[recordUid], isSaved: record[isSaved], isOnline: record[isOnline])
                
                recordsArray.append(recordFromDb)
            }
        }  catch {
            completed(.failure(.unableToGetAllRecords))
        }
        completed(.success(recordsArray))
    }
    
    
    
    func deleteSingleRecordFromSqliteDb(record: RecordModel, completed: @escaping(LOError?) -> Void) {
        //get record from database
       
        getSingleUserIdFromDb(record: record) { result in
            switch result {
            case .success(let idForDeletion):
                let record = self.recordsTable.filter(self.id == idForDeletion)
                
                do {
                    try self.db.run(record.delete())
                    completed(nil)
                } catch {
                    completed(.unableToDelete)
                }
                
            case .failure(_):
                completed(.unableToDelete)
            }
        }
        
    }
    
    
    func getSingleUserIdFromDb(record: RecordModel, completed: @escaping (Swift.Result<Int64, LOError>) -> Void) {
        var idForDeletion: Int64 = 0
        do {
            
        let record: AnySequence<Row> = try db.prepare(recordsTable.filter(recordUid == record.recordUid))
            
            try record.forEach({ rowvalue in
                let id = try rowvalue.get(id)
                idForDeletion = id
            })
            completed(.success(idForDeletion))
        } catch {
            completed(.failure(.cantGetSingleUserFromDB))
        }
    }
    
    func updateRecord(record: RecordModel, completed: @escaping(LOError?) -> Void) {
        let recordForUpdate = recordsTable.filter(recordUid == record.recordUid)
        
        do {
            try db.run(recordForUpdate.update(self.recordName <- record.name!, self.isSaved <- true, self.isOnline <- true))
            completed(nil)
        } catch {
            completed(.updateErrorInLocalDb)
        }
    }
    
    
    func updateRecordForFriendLeague(record: RecordModel, completed: @escaping(LOError?) -> Void) {
        let recordForUpdate = recordsTable.filter(recordUid == record.recordUid)
        
        do {
            try db.run(recordForUpdate.update(self.recordName <- record.name!))
            completed(nil)
        } catch {
            completed(.updateErrorInLocalDb)
        }
    }
    
}
