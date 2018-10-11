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
public protocol CurrencyProtocol: Codable {
    init?(rawValue: String)
    
    var rawValue: String { get }
}


/// A codable type to wrapping a type-erased`CurrencyProtocol` instance.
///
///     let currency: CurrencyProtocol = Currency.usd
///     let wrapper = CurrencyType(currency)
struct CurrencyType: Codable {
    
    /// The base currency instance used to create this `CurrencyType` instance. This is not encoded or decoded.
    var wrapped: CurrencyProtocol?
    
    /// The currency code from the `CurrencyProtocol` instance passed into the initializer.
    var code: String
    
    /// Creates a new `CurrencyType` instance.
    ///
    /// - Parameter currency: The `CurrencyProtocol` instance to get the currency code from.
    init(_ currency: CurrencyProtocol) {
        self.wrapped = currency
        self.code = currency.rawValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.code = try container.decode(String.self)
        self.wrapped = nil
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.code)
    }
}
