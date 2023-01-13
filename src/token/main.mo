import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

actor Token {

    // Debug.print("Hello");

    // variable's name : variable's type = variable's value
    let owner : Principal = Principal.fromText("udmjy-up4ui-xnyyy-3mhgx-4pte4-sl6ok-n67yk-pdjik-eowui-trcmf-lqe");
    let totalSupply : Nat = 1000000000;
    let symbol : Text = "MTOKEN";

    private stable var balanceEntries: [(Principal, Nat)] = [];

    //ledger = data store that stores th id of a particular user or canister and the amount of tokens they have
    // class HashMap<K, V>(initiCapacity: Nat, keyEq: (K, K) -> Bool, keyHash : K -> Hash.Hash)
    private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);
    //set initial balance with the owner entry in case of first deployment
    if (balances.size() < 1) {
        balances.put(owner, totalSupply);
    };

    public query func balanceOf(who: Principal) : async Nat {
        let balance : Nat = switch(balances.get(who)) {
            case null 0;
            case (?result) result; 
        };

        return balance;
    };

    public query func getSymbol() : async Text {
        return symbol;
    };

    public shared(msg) func payOut(): async Text{
        // Debug.print(debug_show(msg.caller));
        if (balances.get(msg.caller) == null) {
            let amount = 10000;
            let result = await transfer(msg.caller, amount);
            return result;
        } else {
            return "Already claimed!"
        }
    };

    public shared(msg) func transfer(to: Principal, amount: Nat) : async Text {
        let fromBalance = await balanceOf(msg.caller);
        if (fromBalance > amount) {
            let newFromBalance : Nat = fromBalance - amount;
            balances.put(msg.caller, newFromBalance);
            let toBalance = await balanceOf(to);
            let newToBalance : Nat = toBalance + amount;
            balances.put(to, newToBalance);
            return "Success";
        } else {
            return "Insufficient Funds";
        };
    };


    // faire persister les données du Hashmap "balance" (Hashmap ne peut pas être une stable variable)

    // 1 - save the data from Hashmap balance in an stable array
    // the system method preupgrade is triggered before the upgrade
    system func preupgrade(){
        // shift the entries (iterables) of the Balances Hashmap into tge array balancesEntries
        balanceEntries := Iter.toArray(balances.entries());
    };

    // 2 - get the data from balanceEntries and transform it in Hashmap 
    // the system method postupgrade is triggered shortly after the upgrade
    system func postupgrade(){
        balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);
        //set initial balance with the owner entry when upgrades after first deployment
        if (balances.size() < 1) {
            balances.put(owner, totalSupply);
        };
    };
}