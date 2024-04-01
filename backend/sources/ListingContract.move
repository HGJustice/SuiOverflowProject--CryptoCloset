module backend::ListingContract {
    use std::string::{Self, String};
    use std::option::{Self, Option};
    use sui::transfer;
    use sui::url::{Self, Url};
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::object_table::{Self, ObjectTable};
    use sui::event;

    use backend::UserManagment::{User, UserHub};

    struct Listing has key, store {
        id: UID,
        picture: Url,
        owner: address,
        description: String, 
        category: String, 
        brand: String,
        condition: String,
        price: u64,
        counter: u64,
    }

    struct ListingCreated has copy, drop {
        id: ID,
        owner: address,
        brand: String,
        price: u64,
    }

    public entry fun create_listing(picture: vector<u8>, description: vector<u8>, category:vector<u8>, brand:vector<u8>, condition:vector<u8>,
                                                                                                            price: u64, _ctx: &mut TxContext) {
  
        let id = object::new(_ctx);

        event::emit(
            ListingCreated{
                id: object::uid_to_inner(&id),
                owner: tx_context::sender(_ctx),
                brand: string::utf8(brand),
                price: price,
            }
        );

       let thisCounter = 0;

        let newListing = Listing{
            id: id,
            picture: url::new_unsafe_from_bytes(picture),
            owner: tx_context::sender(_ctx),
            description: string::utf8(description),
            category: string::utf8(category),
            brand: string::utf8(brand),
            condition: string::utf8(condition),
            price: price,
            counter: thisCounter + 1,
        };

        object_table::add(&mut User.listing, thisCounter, newListing );
    }

}