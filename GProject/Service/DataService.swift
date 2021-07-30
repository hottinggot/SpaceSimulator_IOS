//
//  DataService.swift
//  GProject
//
//  Created by 서정 on 2021/07/15.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser

class DataService: DataServiceType {
    
    
    let BASE_URL = "http://15.165.96.180:7780/api"
    var urlString: String!
    
    let disposeBag = DisposeBag()
    
    let tk = TokenUtils()
    
    
    
    func createBoard(title: String, content: String) {
        
        let params = ["title": title, "content": content]
        let jwt = tk.readJwt()
        
        guard let jwt = jwt else {
            
            print("JWT NIL")
            return
        }
        
        urlString = BASE_URL.appending("/community")
        
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.timeoutInterval = 10
        request.headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": jwt]
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request as URLRequestConvertible)
            .response {_ in
            }
            
    }

    @discardableResult
    func getBoardList(pageNum: Int) -> Observable<[Board]> {
        urlString = BASE_URL.appending("/community")
        let jwt = tk.readJwt()
        let param = ["page": pageNum]
        guard let jwt = jwt else {
            print("JWT NIL")
            return Observable.just([]).asObservable()
        }

        return RxAlamofire
            .request(.get, urlString,
                     parameters: param,
                     encoding: URLEncoding.default,
                     headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": jwt])
            .validate(statusCode: 200..<300)
            .responseString()
            .asObservable()
            .map { (res, str) -> [Board] in
                
                do{
                let boardList = try JSONDecoder().decode([Board].self, from: str.data(using: .utf8)!)
                    return boardList
                } catch{ print(error)}
                return []
            
            }
    }

    func updateBoard(board: Board){
        let jwt = tk.readJwt()
        guard let jwt = jwt else {
            print("JWT NIL")
            return
        }
        
        urlString = BASE_URL.appending("/community")
    
        let params = ["title": board.title, "content": board.content, "communityId":board.communityId] as [String:Any]
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "PUT"
        request.timeoutInterval = 10
        request.headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": jwt]
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
                
        // 응답 받지 않음
        AF.request(request as URLRequestConvertible)
            .responseJSON { res in
                switch res.result {
                         case .success:
                            print("PUT RES: ", res)
                         case .failure(let error):
                             print(error)
                         }
            }
    }


    func deleteBoard(communityId: Int) {
        urlString = BASE_URL.appending("/community")
        let jwt = tk.readJwt()
        guard let jwt = jwt else {
            print("JWT NIL")
            return
        }
        
        let params = ["communityId": communityId]
                
        // 응답 받지 않음
        AF.request(urlString,
                   method: .delete,
                   parameters: params,
                   encoding: URLEncoding.queryString,
                   headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": jwt])
            .responseJSON() { _ in
                
            }
    }
    
    func postAccessTokenNUserNickname(accessToken: String, nickname: String, type: LoginType) -> Observable<String> {
        
        var params : Any
        var jwtString: String = ""
        
        switch type {
        case .REGISTER:
            urlString = BASE_URL.appending("/user/register")
            params = ["token": accessToken, "nickname": nickname] as Dictionary
        default:
            urlString = BASE_URL.appending("/user/login")
            params = ["token": accessToken] as Dictionary
        }
        
        
            
        var request = URLRequest(url: URL(string: urlString)!)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.timeoutInterval = 10
        
        

        // httpBody 에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        return RxAlamofire.request(request as URLRequestConvertible)
            .responseString()
            .asObservable()
            .map ({(res, str) -> String in
                    if let jwtResponse = try? JSONDecoder().decode(JWTToken.self, from: str.data(using: .utf8)!) {
                        //JWT 저장
                        jwtString = jwtResponse.token
                        self.tk.createJwt(value: jwtString)
                    
                    }
                    return jwtString
            })
            
    }
    
    @discardableResult
    func getUserInfo(jwtToken: String) -> Observable<UserInfo> {
        
        urlString = BASE_URL.appending("/user/me")
        let jwt = tk.readJwt()
        guard let jwt = jwt else {
            print("JWT NIL")
            return Observable.just(UserInfo(nickname: "0", userId: 0)).asObservable()
        }

        return RxAlamofire
            .request(.get, urlString,
                     parameters: nil,
                     encoding: URLEncoding.default,
                     headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": jwt])
            .validate(statusCode: 200..<300)
            .responseString()
            .asObservable()
            .map { (res, str) -> UserInfo in
                
                if let user = try? JSONDecoder().decode(UserInfo.self, from: str.data(using: .utf8)!) {
                    return user
                }
                return UserInfo(nickname: "실패", userId: 0)
            }
    }

}
