//
//  TaskMock.swift
//  RealmSampleTests
//
//  Created by 大井裕貴 on 2021/09/17.
//

@testable import RealmSample

extension Task {
    static func mock() -> Task {
        let t = Task(name: "Task 1")
        return t
    }
}
