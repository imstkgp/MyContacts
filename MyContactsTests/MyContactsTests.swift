//
//  MyContactsTests.swift
//  MyContactsTests
//
//  Created by mmt5885 on 08/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import XCTest
@testable import MyContacts

class MyContactsTests: XCTestCase {

    private var contactList = [Contact]()
    private var mockApiHelper:APIManager?
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let contact1 = createDummyContact(withId: 1, name: "A1")
        let contact2 = createDummyContact(withId: 2, name: "B1")
        let contact3 = createDummyContact(withId: 3, name: "C1")
        contactList.append(contentsOf: [contact1, contact2, contact3])
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    private func createDummyContact(withId id:Int, name:String) -> Contact {
        return Contact.init(
            id: id,
            firstName: name,
            lastName: name,
            email: nil,
            phoneNumber: nil,
            url: nil,
            profilePic: "",
            favorite: true,
            createdAt: nil,
            updatedAt: nil
        )
    }
    
    private func readFile(_ name:String, fileType: String) -> Data? {
        if let path = Bundle.main.path(forResource: name, ofType: fileType) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                // handle error
            }
        }
        return nil
    }
    func testCreateContactDetails() {
        let data = readFile("Contacts", fileType: "json")
        
        let mockSession = URLSessionMock.init()
        mockSession.data = data
        let mockApiHelper = APIManager.init(session: mockSession)
        
        let target = ContactListVM.init(apiHelper: mockApiHelper)
        target.fetchContactList()
        print(target.contactList)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
