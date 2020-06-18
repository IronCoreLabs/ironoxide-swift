# IronOxide-Swift

The IronOxide-Swift SDK is a library that integrates IronCore's privacy, security, and data control solution into
your Swift application. Operations in the IronOxide-Swift SDK are performed in the context of a user or backend service account. This
SDK supports all possible operations that work in the IronCore platform including creating and managing users and groups, encrypting
and decrypting document bytes, and granting and revoking access to documents to users and groups.

# User Operations

Users are the basis of IronOxide-Swift's functionality. Each user is a unique identity that has its own public/private key-pair. Users must always act
through devices. A device is authorized using a user's private encryption key and is therefore tightly bound to that user. Data can be never be encrypted
directly to a device, so devices can be considered ephemeral as there is no penalty for deleting a device and creating a new one.

This SDK provides all the necessary functionality to manage users and devices. Users can be created, fetched, listed, and updated, while devices can be created
and deleted all using `UserOperations`.

### Creating a User

Creating a user with
[userCreate](Functions.html#/s:9IronOxide10userCreate3jwt8password7options7timeouts6ResultOyAA04UserdI0CAA0aB5ErrorOGSS_SSAA0jD4OptsCAA8DurationCSgtF)
requires a valid IronCore or Auth0 JWT as well as the desired password that will be used to encrypt and escrow the user's private key. Until they generate
a device, this user will be unable to make any SDK calls.

### Generating a Device

Generating a device with
[generateNewDevice](Functions.html#/s:9IronOxide17generateNewDevice3jwt8password7options7timeouts6ResultOyAA0e3AddJ0CAA0aB5ErrorOGSS_SSAA0E10CreateOptsCAA8DurationCSgtF)
requires a valid IronCore or Auth0 JWT corresponding to the desired user, as well as the user's password (needed to decrypt the user's escrowed private key).
The resulting `DeviceContext` can then be used to initialize the SDK.

### Initializing the SDK

With [`initialize`](Functions.html#/s:9IronOxide10initialize6device6configs6ResultOyAA3SDKCAA0aB5ErrorOGAA13DeviceContextC_AA0aB6ConfigCtF),
you can use a `DeviceContext` to create an instance of the `SDK` object that can be used to make calls using the provided device.
All calls made with this `SDK` will use the user's provided device.

# Group Operations

Groups are one of the many differentiating features of the Data Control Platform. Groups are collections of users who share access permissions.
Group members are able to encrypt and decrypt documents using the group, and group administrators are able to update the group and modify its membership.
Members can be dynamically added and removed without the need to re-encrypt the data. This requires a series of cryptographic operations
involving the administrator's keys, the group’s keys, and the new member’s public key. By making it simple to control group membership,
we provide efficient and precise control over who has access to what information!

This SDK allows for easy management of your cryptographic groups. Groups can be created, fetched, updated, and deleted using `GroupOperations`.

### Creating a Group

For simple group creation, the
[GroupOperations.create](Structs/GroupOperations.html#/s:9IronOxide15GroupOperationsV6create15groupCreateOptss6ResultOyAA0cgI0CAA0aB5ErrorOGAA0cgH0C_tF)
function can be called with default values.

# Document Operations

All secret data that is encrypted using the IronCore platform is referred to as documents. Documents wrap the raw bytes of
secret data to encrypt along with various metadata that helps convey access information to that data. Documents can be encrypted,
decrypted, updated, granted to users and groups, and revoked from users and groups using `DocumentOperations`.

### Encrypting a Document

For simple encryption to self, the
[DocumentOperations.encrypt](Structs/DocumentOperations.html#/s:9IronOxide18DocumentOperationsV7encrypt5bytes7optionss6ResultOyAA0c7EncryptH0CAA0aB5ErrorOGSays5UInt8VG_AA0cI4OptsCtF)
function can be called with default values.

### Decrypting a Document

Decrypting a document is even simpler, as the only thing required by
[DocumentOperations.decrypt](Structs/DocumentOperations.html#/s:9IronOxide18DocumentOperationsV7decrypt14encryptedBytess6ResultOyAA0c7DecryptH0CAA0aB5ErrorOGSays5UInt8VG_tF)
is the bytes of the encrypted document.
