import Foundation

final class CallStation {
    var usersSet = Set<User>()
    var callsSet: [Call] = []
    var currentCallSet: [Call] = []
}

extension CallStation: Station {
    func users() -> [User] {
        Array(usersSet)
    }
    
    func add(user: User) {
        usersSet.insert(user)
    }
    
    func remove(user: User) {
        usersSet.remove(user)
    }
    
    func execute(action: CallAction) -> CallID? {
        switch action{
        case .start(from: let fromUser, to: let toUser):
            let id = CallID()
            var status: CallStatus = .calling
            if !usersSet.contains(fromUser){
                return nil
            }
            if !usersSet.contains(toUser){
                let objCall = Call(id: id, incomingUser: fromUser, outgoingUser: toUser, status: .ended(reason: .error))
                callsSet.insert(objCall, at: 0)
                return objCall.id
            }
            let currentCall = currentCallSet.first(where: {$0.outgoingUser.id == toUser.id})
            if (currentCall != nil) {
                status = .ended(reason: .userBusy)
            }
            let objCall = Call(id: id, incomingUser: fromUser, outgoingUser: toUser, status: status)
            callsSet.insert(objCall, at: 0)
            if (currentCall == nil) {
                currentCallSet.insert(objCall, at: 0)
            }
            return id
            
        case .answer(from: let otuUser):
            guard let call = callsSet.first(where: {$0.outgoingUser.id == otuUser.id}) else { return nil }
            callsSet.removeAll(where: {$0.id == call.id})
            if !usersSet.contains(otuUser){
                let objCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .ended(reason: .error))
                currentCallSet.removeAll(where: {$0.id == call.id})
                callsSet.insert(objCall, at: 0)
                return nil
            }
            let objCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .talk)
            callsSet.insert(objCall, at: 0)
            return call.id
            
        case .end(from: let outUser):
            guard let call = callsSet.first(where: {$0.outgoingUser.id == outUser.id || $0.incomingUser.id == outUser.id}) else { return nil }
            callsSet.removeAll(where: {$0.id == call.id})
            currentCallSet.removeAll(where: {$0.id == call.id})
            
            var status: CallStatus = .ended(reason: .end)
            
            if call.status == .calling{
                status = .ended(reason: .cancel)
            }
            callsSet.insert(Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: status), at: 0)
            return call.id
        }
    }
    
    func calls() -> [Call] {
        Array(callsSet)
    }
    
    func calls(user: User) -> [Call] {
        callsSet.filter({$0.incomingUser.id == user.id || $0.outgoingUser.id == user.id})
    }
    
    func call(id: CallID) -> Call? {
        callsSet.first(where: {$0.id == id})
    }
    
    func currentCall(user: User) -> Call? {
        currentCallSet.first(where: {$0.incomingUser.id == user.id || $0.outgoingUser.id == user.id})
    }
}
