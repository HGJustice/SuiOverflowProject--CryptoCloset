module backend::UserManagment {
    use std::option::{Self, Option};
    use std::string::{Self, String};

    use sui::transfer;
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContent};
    use sui::url::{Self, Url};
    use sui::coin::{Self, Coin};
    use sui::object_table::{Self, ObjectTable};
    use sui::event;

    const USER_ALREADY_CREATED: u64 = 1;

    struct User has key {
        id: UID, 
        firstName: String,
        lastName: String,
        dob: u64,
        phoneNumber: u64,
        email: String, 
        username: String
        userAddress: address,
    }

    struct UserCreated has copy, drop {
        id: ID.
        username: String,
        userAddress: address,
    }

}