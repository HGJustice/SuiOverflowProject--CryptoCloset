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

    use backend::UserManagment::{Self, Listing, User, UserHub};

    struct MarketPlace<phantom COIN> has key {
        id: UID,
        items: ObjectTable<u64, Listing>,
        payments: ObjectTable<address, Coin<COIN>>
    }

    public fun listItem<COIN>(marketplace: &mut MarketPlace<COIN>, ctx: &mut TxContext, userhub: &UserHub){
        let user = UserManagment::get_users(userhub, tx_context::sender(ctx));
        let listing = UserManagment::get_user_listings(user, 1);
        object_table::add(&mut marketplace.items, UserManagment::get_listing_counter(listing), listing);
    }
}