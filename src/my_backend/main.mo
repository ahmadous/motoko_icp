import Array "mo:base/Array";
import Int "mo:base/Int";
actor {
  // Define the structure for a transaction
  type Transaction = {
    phoneNumber: Text;
    amount: Int;
    reason: Text;
  };

  // Stable variable to hold the list of transactions
  stable var transactions: [Transaction] = [];

  // Function for adding a transaction
  public func addTransaction(newTransaction: Transaction) : async () {
    transactions := Array.append(transactions, [newTransaction]);
  };

  // Asynchronous function for data top-up
  public func topUp(phoneNumber: Text, amount: Int, reason: Text) : async Text {
    if(amount < 0) {
      return "ce montant n'existe pas veuillez reeessayer";
    };
     if (phoneNumber.size() < 10) {
      return "Erreur : Numéro de téléphone invalide.";
    };
    let newTransaction: Transaction = {
      phoneNumber = phoneNumber;
      amount = amount;
      reason = reason;
    };

    // Add the transaction
    await addTransaction(newTransaction);
    return "Recharge successful for " # phoneNumber # " with amount " # Int.toText(amount);
  };
  // Query function to get all transactions
  public query func getTransactions() : async [Transaction] {
    return transactions;
  };

  // Query function to get total balance
  public query func getBalance() : async Int {
    var totalBalance: Int = 0;
    for (transaction in transactions.vals()) {
      totalBalance += transaction.amount;
    };
    return totalBalance;
  };

  // Query function to filter transactions by phone number
  public query func getTransactionsByPhone(phoneNumber: Text) : async [Transaction] {
    return Array.filter<Transaction>(transactions, func (t: Transaction) : Bool {
      t.phoneNumber == phoneNumber;
    });
  };

}