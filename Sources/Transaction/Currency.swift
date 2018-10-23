/// A valid currency type for a payment to a payment provider. This will often be an enum with a `String` raw value
/// or a struct with static properties that decodes/encodes a single string
///
///     enum Currency: String, Codable {
///         case eur
///         case usd
///         // Other cases
///     }
///
///     struct Currency: RawValue, Codable {
///         let rawValue: String
///
///         static let eur = Currency(rawValue: "EUR")
///         static let usd = Currency(rawValue: "USD")
///         // Other cases
///     }
///
/// - Note: This type does _not_ conform to `RawRepresentable` to remove `Self` type constraints.
public protocol CurrencyProtocol: Codable {
    init?(rawValue: String)
    
    var rawValue: String { get }
}
