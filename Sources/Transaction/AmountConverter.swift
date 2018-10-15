/// A type that can convert a transaction's amount to a format consumable by a third-party payment provider, such as Stripe or PayPal.
public protocol AmountConverter {
    
    /// The type used to represent a currency by the Swift API that wraps a payment provider.
    associatedtype Currency: CurrencyProtocol
    
    /// The type used by a payment provider's API as the amount of a transaction.
    associatedtype ProviderAmount: Codable
    
    /// Converts the amount of a transaction for a given currency to a format consumable by the third-party payment provider.
    ///
    /// - Parameters:
    ///   - amount: The amount for a transaction to convert.
    ///   - currency: The currency of the amount passed in.
    ///
    /// - Returns: The formatted amount.
    func amount(for amount: Int, as currency: Currency) -> ProviderAmount
}
