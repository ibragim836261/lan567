import Foundation

struct RouterSettings: Codable {
    var host = "192.168.1.1"
    var username = "admin"
    var modelName = ""
    var brand: RouterBrand = .auto
    var provider = "Beeline Kazakhstan"
    var useHTTPS = false

    var baseURL: URL? {
        let raw = host.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !raw.isEmpty else { return nil }
        let normalized = raw.contains("://") ? raw : "\(useHTTPS ? "https" : "http")://\(raw)"
        guard let url = URL(string: normalized),
              ["http", "https"].contains(url.scheme?.lowercased() ?? ""), url.host != nil else { return nil }
        return url
    }
}

enum RouterBrand: String, CaseIterable, Codable, Identifiable {
    case auto = "Автоопределение"
    case keenetic = "Keenetic / Netcraze"
    case huawei = "Huawei / OptiXstar"
    case zte = "ZTE"
    case tpLink = "TP-Link"
    case asus = "ASUS"
    case mikrotik = "MikroTik"
    case xiaomi = "Xiaomi"
    case dLink = "D-Link"
    case nokia = "Nokia"
    case fiberHome = "FiberHome"
    case sercomm = "Sercomm"
    case sagemcom = "Sagemcom"
    case tenda = "Tenda"
    case mercusys = "Mercusys"
    case netis = "Netis"
    case ubiquiti = "Ubiquiti"
    case zyxel = "Zyxel"
    case cudy = "Cudy"
    case totolink = "Totolink"
    case linkSys = "Linksys"
    case h3c = "H3C"
    case ruijie = "Ruijie"

    var id: String { rawValue }
}

struct RouterModel: Identifiable {
    let name: String
    let brand: RouterBrand
    var id: String { name }
}

struct RouterDevice: Identifiable, Codable, Equatable {
    var id: String { mac.uppercased() }
    var name: String
    var mac: String
    var ip: String
    var isConnected: Bool
    var isBlocked: Bool
}

struct CompatibilityEntry: Identifiable {
    let brand: String
    let level: String
    let details: String
    var id: String { brand }
}

enum AppLanguage: String, CaseIterable, Identifiable {
    case russian = "Русский"
    case kazakh = "Қазақша"
    case english = "English"
    var id: String { rawValue }
}

let kazakhstanProviders = [
    "Beeline Kazakhstan", "Казахтелеком", "Tele2 / Altel", "AlmaTV",
    "Transtelecom", "Freedom Telecom", "Другой провайдер"
]

// Fifty commonly used consumer-router/ISP-CPE model families. The catalogue helps select
// the correct manufacturer profile; it does not imply that every firmware exposes an API.
let popularRouterModels: [RouterModel] = [
    // ZTE — common ISP optical terminals and home gateways
    .init(name: "ZXHN F660", brand: .zte),
    .init(name: "ZXHN F670L", brand: .zte),
    .init(name: "ZXHN F680", brand: .zte),
    .init(name: "ZXHN F688", brand: .zte),
    .init(name: "ZXHN F690", brand: .zte),
    .init(name: "ZXHN F8648P", brand: .zte),
    .init(name: "ZXHN H298A", brand: .zte),
    .init(name: "ZXHN H3601P", brand: .zte),

    // Huawei
    .init(name: "EchoLife HG8245H", brand: .huawei),
    .init(name: "EchoLife HG8245Q2", brand: .huawei),
    .init(name: "EchoLife HG8145V5", brand: .huawei),
    .init(name: "EchoLife HG8145X6", brand: .huawei),
    .init(name: "EchoLife EG8145V5", brand: .huawei),
    .init(name: "B535-232", brand: .huawei),
    .init(name: "WiFi AX3 WS7200", brand: .huawei),

    // TP-Link
    .init(name: "Archer C6", brand: .tpLink),
    .init(name: "Archer C7", brand: .tpLink),
    .init(name: "Archer AX10", brand: .tpLink),
    .init(name: "Archer AX20", brand: .tpLink),
    .init(name: "Archer AX23", brand: .tpLink),
    .init(name: "Archer AX55", brand: .tpLink),
    .init(name: "Archer AX73", brand: .tpLink),
    .init(name: "TL-WR841N", brand: .tpLink),

    // ASUS
    .init(name: "RT-AC68U", brand: .asus),
    .init(name: "RT-AX58U", brand: .asus),
    .init(name: "RT-AX86U", brand: .asus),
    .init(name: "RT-AX88U", brand: .asus),

    // Keenetic / Netcraze
    .init(name: "Hopper (KN-3810)", brand: .keenetic),
    .init(name: "Giga (KN-1011)", brand: .keenetic),
    .init(name: "Extra (KN-1713)", brand: .keenetic),
    .init(name: "Viva (KN-1910)", brand: .keenetic),

    // Xiaomi
    .init(name: "Mi Router 4A Gigabit Edition", brand: .xiaomi),
    .init(name: "Xiaomi Router AX1800", brand: .xiaomi),
    .init(name: "Xiaomi Router AX3000", brand: .xiaomi),
    .init(name: "Xiaomi Router AX3600", brand: .xiaomi),

    // D-Link
    .init(name: "DIR-825", brand: .dLink),
    .init(name: "DIR-842", brand: .dLink),
    .init(name: "DIR-X1560", brand: .dLink),

    // Tenda
    .init(name: "AC10U", brand: .tenda),
    .init(name: "AC23", brand: .tenda),
    .init(name: "RX3", brand: .tenda),

    // Mercusys
    .init(name: "MR30G", brand: .mercusys),
    .init(name: "MR70X", brand: .mercusys),

    // MikroTik
    .init(name: "hAP ac²", brand: .mikrotik),
    .init(name: "hAP ax²", brand: .mikrotik),

    // Other widely deployed brands
    .init(name: "G-2425G-A", brand: .nokia),
    .init(name: "AN5506-04", brand: .fiberHome),
    .init(name: "Armor G5", brand: .zyxel),
    .init(name: "UniFi Dream Router", brand: .ubiquiti),
    .init(name: "EA7500", brand: .linkSys)
]

let routerCompatibility: [CompatibilityEntry] = [
    .init(brand: "Keenetic / Netcraze", level: "Проверенный API", details: "Список клиентов, блокировка/разблокировка и привязка существующего расписания через RCI. Результат блокировки перечитывается с роутера."),
    .init(brand: "ZTE (8 моделей в каталоге)", level: "Веб-панель", details: "F660, F670L, F680, F688, F690, F8648P, H298A и H3601P. Вход выполняется в панели роутера; для блокировки используй штатный Access Control / MAC Filter / Blacklist, если это поддерживает прошивка."),
    .init(brand: "Huawei (7 моделей в каталоге)", level: "Веб-панель", details: "Каталог помогает выбрать модель. Родительский контроль и фильтры доступны не на каждой операторской прошивке; универсальный API приложения не подтверждён."),
    .init(brand: "TP-Link (8 моделей в каталоге)", level: "Веб-панель", details: "Для ряда моделей есть Access Control. Автоматическая блокировка из приложения не включена: действие выполняется и подтверждается интерфейсом роутера."),
    .init(brand: "ASUS, Xiaomi, D-Link, Tenda, Mercusys, MikroTik", level: "Веб-панель", details: "Каталог содержит популярные модели. Разделы фильтрации и родительского контроля зависят от модели и версии прошивки."),
    .init(brand: "Nokia, FiberHome, Zyxel, Ubiquiti, Linksys", level: "Веб-панель", details: "Выбор модели и открытие локальной панели администратора. Универсальная блокировка для этих устройств не заявляется.")
]
