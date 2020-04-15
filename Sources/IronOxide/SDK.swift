import libironoxide

public struct SDK {
    var ironoxide: OpaquePointer

    init(_ instance: OpaquePointer){
        ironoxide = instance
    }

    /******************
    *  USER OPS
    *******************/
    public func userListDevices(){

    }

    public func userGetPublicKey(){

    }

    public func userDeleteDevice(){

    }

    public func userRotatePrivateKey(){

    }

    /******************
    *  DOCUMENT OPS
    *******************/
    public func documentList(){

    }

    public func documentGetMetadata(){

    }

    public func documentGetIdFromBytes(){

    }

    public func documentEncrypt(){

    }

    public func documentUpdateBytes(){

    }

    public func documentDecrypt(){

    }

    public func documentUpdateName(){

    }

    public func documentGrantAccess(){

    }

    public func documentRevokeAccess(){

    }

    public func advancedDocumentEncryptUnmanaged(){

    }

    public func advancedDocumentDecryptUnmanaged(){

    }

    /******************
    *  GROUP OPS
    *******************/

    public func groupList(){

    }

    public func groupGetMetadata(){

    }

    public func groupCreate(){

    }

    public func groupUpdateName(){

    }

    public func groupDelete(){

    }

    public func groupAddMembers(){

    }

    public func groupRemoveMembers(){

    }

    public func groupAddAdmins(){

    }

    public func groupRemoveAdmins(){

    }

    public func groupRotatePrivateKey(){

    }

    /******************
    *  SEARCH OPS
    *******************/

    public func createBlindIndex(){

    }

    /******************
    *  MISC OPS
    *******************/

    public func clearPolicyCache(){

    }
}