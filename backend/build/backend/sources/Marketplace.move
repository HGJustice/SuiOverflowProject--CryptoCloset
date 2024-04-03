module backend::Marketplace {
     use std::string::{Self, String};
    use std::option::{Self, Option};
    use sui::transfer;
    use sui::url::{Self, Url};
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::object_table::{Self, ObjectTable};
    use sui::event;
    use sui::coin::{Self, Coin};

    use backend::UserManagment::{Listing};

    struct MarketPlace<phantom COIN> has key {
        id: UID,
        items: Listing,
        payments: ObjectTable<address, Coin<COIN>>
    }
}