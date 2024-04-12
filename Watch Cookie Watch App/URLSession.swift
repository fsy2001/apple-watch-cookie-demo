import Foundation

class CookieDelegate: NSObject, URLSessionTaskDelegate {
    static let shared = CookieDelegate()
    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping @Sendable (URLRequest?) -> Void) {
        let header = response.allHeaderFields as! [String: String]
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: header, for: response.url!)
//  won't work:      HTTPCookieStorage.shared.storeCookies(cookies, for: task)
//  won't work:      HTTPCookieStorage.shared.setCookies(cookies, for: response.url, mainDocumentURL: response.url)
        for cookie in cookies {
            HTTPCookieStorage.shared.setCookie(cookie)
        }
        completionHandler(request)
    }
}

func unwantedCookie() async throws {
    let workflowURL = URL(string: "https://workflow1.fudan.edu.cn/site/login/cas-login?redirect_url=https%253A%252F%252Fworkflow1.fudan.edu.cn%252Fapi%252Fthirdparty-url%252Fredirect%253FredirectUrlKey%253D33ad9f2d795af54f27be8235e6a8da1a&thirdparty_oauth=thirdpartyOauth")!
    let request = URLRequest(url: workflowURL)
    
    _ = try await URLSession.shared.data(for: request, delegate: CookieDelegate.shared)
}

func crossDomainCookie() async throws {
    let workflowURL = URL(string: "https://workflow1.fudan.edu.cn/open/connection/index?redirect_url=https%3A%2F%2Fecard.fudan.edu.cn%2Fepay%2Fwxpage%2Ffudan%2Fzfm%2Fqrcode%3Furl%3D0&app_id=c5gI0Ro")!
    let request = URLRequest(url: workflowURL)
    
    _ = try await URLSession.shared.data(for: request, delegate: CookieDelegate.shared)
}

func clearCookie() {
    HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
}
