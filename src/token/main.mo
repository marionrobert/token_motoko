import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";

actor Token {

    // variable's name : variable's type = variable's value
    var owner : Principal = Principal.fromText("udmjy-up4ui-xnyyy-3mhgx-4pte4-sl6ok-n67yk-pdjik-eowui-trcmf-lqe");
    var totalSupply : Nat = 1000000000;
    var symbol : Text = "MTOKEN";

    //ledger = data store that stores th id of a particular user or canister and the amount of tokens they have
    // class HashMap<K, V>(initiCapacity: Nat, keyEq: (K, K) -> Bool, keyHash : K -> Hash.Hash)
    var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);
    balances.put(owner, totalSupply);

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
}