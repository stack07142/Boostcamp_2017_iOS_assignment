//
//  main.swift
//  Grade_kwon_byung_soo
//
//  Created by 권병수 on 2017. 6. 2..
//  2017 부스트캠프 iOS 과정 사전과제

import Foundation

/* Student Class --------------------------------------------------------------- */

class Student {
    
    // Stored Property (Data)
    let name : String
    let scores : [Int]
    var averageScore : Double = 0.0
    
    // Initializer
    init(name nameValue : String, scores scoreValue : [Int]) {
        
        self.name = nameValue
        self.scores = scoreValue
        self.averageScore = getAverage()
    }

    func getAverage() -> Double {
        
        var sum : Int = 0
        
        for i in 0..<scores.count {
            
            sum += scores[i]
        }
        
        return Double(sum) / Double(scores.count)
    }
}

/* Functions ------------------------------------------------------------------ */

// 결과 출력 함수
func printResult(scoreArr : [String : Double]) -> String {
    
    var result : String = ""
    
    var totalAverage : Double = 0.0
    var completionStudents : String = ""
    
    for score in scoreArr.values {
        
        totalAverage += score
    }
    
    totalAverage /= Double(scoreArr.count)
    
    result += "성적결과표\n\n"
    result += "전체 평균 : \(String(format: "%0.2f", totalAverage))\n\n"
    result += "개인별 학점\n"
    
    // 성적순 정렬
    for (key, value) in (Array(scoreArr).sorted {$0.0 < $1.0}) {
        
        result += String(format: "%@", key) + String(repeating:" ", count: 11 - key.characters.count) + String(format: ": %@", getGrade(score: value)) + "\n"
        
        // 평균 70점이 넘는 학생들
        if value >= 70.0 {
            
            completionStudents += (String(key)) + ", "
        }
    }
    
    completionStudents.removeSubrange(completionStudents.index(completionStudents.endIndex, offsetBy: -2)..<completionStudents.endIndex)
    
    result += "\n수료생\n"
    result += completionStudents
    
    return result
}

// 점수에서 학점 구하는 함수
func getGrade(score : Double) -> String {
    
    var myGrade : String
    
    switch score {
    case 90...100:
        myGrade = "A"
    case 80..<90:
        myGrade = "B"
    case 70..<80:
        myGrade = "C"
    case 60..<70:
        myGrade = "D"
    default:
        myGrade = "F"
    }
    
    return myGrade
}

/* 파일 체크 -------------------------------------------------------------------- */

// 파일 경로, Home Directory에 존재하는 students.json 파일
let readURL : URL = URL(fileURLWithPath: NSHomeDirectory() + "/students.json")

let fm : FileManager = FileManager.default

// 파일에 접근할 수 없는 경우
if !fm.fileExists(atPath: readURL.path) {
    
    print("JSON 파일 접근 에러, path: " + readURL.path)
    exit(1)
}

/* JSON Parsing --------------------------------------------------------------- */

var studentArr : [Student] = []

do {
    
    let data : Data = try Data(contentsOf: readURL)
    let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
    
    // JSON Parsing
    if let root = jsonData as? [Any] {
        
        var studentCount : Int = root.count
        
        for i in 0..<studentCount {
            
            if let student = root[i] as? [String : Any],
                let studentName = student["name"] as? String,
                let grade = student["grade"] as? [String: Int] {
                
                var studentScore : [Int] = []
                
                if let score = grade["data_structure"] {
                    
                    studentScore.append(score)
                }
                if let score = grade["algorithm"] {
                    
                    studentScore.append(score)
                }
                if let score = grade["networking"] {
                    
                    studentScore.append(score)
                }
                if let score = grade["database"] {
                    
                    studentScore.append(score)
                }
                if let score = grade["operating_system"] {
                    
                    studentScore.append(score)
                }

                var student : Student = Student(name: studentName, scores: studentScore)
                studentArr.append(student)
            }
        }
    }
}
catch let error {
    
    print("Error : ", error.localizedDescription)
}

/* Result -------------------------------------------------------------------- */

var averageScores : [String : Double] = [:]

for i in 0..<studentArr.count {
    
    averageScores[studentArr[i].name] = studentArr[i].averageScore
}

let result : String = printResult(scoreArr: averageScores)

/* Write Result -------------------------------------------------------------- */

let writeURL : URL = URL(fileURLWithPath: NSHomeDirectory() + "/result.txt")

do {
 
    try result.write(to: writeURL, atomically: false, encoding: String.Encoding.utf8)
}
catch let error {

    print("Error : ", error.localizedDescription)
}


