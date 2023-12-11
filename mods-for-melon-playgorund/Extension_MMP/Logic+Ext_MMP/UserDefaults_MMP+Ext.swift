//
//  UserDefaults+Ext.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 21.11.2023.
//

import Foundation
import Combine

typealias MMP_UserDefaults = UserDefaults

enum UserDefaultsKeys_MMP: String {
    case allEditorDataLoaded
}

extension MMP_UserDefaults {
    @UserDefaultsBacked<Bool>(key: .allEditorDataLoaded)
    static var allEditorDataLoaded: Bool = false
}

@propertyWrapper struct UserDefaultsBacked<Value> where Value: Codable {
    private let key: String
    private let defaultValue: Value
    private let storage: UserDefaults
    private let publisher = PassthroughSubject<Value, Never>()

    init(
        wrappedValue defaultValue: Value,
        key: UserDefaultsKeys_MMP,
        storage: UserDefaults = .standard
    ) {
        self.key = key.rawValue
        self.defaultValue = defaultValue
        self.storage = storage
    }

    public var wrappedValue: Value {
        get {
            value(for: key)
        }
        set {
            set(newValue, for: key)
        }
    }

    var projectedValue: AnyPublisher<Value, Never> {
        return publisher.eraseToAnyPublisher()
    }

    // MARK: Private
    private func value(for key: String) -> Value {
        if isCodableType(Value.self) {
            guard let value = storage.value(forKey: key) as? Value else {
                return defaultValue
            }
            return value
        }
        if let data = storage.data(forKey: key) {
            do {
                return try JSONDecoder().decode(Value.self, from: data)
            } catch {

                return defaultValue
            }
        } else if let value = storage.string(forKey: key), let data = value.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(Value.self, from: data)
            } catch {
                return defaultValue
            }
        }

        return defaultValue

    }

    private func set(_ value: Value, for key: String) {
        if let optional = value as? MMP_AnyOptional {
            if optional.isNil {
                storage.removeObject(forKey: key)
            } else {
                do {
                    let encoded = try JSONEncoder().encode(value)
                    let string = String(data: encoded, encoding: .utf8)

                    storage.set(string, forKey: key)
                } catch {
                    storage.removeObject(forKey: key)
                }
            }
        } else if isCodableType(Value.self) {
            storage.set(value, forKey: key)
        } else {
            do {
                let encoded = try JSONEncoder().encode(value)
                let string = String(data: encoded, encoding: .utf8)

                storage.set(string, forKey: key)
            } catch {
                storage.removeObject(forKey: key)
            }
        }
        publisher.send(value)
    }

    private func isCodableType(_ type: Value.Type) -> Bool {
        switch type {
        case is String.Type,
             is Bool.Type,
             is Int.Type,
             is Float.Type,
             is Double.Type,
             is Date.Type:
            return true
        default:
            return false
        }
    }
}

extension UserDefaultsBacked where Value: ExpressibleByNilLiteral {
    init(key: UserDefaultsKeys_MMP, storage: UserDefaults = .standard) {
        self.init(wrappedValue: nil, key: key, storage: storage)
    }
}
