pragma solidity ^0.4.18;

contract SubscriptionWallet {
    address public owner;

    mapping (address => Subscription) subscriptions;
    address[] subscriptionIssuers;

   

    struct Subscription {
        bytes32 subscriptionName;
        bytes32 issuerName;
        uint cycleStart;
        uint subscriptionTimeFrame;
        uint maxAmount;
        uint withdrawnAmount;
        bool approved;
    }

     //creator
    function SubscriptionWallet() {
        owner = msg.sender;
    }    


    function addSubscription (address _issuer,
                            string _subscriptionName,
                            string _cycleStart,
                            uint _subscriptionTimeFrame,
                            uint _maxAmount) public {
        
        var newSub = subscriptions[_issuer];

        newSub.subscriptionName = _subscriptionName;
        newSub.issuerName = _issuerName;
        newSub.cycleStart = block.timestamp;
        newSub.subscriptionTimeFrame = _subscriptionTimeFrame;
        newSub.maxAmount = _maxAmount;
        newSub.withdrawnAmount = _withdrawnAmount;
        newSub.approved = true;

        subscriptionIssuers.push(_issuer);
        return true;
    }

    function getSubscriptionIssuers() view public returns(address[]) {
        return subscriptionIssuers;
    }

    function getSubscrition(address _issuer) view public returns(string,string,uint,uint,uint,bool){
        var s = subscriptions[_issuer]; 
        return (s.subscriptionName,
        s.issuerName,
        s.cycleStart,
        s.subscriptionTimeFrame,
        s.maxAmount,
        s.withdrawnAmount,
        s.approved);
    }

    function activateSubscription(address _issuer) public {
        subscriptions[_issuer].approved = true;
    }

    function deactivateSubscription(address _issuer) public {
        subscriptions[_issuer].approved = false;
    }



    function withdrawForSubscription(uint amount) public {
        var s =  subscriptions[msg.sender];

        //put into modifier https://www.youtube.com/watch?v=HGw-yalqdgs
        if(s.cycleStart+subscriptionTimeFrame<block.timestamp) {
            subscriptions[msg.sender].subscriptionTimeFrame = block.timestamp;
            subscriptions[msg.sender].withdrawnAmount = 0;
        } 
        require(s.maxAmount<=amount+s.withdrawnAmount, "Subscription is used up no funds withdrawn");
        msg.sender.transfer(amount);
    }

    function removeSubscription (address _issuer) public
    {
        delete subscriptions[_issuer];

    }

    //receive payment.
    function () payable {

    }

    //only callable by owner need to integrate this
    function withdrawFunds(uint amount) public {

        owner.transfer(amount);
    }


    function getBalance() public returns (unit) {
        return address(this).balance;
    }


}